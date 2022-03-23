from rest_framework.views import APIView
from rest_framework.generics import ListAPIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.authentication import TokenAuthentication
from rest_framework.response import Response
from rest_framework.status import HTTP_200_OK, HTTP_400_BAD_REQUEST

from api import customauthentication, custompermissions
from orders.models import Order, OrderItem
from cart.models import Cart
from orders.custompermissions import AllowOnlyOwner, AllowOnlyOrderOwner
from foods.models import Food
from orders.geocoding import get_delivery_location
from orders.serializers import OrderSerializer, OrderItemSerializer

# Create your views here.


class OrderCreate(APIView):
    permission_classes = [
        IsAuthenticated,
        custompermissions.AllowOnlyCustomer,
        AllowOnlyOwner,
    ]
    authentication_classes = [
        TokenAuthentication,
        customauthentication.CsrfExemptSessionAuthentication
    ]

    def post(self, request, format=None):
        # create order
        lat = request.data.get('latitude')
        lng = request.data.get('longitude')
        delivery_location = get_delivery_location(lat, lng)
        order = Order.objects.create(customer=self.request.user.customer, delivery_location=delivery_location)
        # create order items
        for item in request.data.get('items'):
            try:
                food = Food.objects.get(id=item.get('food_id'))
            except Exception:
                return Response({'error': 'The food doesnot exist.'}, status=HTTP_400_BAD_REQUEST)
            OrderItem.objects.create(order=order, food=food, quantity=item.get('quantity'), price=item.get('price'))
        # Clear cart
        if request.data.get('method') == 'CART':
            cart = Cart.objects.filter(customer=self.request.user.customer).first()
            cart.items.all().delete()
        return Response({'success': 'Your order has been placed.'}, status=HTTP_200_OK)
    


class OrderList(ListAPIView):
    permission_classes = [
        IsAuthenticated,
        custompermissions.AllowOnlyCustomer,
        AllowOnlyOwner,
    ]
    authentication_classes = [
        TokenAuthentication,
        customauthentication.CsrfExemptSessionAuthentication
    ]

    serializer_class = OrderSerializer

    def get_queryset(self):
        return Order.objects.filter(customer=self.request.user.customer)


