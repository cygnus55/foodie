from hmac import digest
import json
from hashlib import md5
import random
import string

from django.contrib.auth import login, logout, authenticate
from django.contrib import messages
from django.shortcuts import render, redirect

from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response
from rest_framework.authtoken.models import Token
from rest_framework.status import (
    HTTP_403_FORBIDDEN,
    HTTP_200_OK,
    HTTP_401_UNAUTHORIZED,
    HTTP_400_BAD_REQUEST,
)
from rest_framework.authentication import TokenAuthentication
from rest_framework.views import APIView

from api import customauthentication
from accounts.models import User
from api import twilio_utils
from customers.models import Customer
from cart.models import Cart
from accounts.serializers import UserSerializer
from accounts.custompermissions import IsCurrentUserOwner
from accounts.models import User
from accounts.forms import LoginForm


@api_view(["POST"])
@permission_classes([AllowAny])
def send_otp_code(request):
    data = {}
    reqBody = json.loads(request.body)
    if "mobile" in reqBody:
        mobile = reqBody["mobile"]
        twilio_utils.send(mobile)
        data["msg"] = "OTP sent!"
        data["mobile"] = mobile
        return Response(data, status=HTTP_200_OK)
    else:
        data["error"] = "Mobile number not provided."
        return Response(data, status=HTTP_403_FORBIDDEN)


@api_view(["POST"])
@permission_classes([AllowAny])
def customer_login(request):
    data = {}
    reqBody = json.loads(request.body)
    if "mobile" and "otp" in reqBody:
        mobile = reqBody["mobile"]
        otp_code = reqBody["otp"]
        if not twilio_utils.check(mobile, otp_code):
            data["error"] = "Invalid OTP"
            return Response(data, status=HTTP_401_UNAUTHORIZED)

        try:
            user = User.objects.get(mobile=mobile)

            if not user.is_customer:
                data["error"] = "Invalid login!"
                return Response(data, status=HTTP_403_FORBIDDEN)

            token, _ = Token.objects.get_or_create(user=user)
            data["success"] = "User Login"
        except User.DoesNotExist:
            # register user
            user = User.objects.create(
                username=mobile,
                mobile=mobile,
                is_verified=True,
                is_customer=True,
            )
            user.set_unusable_password()
            user.save()
            customer = Customer.objects.create(user=user)
            Cart.objects.create(customer=customer)
            token = Token.objects.create(user=user)
            data["success"] = "New user created"

        if user.is_active:
            login(request, user)
            data["token"] = token.key
            data["mobile"] = mobile
            return Response(data, status=HTTP_200_OK)

        else:
            data["error"] = "User is not active"
            return Response(data, status=HTTP_403_FORBIDDEN)
    else:
        data["error"] = "Mobile number or OTP code not provided."
        return Response(data, status=HTTP_403_FORBIDDEN)


@api_view(["POST"])
@permission_classes([AllowAny])
def delivery_person_login(request):
    message = {}
    req_body = json.loads(request.body)

    if "mobile" and "password" in req_body:
        mobile = req_body["mobile"]
        password = req_body["password"]

        try:
            user = User.objects.get(mobile=mobile)
        except User.DoesNotExist:
            message["error"] = "User with that credentials doesn't exist!"
            return Response(message, status=HTTP_403_FORBIDDEN)

        if not user.is_active:
            message["error"] = "User is not active!"
            return Response(message, status=HTTP_403_FORBIDDEN)

        if not user.is_delivery_person:
            message["error"] = "Invalid login!"
            return Response(message, status=HTTP_403_FORBIDDEN)

        user = authenticate(request, username=mobile, password=password)

        if not user:
            message["error"] = "Cannot log in user. Wrong credentials provided!"
            return Response(message, status=HTTP_403_FORBIDDEN)

        message["first_login"] = not user.delivery_person.has_logged_once

        login(request, user)
        token, _ = Token.objects.get_or_create(user=user)
        message["token"] = token.key
        message["mobile"] = mobile
        message["success"] = "User logged in!"
        return Response(message, status=HTTP_200_OK)
    else:
        message["error"] = "Required credentials for logging in not provided!"
        return Response(message, status=HTTP_403_FORBIDDEN)


def restaurant_login(request):
    if request.method == "POST":
        next_url = request.GET.get("next")
        form = LoginForm(data=request.POST)
        if form.is_valid():
            username = form.cleaned_data.get("mobile")
            password = form.cleaned_data.get("password")
            try:
                _user = User.objects.get(username=username)
            except Exception as e:
                print(e, "*")
                messages.error(request, "Username or password incorrect!")
                return redirect("accounts:restaurant_login")

            user = authenticate(request, username=username, password=password)

            if not user:
                messages.error(request, "Username or password incorrect!")
                return redirect("accounts:restaurant_login")

            if user.is_active:
                login(request, user)
                if next_url:
                    messages.success(request, "Successfully logged in user!")
                    return redirect(next_url)
                if not user.is_restaurant:
                    messages.error(request, "Wrong credentials provided!")
                    return redirect("accounts:restaurant_login")
                messages.success(request, "Successfully logged in user!")
                return redirect("restaurants:restaurant_home")
            messages.error(request, "Permission denied! The user is not active!")
            return redirect("accounts:restaurant_login")
    else:
        form = LoginForm()

    return render(request, "accounts/login.html", {"form": form})


# Logout view

@api_view(["GET"])
@permission_classes([IsAuthenticated])
def account_logout(request):
    Token.delete(request.user.auth_token)
    logout(request)
    data = {}
    data["success"] = "User logged out"
    return Response(data, status=HTTP_200_OK)


class AccountDetails(APIView):
    permission_classes = [
        IsAuthenticated,
        IsCurrentUserOwner
    ]
    authentication_classes = [
        TokenAuthentication,
        customauthentication.CsrfExemptSessionAuthentication
    ]

    def get(self, request, format=None):
        user = request.user
        serializers = UserSerializer(user)
        return Response(serializers.data, status=HTTP_200_OK)

    def put(self, request, format=None):
        user = request.user
        serializer = UserSerializer(user, data=request.data)
        if serializer.is_valid():
            serializer.save()
            if "full_name" in request.data:
                change_profile_pic(request.user)
            return Response(serializer.data, status=HTTP_200_OK)
        return Response(serializer.errors, status=HTTP_400_BAD_REQUEST)

    def patch(self, request, format=None):
        user = request.user
        serializer = UserSerializer(user, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            if "full_name" in request.data:
                change_profile_pic(request.user)
            return Response(serializer.data, status=HTTP_200_OK)
        return Response(serializer.errors, status=HTTP_400_BAD_REQUEST)


def change_profile_pic(user):
    if user.is_customer:
        customer = user.customer
        if "ui-avatars" in customer.profile_picture or not customer.profile_picture:
            colors = ["b88232", "3632b8", "b3452d",
                      "b32d46", "88b02c", "4531b5", "2eab47"]
            color = random.choice(colors)
            name = str(user.full_name.title()).replace(" ", "+")
            customer.profile_picture = f"https://ui-avatars.com/api/?background={color}&rounded=true&name={name}"
            customer.save()
    elif user.is_restaurant:
        strg = user.full_name.lower()
        strg.join(random.choice(string.ascii_letters) for i in range(10))
        digest = md5(strg.encode("utf-8")).hexdigest()
        restaurant = user.restaurant
        if "gravatar" in restaurant.logo or not restaurant.logo:
            restaurant.logo = f"https://www.gravatar.com/avatar/{digest}?d=identicon"
            restaurant.save()
    elif user.is_delivery_person:
        strg = user.full_name.lower()
        strg.join(random.choice(string.ascii_letters) for i in range(10))
        digest = md5(strg.encode("utf-8")).hexdigest()
        delivery_person = user.delivery_person
        if "gravatar" in delivery_person.profile_picture:
            delivery_person.profile_pic = f"https://www.gravatar.com/avatar/{digest}?d=retro"
            delivery_person.save()
