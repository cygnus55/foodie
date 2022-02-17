from rest_framework import serializers

from restaurants.models import Restaurant
from accounts.serializers import UserSerializer


class RestaurantSerializer(serializers.ModelSerializer):
    url = serializers.HyperlinkedIdentityField(view_name="restaurants:restaurant_details")
    user = UserSerializer(read_only=True)
    class Meta:
        model = Restaurant
        exclude = ('created', 'updated')