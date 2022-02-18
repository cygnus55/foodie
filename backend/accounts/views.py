import json

from django.contrib.auth import login, logout
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny, IsAuthenticated, IsAuthenticatedOrReadOnly
from rest_framework.response import Response
from rest_framework.authtoken.models import Token
from rest_framework.status import (
    HTTP_403_FORBIDDEN,
    HTTP_200_OK,
    HTTP_401_UNAUTHORIZED
)
from rest_framework.generics import ListCreateAPIView, RetrieveUpdateDestroyAPIView
from rest_framework.permissions import IsAuthenticatedOrReadOnly
from rest_framework.authentication import TokenAuthentication

from api.custompermissions import IsCurrentUserCustomer
from .models import User
from . import otp_verify


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
            user = User.objects.create(username=mobile, mobile=mobile, is_customer=True)
            user.set_unusable_password()
            user.save()
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
        data['error'] = "Mobile number not provided."
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


# customer name view
@api_view(['GET', 'POST'])
@permission_classes([IsCurrentUserCustomer, IsAuthenticated])
def customer_name(request):
    if request.method == 'GET':
        data = {}
        name = request.user.full_name
        if name:
            data['name'] = request.user.full_name
        else:
            data['name'] = None
        return Response(data, status=HTTP_200_OK)
    elif request.method == 'POST':
        data = {}
        reqBody = json.loads(request.body)
        if 'name' in reqBody:
            name = reqBody['name']
            request.user.full_name = name
            request.user.save()
            data['success'] = "Name updated"
            return Response(data, status=HTTP_200_OK)
        else:
            data['error'] = "Name not provided."
            return Response(data, status=HTTP_403_FORBIDDEN)
