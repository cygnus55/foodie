from rest_framework import serializers

from cart.models import Cart, CartItem
from foods.serializers import FoodSerializer


class CartItemSerializer(serializers.ModelSerializer):
    url = serializers.HyperlinkedIdentityField(view_name="cart:cart_item")
    food_name = serializers.CharField(source='food.name', read_only=True)
    quantity = serializers.IntegerField(min_value=1)
    price = serializers.DecimalField(max_digits=10, decimal_places=2, read_only=True)
    cost = serializers.DecimalField(max_digits=10, decimal_places=2, read_only=True)

    class Meta:
        model = CartItem
        exclude = ('created', 'updated', 'cart')


class CartSerializer(serializers.ModelSerializer):
    items = CartItemSerializer(
        many=True,
        read_only=True,
        )
    total_amount = serializers.DecimalField(max_digits=10, decimal_places=2, read_only=True)

    class Meta:
        model = Cart
        exclude = ('created', 'updated', 'customer')
