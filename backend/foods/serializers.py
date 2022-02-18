from rest_framework import serializers

from foods.models import Food
from restaurants.models import Restaurant
from restaurants.serializers import RestaurantSerializer


class FoodSerializer(serializers.ModelSerializer):
    url = serializers.HyperlinkedIdentityField(view_name="foods:food_details")
    restaurant = RestaurantSerializer(read_only=True)
    class Meta:
        model = Food
        exclude = ('created', 'updated')