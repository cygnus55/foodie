import random
import string
from hashlib import md5

import cloudinary

from django.contrib import messages
from django.contrib.admin.views.decorators import staff_member_required
from django.contrib.auth.mixins import LoginRequiredMixin, UserPassesTestMixin
from django.contrib.auth.decorators import login_required, user_passes_test
from django.core.exceptions import PermissionDenied
from django.core.mail import send_mail
from django.db.models.functions import TruncMonth, TruncDate
from django.db.models import Count
from django.http import JsonResponse
from django.shortcuts import render, redirect, get_object_or_404
from django.template.loader import render_to_string
from django.urls import reverse_lazy
from django.utils.html import strip_tags
from django.views.generic import (
    CreateView,
    UpdateView,
    DeleteView,
    ListView,
    DetailView,
)
from rest_framework.authentication import TokenAuthentication
from rest_framework.generics import (
    ListCreateAPIView,
    RetrieveUpdateDestroyAPIView,
)
from rest_framework.permissions import IsAuthenticatedOrReadOnly

from accounts.models import User
from api import customauthentication, custompermissions
from restaurants.models import Restaurant
from foods.models import Food, FoodTemplate
from restaurants.serializers import RestaurantSerializer
from restaurants.custompermissions import (
    IsCurrentUserAlreadyAnOwner,
    IsCurrentUserOwnerOrReadOnly,
)
from restaurants.forms import RestaurantRegistrationForm, RestaurantNameUpdateForm, RestaurantAccountUpdateForm, CustomChangePasswordForm
from orders.models import Order


class RestaurantList(ListCreateAPIView):
    serializer_class = RestaurantSerializer
    permission_classes = [
        IsAuthenticatedOrReadOnly,
        custompermissions.IsCurrentUserRestaurant,
        IsCurrentUserAlreadyAnOwner,
        IsCurrentUserOwnerOrReadOnly
    ]
    authentication_classes = [
        TokenAuthentication,
        customauthentication.CsrfExemptSessionAuthentication
    ]

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)

    def get_queryset(self):
        queryset = Restaurant.objects.all()
        latitude = self.request.query_params.get("lat", None)
        longitude = self.request.query_params.get("lng", None)
        top_rated = self.request.query_params.get("top_rated", None)
        favorite = self.request.query_params.get("favorite", None)

        if latitude and longitude:
            # for every queryset, calculate distance from the given lat and lng and filter if distance is less than 4km
            for q in queryset:
                if q.distance(latitude, longitude) > 10:
                    queryset = queryset.exclude(id=q.id)
        if top_rated:
            for q in queryset:
                if q.average_ratings <= 3:
                    queryset = queryset.exclude(id=q.id)
        if favorite:
            if self.request.user.is_authenticated and self.request.user.is_customer:
                for q in queryset:
                    if q.customer_favourite_status(id=self.request.user.customer.id) == False:
                        queryset = queryset.exclude(id=q.id)
        return queryset


class RestaurantDetails(RetrieveUpdateDestroyAPIView):
    queryset = Restaurant.objects.all()
    serializer_class = RestaurantSerializer
    permission_classes = [
        IsAuthenticatedOrReadOnly,
        custompermissions.IsCurrentUserRestaurant,
        IsCurrentUserOwnerOrReadOnly,
    ]
    authentication_classes = [
        TokenAuthentication,
        customauthentication.CsrfExemptSessionAuthentication
    ]


# Restaurant front-end

@staff_member_required
@login_required
def register(request):
    if request.method == "POST":
        form = RestaurantRegistrationForm(request.POST)
        if form.is_valid():
            full_name = form.cleaned_data.get("full_name")
            phone_no = form.cleaned_data.get("phone_number")
            email = form.cleaned_data.get("email")
            open_hour = form.cleaned_data.get("open_hour")
            close_hour = form.cleaned_data.get("close_hour")
            try:
                user = User.objects.create(
                    full_name=full_name,
                    mobile=phone_no,
                    username=phone_no,
                    email=email,
                    is_restaurant=True,
                    is_verified = True,
                )
                user.set_password(phone_no)
                user.save()
            except Exception as e:
                messages.error(request, e)
                return render(request, "restaurants/register.html", {"form": form})

            strg = user.full_name.lower()
            strg.join(random.choice(string.ascii_letters) for i in range(10))
            digest = md5(strg.encode("utf-8")).hexdigest()

            logo = f"https://www.gravatar.com/avatar/{digest}?d=identicon"

            try:
                resp = cloudinary.uploader.upload(logo)
                logo = resp["secure_url"]
            except Exception:
                logo = ""

            try:
                Restaurant.objects.create(
                    user=user,
                    logo=logo,
                    open_hour=open_hour,
                    close_hour=close_hour,
                    location=[None, None, None]
                )
            except Exception as e:
                user.delete()
                messages.error(request, e)
                return render(request, "restaurants/register.html", {"form": form})

            # send email
            subject = "Welcome to Foodie"
            html_message = render_to_string("restaurants/account_details_email.html", {"user": user})
            plain_message = strip_tags(html_message)
            from_email = "Foodie Administrative <foodexpressnepal@gmail.com>"
            to = user.email

            send_mail(subject, plain_message, from_email, [to], html_message=html_message, fail_silently=False)

            messages.success(request, f"Account created for restaurant {user.full_name}.")
            return redirect("admin:restaurants_restaurant_changelist")
    else:
        form = RestaurantRegistrationForm()
    return render(request, "restaurants/register.html", {"form": form})


def first_login_redirect(redirect_url, message=None):
    def decorator(f):
        def _wrapper(request, *args, **kwargs):
            message_text = message or "It seems that you have not updated your default password yet. Please update password to continue!"
            if request.user.restaurant.has_logged_once:
                return f(request, *args, **kwargs)
            if not redirect_url:
                return f(request, *args, **kwargs)
            messages.info(request, message_text)
            return redirect(redirect_url)
        return _wrapper
    return decorator


class FirstLoginRedirectMixin:
    def dispatch(self, request, *args, **kwargs):
        message_text = "It seems that you have not updated your default password yet. Please update password to continue!"
        redirect_url = "restaurants:change_password"
        if request.user.restaurant.has_logged_once:
            return super().dispatch(request, *args, **kwargs)
        messages.info(request, message_text)
        return redirect(redirect_url)


@login_required
@user_passes_test(lambda u: u.is_restaurant and u.is_active)
@first_login_redirect("restaurants:change_password")
def restaurant_dashboard(request):
    if not request.user.restaurant.has_location:
        # redirect the user(restaurant) to change location
        return redirect("restaurants:get_location")

    allowed_categories = ["month", "date"]
    order_category = request.GET.get("order_by", "date")

    if order_category not in allowed_categories:
        return redirect("restaurants:restaurant_home")

    if order_category == "month":
        sales = Order.objects.filter(status="Delivered") \
                                        .filter(items__food__restaurant=request.user.restaurant) \
                                        .annotate(month=TruncMonth("created")) \
                                        .values("month") \
                                        .annotate(count=Count("id")) \
                                        .order_by()
        labels = [sale["month"].strftime("%b %Y") for sale in sales]
    else:
        sales = Order.objects.filter(status="Delivered") \
                                        .filter(items__food__restaurant=request.user.restaurant) \
                                        .annotate(date=TruncDate("created")) \
                                        .values("date") \
                                        .annotate(count=Count("id")) \
                                        .order_by()

        labels = [sale["date"].strftime("%d %b %Y") for sale in sales]

    data = [sale['count'] for sale in sales]

    context = {
        "order_category": order_category,
        "labels": labels,
        "data": data,
        "sales": sales
    }

    return render(request, "restaurants/dashboard.html", context=context)


@login_required
@user_passes_test(lambda u: u.is_restaurant and u.is_active)
@first_login_redirect("restaurants:change_password")
def account_settings(request):
    if request.method == "POST":
        name_form = RestaurantNameUpdateForm(
            data=request.POST,
            files=request.FILES,
            instance=request.user,
        )
        account_form = RestaurantAccountUpdateForm(
            data=request.POST,
            files=request.FILES,
            instance=request.user.restaurant,
        )
        if name_form.is_valid() and account_form.is_valid():
            name_form.save()
            account_form.save()
            messages.success(request, "Profile successfully updated!")
            return redirect("restaurants:account_settings")
        else:
            messages.error(request, "Profile update failed!")
            return redirect("restaurants:account_settings")

    name_form = RestaurantNameUpdateForm(
        instance=request.user,
    )
    account_form = RestaurantAccountUpdateForm(
        instance=request.user.restaurant,
    )

    return render(
        request,
        "restaurants/account_settings.html",
        {"name_form": name_form, "account_form": account_form},
    )


@login_required
@user_passes_test(lambda u: u.is_restaurant and u.is_active)
def change_password(request):
    if request.method == "POST":
        form = CustomChangePasswordForm(request.user, data=request.POST)
        if form.is_valid():
            form.save()
            if not request.user.restaurant.has_logged_once:
                request.user.restaurant.has_logged_once = True
                request.user.restaurant.save()
            messages.success(request, "Password successfully updated! Login to continue to the dashboard!")
            return redirect("restaurants:restaurant_home")
        else:
            messages.error(request, "Password couldn't be updated!")
            return redirect("restaurants:change_password")

    form = CustomChangePasswordForm(request.user)
    return render(request, "restaurants/change_password.html", {"form": form})


class FoodCreateView(LoginRequiredMixin, UserPassesTestMixin, FirstLoginRedirectMixin, CreateView):
    model = Food
    fields = ["name", "description", "price", "is_available",
              "discount_percent", "is_veg", "image"]

    template_name = "restaurants/food_form.html"
    success_url = reverse_lazy("restaurants:food_list")

    def test_func(self):
        return self.request.user.is_active and self.request.user.is_restaurant

    def form_valid(self, form):
        form.instance.restaurant = self.request.user.restaurant
        return super().form_valid(form)

    def get_context_data(self, *args, **kwargs):
        template_id = self.kwargs.get("template_id")
        context = super().get_context_data(*args, **kwargs)
        context["templates"] = FoodTemplate.objects.all()
        context["page"] = "create"
        return context

    def get_initial(self):
        template_id = self.kwargs.get("template_id")
        data = super().get_initial()

        if template_id:
            template_instance = get_object_or_404(
                FoodTemplate, id=template_id)
            data["name"] = template_instance.name
            data["description"] = template_instance.description
            data["image"] = template_instance.image
            data["price"] = template_instance.price
            data["is_available"] = template_instance.is_available
            data["is_veg"] = template_instance.is_veg
            template_instance.usage += 1
            template_instance.save()

        return data


class FoodUpdateView(LoginRequiredMixin, UserPassesTestMixin, FirstLoginRedirectMixin, UpdateView):
    model = Food
    fields = ["name", "description", "price", "is_available",
            "discount_percent", "is_veg", "image"]
    template_name = "restaurants/food_form.html"
    success_url = reverse_lazy("restaurants:food_list")

    def test_func(self):
        return self.request.user.is_active and self.request.user.is_restaurant and self.get_object().restaurant == self.request.user.restaurant

    def form_valid(self, form):
        form.instance.restaurant = self.request.user.restaurant
        return super().form_valid(form)

    def get_context_data(self,*args, **kwargs):
        context = super().get_context_data(*args, **kwargs)
        context["page"] = "update"
        return context


class FoodDeleteView(LoginRequiredMixin, UserPassesTestMixin, FirstLoginRedirectMixin, DeleteView):
    model = Food
    success_url = reverse_lazy("restaurants:food_list")
    context_object_name = "food"
    template_name = "restaurants/food_delete.html"

    def test_func(self):
        return self.request.user.is_active and self.request.user.is_restaurant and self.get_object().restaurant == self.request.user.restaurant


class FoodListView(LoginRequiredMixin, UserPassesTestMixin, FirstLoginRedirectMixin, ListView):
    model = Food
    ordering = "-created"
    template_name = "restaurants/food_list.html"
    context_object_name = "foods"

    def test_func(self):
        return self.request.user.is_active and self.request.user.is_restaurant

    def get_queryset(self, **kwargs):
        restaurant_foods = self.model.objects.filter(restaurant=self.request.user.restaurant)
        return restaurant_foods.all()


class FoodDetailView(LoginRequiredMixin, UserPassesTestMixin, FirstLoginRedirectMixin, DetailView):
    model = Food
    template_name = "restaurants/food_detail.html"
    context_object_name = "food"

    def test_func(self):
        return self.request.user.is_active and self.request.user.is_restaurant and self.get_object().restaurant == self.request.user.restaurant


@login_required
@user_passes_test(lambda u: u.is_restaurant and u.is_active)
@first_login_redirect("restaurants:change_password")
def get_location(request):
    if request.method == "GET":
        restaurant = request.user.restaurant
        location = {
            "Latitude": restaurant.location[0] or "",
            "Longitude": restaurant.location[1] or "",
            "Address": restaurant.location[2] or ""
        }
        return render(request, "restaurants/location.html", {"location": location})


@login_required
@user_passes_test(lambda u: u.is_restaurant and u.is_active)
@first_login_redirect("restaurants:change_password")
def update_location(request):
    if request.method == "GET":
        restaurant = request.user.restaurant
        latitude = request.GET.get("latitude")
        longitude = request.GET.get("longitude")
        address = request.GET.get("address")
        restaurant.location = [latitude, longitude, address]
        restaurant.save()
        messages.success(request, "Location updated successfully.")
        return JsonResponse({"success": True})

