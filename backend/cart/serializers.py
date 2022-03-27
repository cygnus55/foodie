from rest_framework import serializers

from cart.models import Cart, CartItem
from foods.serializers import FoodSerializer


class CartItemSerializer(serializers.ModelSerializer):
    url = serializers.HyperlinkedIdentityField(view_name="cart:cart_item")
    food_name = serializers.CharField(source='food.name', read_only=True)
    image_url = serializers.CharField(source='food.image', read_only=True)
    quantity = serializers.IntegerField(min_value=1)
    price = serializers.DecimalField(max_digits=10, decimal_places=2, read_only=True)
    cost = serializers.DecimalField(max_digits=10, decimal_places=2, read_only=True)
    restaurant_name = serializers.CharField(source='food.restaurant.user.full_name', read_only=True)
    restaurant_id = serializers.IntegerField(source='food.restaurant.id', read_only=True)

    class Meta:
        model = CartItem
        exclude = ('created', 'updated', 'cart')
    
    def save(self, *args, **kwargs):
        # if item is already in cart, update the quantity
        cart = kwargs.get('cart')
        food = self.validated_data.get('food')
        try:
            item = CartItem.objects.get(cart=cart, food=food)
            item.quantity += self.validated_data['quantity']
            item.save()
            self.instance = item
            return self.instance
        except CartItem.DoesNotExist:
            super().save(*args, **kwargs)


class CartSerializer(serializers.ModelSerializer):
    items = CartItemSerializer(
        many=True,
        read_only=True,
        )
    total_amount = serializers.DecimalField(max_digits=10, decimal_places=2, read_only=True)

    class Meta:
        model = Cart
        exclude = ('created', 'updated', 'customer')
