from hmac import digest
import json
from hashlib import md5
import random, string

from django.contrib.auth import login, logout
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

from accounts.models import User
from accounts import otp_verify
from customers.models import Customer
from accounts.serializers import UserSerializer
from accounts.custompermissions import IsCurrentUserOwner
from api import customauthentication


@api_view(['POST'])
@permission_classes([AllowAny])
def send_otp_code(request):
    data = {}
    reqBody = json.loads(request.body)
    if 'mobile' in reqBody:
        mobile = reqBody['mobile']
        otp_verify.send(mobile)
        data['msg'] = "OTP sent!"
        data['mobile'] = mobile
        return Response(data, status=HTTP_200_OK)
    else:
        data['error'] = "Mobile number not provided."
        return Response(data, status=HTTP_403_FORBIDDEN)


@api_view(['POST'])
@permission_classes([AllowAny])
def customer_login(request):
    data = {}
    reqBody = json.loads(request.body)
    if 'mobile' and 'otp' in reqBody:
        mobile = reqBody['mobile']
        otp_code = reqBody['otp']
        if not otp_verify.check(mobile, otp_code):
            data["error"] = "Invalid OTP"
            return Response(data, status=HTTP_401_UNAUTHORIZED)

        try:
            user = User.objects.get(mobile=mobile)
            token, _ = Token.objects.get_or_create(user=user)
            data['success'] = "User Login"
        except User.DoesNotExist:
            # register user
            user = User.objects.create(username=mobile, mobile=mobile, is_customer=True, is_verified=True)
            user.set_unusable_password()
            user.save()
            customer = Customer.objects.create(user=user)
            customer.save()
            token = Token.objects.create(user=user)
            data['success'] = "New user created"

        if user.is_active:
            login(request, user)
            data['token'] = token.key
            data['mobile'] = mobile
            return Response(data, status=HTTP_200_OK)

        else:
            data['error'] = "User is not active"
            return Response(data, status=HTTP_403_FORBIDDEN)
    else:
        data['error'] = "Mobile number or OTP code not provided."
        return Response(data, status=HTTP_403_FORBIDDEN)

# logout view


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def account_logout(request):
    Token.delete(request.user.auth_token)
    logout(request)
    data = {}
    data['success'] = "User logged out"
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
                change_profile_pic(request)
            return Response(serializer.data, status=HTTP_200_OK)
        return Response(serializer.errors, status=HTTP_400_BAD_REQUEST)

    def patch(self, request, format=None):
        user = request.user
        serializer = UserSerializer(user, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            if "full_name" in request.data:
                change_profile_pic(request)
            return Response(serializer.data, status=HTTP_200_OK)
        return Response(serializer.errors, status=HTTP_400_BAD_REQUEST)


def change_profile_pic(request):
    if request.user.is_customer:
        customer = request.user.customer
        if ("ui-avatars" in customer.profile_picture)or (not customer.profile_picture):
            colors = ["b88232", "3632b8", "b3452d", "b32d46", "88b02c", "4531b5", "2eab47"]
            color = random.choice(colors)
            name = str(request.user.full_name.title()).replace(" ", "+")
            customer.profile_picture = f"https://ui-avatars.com/api/?background={color}&rounded=true&name={name}"
            customer.save()
    elif request.user.is_restaurant:
        strg = request.user.full_name.lower()
        strg.join(random.choice(string.ascii_letters) for i in range(10))
        digest = md5(strg.encode('utf-8')).hexdigest()
        restaurant = request.user.restaurant
        if ("gravatar" in restaurant.logo) or (not restaurant.logo):
            restaurant.logo = f"https://www.gravatar.com/avatar/{digest}?d=identicon"
            restaurant.save()
