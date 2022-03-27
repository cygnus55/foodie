from rest_framework.views import APIView
from rest_framework.generics import ListAPIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.authentication import TokenAuthentication
from rest_framework.response import Response
from rest_framework.status import HTTP_200_OK, HTTP_400_BAD_REQUEST

from api import customauthentication, custompermissions
from orders.models import Order, OrderItem
from cart.models import Cart
from restaurants.models import Restaurant
from orders.custompermissions import AllowOnlyOwner
from foods.models import Food
from api.utils import get_delivery_location, get_delivery_charge
from orders.serializers import OrderSerializer, DeliveryLocationSerializer

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
        # check food availability
        for item in request.data.get('items'):
            food = Food.objects.get(id=item.get('food_id'))
            if not food.can_be_ordered:
                return Response({'error': f'{food.name} of restaurant {food.restaurant.user.full_name} is not available.'}, status=HTTP_400_BAD_REQUEST)
        # create order
        lat = request.data.get('latitude')
        lng = request.data.get('longitude')
        delivery_location = get_delivery_location(lat, lng)
        order = Order.objects.create(
            customer=self.request.user.customer, delivery_location=delivery_location)
        # create order items
        for item in request.data.get('items'):
            try:
                food = Food.objects.get(id=item.get('food_id'))
            except Exception:
                return Response({'error': 'The food doesnot exist.'}, status=HTTP_400_BAD_REQUEST)
            OrderItem.objects.create(order=order, food=food, quantity=item.get(
                'quantity'), price=item.get('price'))
        # Clear cart
        if request.data.get('method') == 'CART':
            cart = Cart.objects.filter(
                customer=self.request.user.customer).first()
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


class RecentDeliveryLocation(APIView):
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
        orders = Order.objects.filter(
            customer=self.request.user.customer).order_by('-created')[:5]
        delivery_locations = []
        for order in orders:
            location = {
                'latitude': order.delivery_location[0],
                'longitude': order.delivery_location[1],
                'address': order.delivery_location[2],
                'city': order.delivery_location[2].split(',')[0],
            }
            if location not in delivery_locations:
                delivery_locations.append(location)
        # serialize delivery location
        serializer = DeliveryLocationSerializer(delivery_locations, many=True)
        return Response(serializer.data, status=HTTP_200_OK)


class GetDeliveryCharge(APIView):
    permission_classes = [
        IsAuthenticated,
        custompermissions.AllowOnlyCustomer,

    ]
    authentication_classes = [
        TokenAuthentication,
        customauthentication.CsrfExemptSessionAuthentication
    ]

    def post(self, request, format=None):
        lat = request.data.get('latitude')
        lng = request.data.get('longitude')
        customer_location = [lat, lng]
        restaurant_id = request.data.get('restaurant_id')
        if not restaurant_id:
            cart = Cart.objects.filter(
                customer=self.request.user.customer).first()
            restaurant_id = []
            for item in cart.items.all():
                if item.food.restaurant.id not in restaurant_id:
                    restaurant_id.append(item.food.restaurant.id)
        charge = get_delivery_charge(customer_location, restaurant_id)
        delivery_location = get_delivery_location(lat, lng)
        serializer = DeliveryLocationSerializer({
            'latitude': delivery_location[0],
            'longitude': delivery_location[1],
            'address': delivery_location[2],
            'city': delivery_location[2].split(',')[0],
            'delivery_charge': charge
        })
        return Response(serializer.data, status=HTTP_200_OK)
