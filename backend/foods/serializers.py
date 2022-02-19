from rest_framework import serializers
from taggit.serializers import (TagListSerializerField, TaggitSerializer)

from foods.models import Food
from restaurants.serializers import RestaurantSerializer


class FoodSerializer(TaggitSerializer, serializers.ModelSerializer):
    url = serializers.HyperlinkedIdentityField(view_name="foods:food_details")
    restaurant = RestaurantSerializer(read_only=True)
    tags = TagListSerializerField()
    class Meta:
        model = Food
        exclude = ('created', 'updated')