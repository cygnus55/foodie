from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.authentication import TokenAuthentication
from rest_framework.response import Response
from rest_framework.status import HTTP_400_BAD_REQUEST, HTTP_200_OK

from customers.serializers import CustomerProfileSerializer
from api import customauthentication, custompermissions
from customers.custompermissions import IsCurrentUserOwner

class CustomerProfile(APIView):
    permission_classes = [
        IsAuthenticated,
        custompermissions.AllowOnlyCustomer,
        IsCurrentUserOwner,
    ]
    authentication_classes = [
        TokenAuthentication,
        customauthentication.CsrfExemptSessionAuthentication
    ]

    def get(self, request, format=None):
        customer = request.user.customer
        serializers = CustomerProfileSerializer(customer)
        return Response(serializers.data, status=HTTP_200_OK)

    def put(self, request, format=None):
        customer = request.user.customer
        serializer = CustomerProfileSerializer(customer, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=HTTP_200_OK)
        return Response(serializer.errors, status=HTTP_400_BAD_REQUEST)

    def patch(self, request, format=None):
        customer = request.user.customer
        serializer = CustomerProfileSerializer(
            customer, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=HTTP_200_OK)
        return Response(serializer.errors, status=HTTP_400_BAD_REQUEST)
