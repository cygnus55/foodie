import copy

from django.core.exceptions import ObjectDoesNotExist, PermissionDenied
from django.shortcuts import render
from django.views.generic import CreateView, UpdateView, DeleteView, ListView, DetailView
from django.contrib import messages
from django.contrib.auth.mixins import LoginRequiredMixin, UserPassesTestMixin
from django.urls import reverse_lazy
from django.contrib.auth.decorators import login_required

from rest_framework.authentication import TokenAuthentication
from rest_framework.generics import (
    ListCreateAPIView,
    RetrieveUpdateDestroyAPIView
)
from rest_framework.permissions import IsAuthenticatedOrReadOnly
from rest_framework.response import Response
from rest_framework.status import HTTP_403_FORBIDDEN, HTTP_404_NOT_FOUND

from api import customauthentication, custompermissions
from restaurants.models import Restaurant
from foods.models import Food
from restaurants.serializers import RestaurantSerializer
from restaurants.custompermissions import (
    IsCurrentUserAlreadyAnOwner,
    IsCurrentUserOwnerOrReadOnly
)


class RestaurantList(ListCreateAPIView):
    queryset = Restaurant.objects.all()
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


@login_required
def restaurant_dashboard(request):
    if not request.user.is_restaurant:
        return PermissionDenied()
    return render(request, "restaurants/dashboard.html")


class FoodCreateView(LoginRequiredMixin, UserPassesTestMixin, CreateView):
    model = Food
    fields = ["name", "description", "price", "is_available",
              "image", "discount_percent", "is_veg"]

    template_name = "restaurants/food_form.html"
    success_url = reverse_lazy("restaurants:food_list")

    def test_func(self):
        return self.request.user.is_active and self.request.user.is_restaurant

    def form_valid(self, form):
        form.instance.restaurant = self.request.user.restaurant
        return super().form_valid(form)

    def get_context_data(self, **kwargs):
        return super().get_context_data(**kwargs)


class FoodUpdateView(LoginRequiredMixin, UserPassesTestMixin, UpdateView):
    model = Food
    fields = ["name", "description", "price", "is_available",
              "image", "discount_percent", "is_veg"]
    template_name = "restaurants/food_form.html"
    success_url = reverse_lazy("restaurants:food_list")

    def test_func(self):
        return self.request.user.is_active and self.request.is_restaurant and self.get_object().restaurant == self.request.user.restaurant

    def form_valid(self, form):
        form.instance.restaurant = self.request.user.restaurant
        return super().form_valid(form)


class FoodDeleteView(LoginRequiredMixin, UserPassesTestMixin, DeleteView):
    model = Food
    success_url = reverse_lazy("restaurants:food_list")
    context_object_name = "food"
    template_name = "restaurants/food_delete.html"

    def test_func(self):
        return self.request.user.is_active and self.request.user.is_restaurant and self.get_object().restaurant == self.request.user.restaurant


class FoodListView(LoginRequiredMixin, UserPassesTestMixin, ListView):
    model = Food
    ordering = "-created"
    template_name = "restaurants/food_list.html"
    context_object_name = "foods"

    def test_func(self):
        return self.request.user.is_active and self.request.user.is_restaurant

    def get_queryset(self, **kwargs):
        restaurant_foods = self.model.objects.filter(restaurant=self.request.user.restaurant)
        return restaurant_foods.all()


class FoodDetailView(LoginRequiredMixin, UserPassesTestMixin, DetailView):
    model = Food
    template = "restaurants/food_detail.html"
    context_object_name = "food"

    def test_func(self):
        return self.request.user.is_active and self.request.user.is_restaurant and self.get_object().restaurant == self.request.user.restaurant