import copy
from hashlib import md5
import random
import string
import datetime

from django.shortcuts import redirect, render
from django.template.loader import render_to_string
from django.utils.html import strip_tags
from django.core.mail import send_mail
from django.contrib import messages
from django.contrib.admin.views.decorators import staff_member_required
from django.contrib.auth.decorators import login_required
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.authentication import TokenAuthentication
from rest_framework.response import Response
from rest_framework.status import HTTP_400_BAD_REQUEST, HTTP_200_OK

from accounts.models import User
from delivery_person.forms import DeliveryPersonForm
from delivery_person.models import DeliveryPerson
from delivery_person.custompermissions import HasCurrentUserAcceptedThisOrder, IsCurrentUserOwner
from api import customauthentication, custompermissions, twilio_utils
from delivery_person.serilizers import DeliveryPersonProfileSerializer
from orders.models import Order
from orders.serializers import OrderSerializer


@staff_member_required
@login_required
def register(request):
    if request.method == 'POST':
        form = DeliveryPersonForm(request.POST)
        if form.is_valid():
            full_name = form.cleaned_data.get('full_name')
            phone_no = form.cleaned_data.get('phone_number')
            email = form.cleaned_data.get('email')
            try:
                user = User.objects.create(
                    full_name=full_name,
                    mobile=phone_no,
                    username=phone_no,
                    email=email,
                    is_delivery_person=True,
                    is_verified = True
                )
                password = str(phone_no)
                if password.startswith("+977"):
                    password = phone_no[4:]
                user.set_password(password)
                user.save()
            except Exception as e:
                messages.error(request, e)
                return render(request, 'delivery_person/register.html', {'form': form})

            strg = user.full_name.lower()
            strg.join(random.choice(string.ascii_letters) for i in range(10))
            digest = md5(strg.encode("utf-8")).hexdigest()

            profile_picture = f"https://www.gravatar.com/avatar/{digest}?d=retro"

            DeliveryPerson.objects.create(user=user, profile_picture=profile_picture, location=[None, None])

            # send email
            subject = "Welcome to Foodie"
            html_message = render_to_string('delivery_person/account_details_email.html', {"user": user})
            plain_message = strip_tags(html_message)
            from_email = 'Foodie Adminstrative <foodexpressnepal@gmail.com>'
            to = user.email

            send_mail(subject, plain_message, from_email, [to], html_message=html_message, fail_silently=False)
            
            messages.success(request, f"Account created for delivery person {user.full_name}.")
            return redirect('admin:delivery_person_deliveryperson_changelist')
    else:
        form = DeliveryPersonForm()
    return render(request, 'delivery_person/register.html', {'form': form})


class ChangePassword(APIView):
    permission_classes = [
        IsAuthenticated,
        custompermissions.AllowOnlyDeliveryPerson,
        IsCurrentUserOwner
    ]
    authentication_classes = [
        TokenAuthentication,
        customauthentication.CsrfExemptSessionAuthentication
    ]


    def post(self, request, format=None):
        user = request.user
        password = request.data.get('password')
        user.set_password(password)
        user.save()
        user.delivery_person.has_logged_once = True
        user.delivery_person.save()
        return Response({"success": "Password changed successfully."},status=HTTP_200_OK)


class DeliveryPersonProfile(APIView):
    permission_classes = [
        IsAuthenticated,
        custompermissions.AllowOnlyDeliveryPerson,
        IsCurrentUserOwner,
    ]
    authentication_classes = [
        TokenAuthentication,
        customauthentication.CsrfExemptSessionAuthentication
    ]

    def get(self, request, format=None):
        delivery_person = request.user.delivery_person
        serializers = DeliveryPersonProfileSerializer(delivery_person)
        return Response(serializers.data, status=HTTP_200_OK)

    def put(self, request, format=None):
        delivery_person = request.user.delivery_person
        serializer = DeliveryPersonProfileSerializer(delivery_person, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=HTTP_200_OK)
        return Response(serializer.errors, status=HTTP_400_BAD_REQUEST)

    def patch(self, request, format=None):
        delivery_person = request.user.delivery_person
        serializer = DeliveryPersonProfileSerializer(
            delivery_person, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=HTTP_200_OK)
        return Response(serializer.errors, status=HTTP_400_BAD_REQUEST)


class NewOrderList(APIView):
    permission_classes = [
        IsAuthenticated,
        custompermissions.AllowOnlyDeliveryPerson,
    ]
    authentication_classes = [
        TokenAuthentication,
        customauthentication.CsrfExemptSessionAuthentication
    ]

    def get(self, request, format=None):
        location = request.user.delivery_person.location
        if location is None:
            return Response({"error": "Location not set."}, status=HTTP_400_BAD_REQUEST)
        orders = Order.unaccepted.all()
        for order in orders:
            if order.distance(location[0], location[1]) > 5:
                orders = orders.exclude(id=order.id)
        serializers = OrderSerializer(orders, many=True)
        response = copy.copy(serializers.data)
        for res in response:
            order = Order.objects.get(id=res['id'])
            res["customer"] = {
                "full_name": order.customer.user.full_name,
                "mobile": order.customer.user.mobile,
                "distance": order.distance(location[0], location[1])
            }
            restaurant_location = []
            for item in order.items.all():
                restaurant_location.append({
                    "name": item.food.restaurant.user.full_name,
                    "location": item.food.restaurant.location,
                    "distance": item.distance(location[0], location[1])
                })
            res["restaurant_location"] = restaurant_location
        return Response(response, status=HTTP_200_OK)


class AcceptOrder(APIView):
    permission_classes = [
        IsAuthenticated,
        custompermissions.AllowOnlyDeliveryPerson,
    ]
    authentication_classes = [
        TokenAuthentication,
        customauthentication.CsrfExemptSessionAuthentication
    ]

    def post(self, request, format=True):
        _order_id = request.data.get('order_id')
        order_id = int(_order_id.split('-')[1])
        order = Order.objects.get(id=order_id)
        if order.is_accepted:
            return Response({"error": "Order already accepted."}, status=HTTP_400_BAD_REQUEST)
        order.accepted_by = request.user.delivery_person
        order.is_accepted = True
        order.accepted_on = datetime.datetime.now()
        order.save()
        
        # send sms to user
        if order.status == "Placed":
            message_body = f"Your order {_order_id} has been accepted by {order.accepted_by.user.full_name}.\nYou will soon receive a call from him\her."
        elif order.status == "Verified":
            message_body = f"Your order {_order_id} has been accepted by {order.accepted_by.user.full_name}."
        twilio_utils.send_sms(order.customer.user.mobile,message_body)
        return Response({"success": "Order accepted."}, status=HTTP_200_OK)


class GetAcceptedOrder(APIView):
    permission_classes = [
        IsAuthenticated,
        custompermissions.AllowOnlyDeliveryPerson,
        HasCurrentUserAcceptedThisOrder
    ]
    authentication_classes = [
        TokenAuthentication,
        customauthentication.CsrfExemptSessionAuthentication
    ]

    def get(self, request, format=True):
        location = self.request.user.delivery_person.location
        orders = self.request.user.delivery_person.accepted_orders.all()
        serializers = OrderSerializer(orders, many=True)
        response = copy.copy(serializers.data)
        for res in response:
            order = Order.objects.get(id=res['id'])
            res["customer"] = {
                "full_name": order.customer.user.full_name,
                "mobile": order.customer.user.mobile,
                "distance": order.distance(location[0], location[1])
            }
            restaurant_location = []
            for item in order.items.all():
                restaurant_location.append({
                    "name": item.food.restaurant.user.full_name,
                    "location": item.food.restaurant.location,
                    "distance": item.distance(location[0], location[1])
                })
            res["restaurant_location"] = restaurant_location
        return Response(response, status=HTTP_200_OK)

    
class UpdateStatus(APIView):
    permission_classes = [
        IsAuthenticated,
        custompermissions.AllowOnlyDeliveryPerson,
        HasCurrentUserAcceptedThisOrder
    ]
    authentication_classes = [
        TokenAuthentication,
        customauthentication.CsrfExemptSessionAuthentication
    ]

    def post(self, request, format=True):
        _order_id = request.data.get('order_id')
        order_id = int(_order_id.split('-')[1])
        order = Order.objects.get(id=order_id)
        status = request.data.get('status')
        order.status = status
        order.save()
        # send sms to user
        if order.status == "Verified" or order.status == "Delivered" or order.status == "Cancelled":
            message_body = f"Your order {_order_id} has been {status.lower()}."
        elif order.status == "On the way to restaurant":
            message_body = f"Delivery person is on the way to restaurant. You will soon get your food."
            # send email to restaurants
            order.send_mail_to_restaurants()
        elif order.status == "Processing":
            message_body = f"Restaurant are preparing your food order."
        elif order.status == "Picking":
            message_body = f"Delivery person is picking your food."
        elif order.status == "On the way":
            message_body = f"Delivery person is on the way to your location."
        twilio_utils.send_sms(order.customer.user.mobile,message_body)
        return Response({"success": f"Order status updated to {status}"}, status=HTTP_200_OK)