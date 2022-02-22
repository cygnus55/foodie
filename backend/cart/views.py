from rest_framework.views import APIView
from rest_framework.generics import RetrieveAPIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.authentication import TokenAuthentication
from rest_framework.response import Response
from rest_framework.status import HTTP_400_BAD_REQUEST, HTTP_200_OK

from cart.serializers import CartSerializer, CartItemSerializer
from api import customauthentication, custompermissions
from cart.models import Cart, CartItem
from cart.custompermissions import AllowOnlyOwner, AllowOnlyCartOwner


class CartDetails(APIView):
    permission_classes = [
        IsAuthenticated,
        custompermissions.AllowOnlyCustomer,
        AllowOnlyOwner,
    ]
    authentication_classes = [
        TokenAuthentication,
        customauthentication.CsrfExemptSessionAuthentication
    ]

    def get(self, request, format=None):
        cart = Cart.objects.filter(customer=self.request.user.customer).first()
        serializers = CartSerializer(cart, context={'request': request})
        return Response(serializers.data, status=HTTP_200_OK)


class CartItemsDetails(RetrieveAPIView):
    permission_classes = [
        IsAuthenticated,
        custompermissions.AllowOnlyCustomer,
        AllowOnlyCartOwner,
    ]
    authentication_classes = [
        TokenAuthentication,
        customauthentication.CsrfExemptSessionAuthentication
    ]
    serializer_class = CartItemSerializer
    queryset = CartItem.objects.all()