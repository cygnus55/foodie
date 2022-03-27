import copy

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
from restaurants.models import Restaurant


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
        if not cart:
            cart = Cart.objects.create(customer=self.request.user.customer)
        serializers = CartSerializer(cart, context={'request': request})
        response = copy.copy(serializers.data)
        # categorize the serializer items with restaurants
        restaurants = {}
        for item in serializers.data.get('items'):
            if str(item['restaurant_id']) not in restaurants:
                restaurants[str(item['restaurant_id'])] = [{'name': item['restaurant_name']}, {'items': []}]
            restaurants[str(item['restaurant_id'])][1]['items'].append(item)
        response['items'] = restaurants
        return Response(response, status=HTTP_200_OK)
    
    def delete(self, request, format=None):
        # clear cart
        cart = Cart.objects.filter(customer=self.request.user.customer).first()
        cart.items.all().delete()
        return Response({'success': 'Your cart is clear.'},status=HTTP_200_OK)


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
        try:
            food = Food.objects.get(id=self.request.data["food"])
        except Exception as e:
            return Response({"error": "Food does not exist."}, status=HTTP_400_BAD_REQUEST)
        if not food.can_be_ordered:
            return Response({"error": "Food cannot be added to cart. Food is unvailable right now."}, status=HTTP_400_BAD_REQUEST)
        price = food.selling_price
        cart = Cart.objects.filter(customer=self.request.user.customer).first()
        if not cart:
            cart = Cart.objects.create(customer=self.request.user.customer)
        serializer.save(cart=cart, price=price)


# delete cart item by restaurant
class ClearCartItemByRestaurant(APIView):
    permission_classes = [
        IsAuthenticated,
        custompermissions.AllowOnlyCustomer,
        AllowOnlyCartOwner,
    ]
    authentication_classes = [
        TokenAuthentication,
        customauthentication.CsrfExemptSessionAuthentication
    ]

    def get(self, request, format=None):
        restaurant_id = request.query_params.get('restaurant_id')
        cart = Cart.objects.filter(customer=request.user.customer).first()
        restaurant = Restaurant.objects.get(id=restaurant_id)
        if not restaurant:
            return Response({"error": "Restaurant does not exist."}, status=HTTP_400_BAD_REQUEST)
        
        cart.items.filter(food__restaurant=restaurant).delete()
        return Response({'success': 'Cart item deleted.'}, status=HTTP_200_OK)