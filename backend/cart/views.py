from rest_framework.views import APIView
from rest_framework.generics import RetrieveUpdateDestroyAPIView, CreateAPIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.authentication import TokenAuthentication
from rest_framework.response import Response
from rest_framework.status import HTTP_400_BAD_REQUEST, HTTP_200_OK

from cart.serializers import CartSerializer, CartItemSerializer
from api import customauthentication, custompermissions
from cart.models import Cart, CartItem
from cart.custompermissions import AllowOnlyOwner, AllowOnlyCartOwner
from foods.models import Food


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


class CartItemsDetails(RetrieveUpdateDestroyAPIView):
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


class CartItemCreate(CreateAPIView):
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

    def perform_create(self, serializer):
        print(self.request.data)
        try:
            food = Food.objects.get(id=self.request.data["food"])
            print(food)
        except Exception:
            return Response(status=HTTP_400_BAD_REQUEST)

        price = food.selling_price
        cart = Cart.objects.filter(customer=self.request.user.customer).first()
        if not cart:
            return Response(status=HTTP_400_BAD_REQUEST)
        
        serializer.save(cart=cart, price=price)

    # def post(self, request, format=None):
    #     cart = Cart.objects.filter(customer=self.request.user.customer).first()
    #     if not cart:
    #         return Response(status=HTTP_400_BAD_REQUEST)
    #     serializer = CartItemSerializer(data=request.data, context={'request': request})
    #     print(request.data)
    #     if serializer.is_valid():
    #         serializer.save(cart=cart)
    #         return Response(serializer.data, status=HTTP_200_OK)
    #     return Response(serializer.errors, status=HTTP_400_BAD_REQUEST)