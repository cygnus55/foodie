from dataclasses import fields
from rest_framework import serializers
from taggit.serializers import (TagListSerializerField, TaggitSerializer)

from foods.models import Food, FoodTemplate
from restaurants.serializers import RestaurantSerializer
from reviews.serializers import ReviewSerializer


class FoodSerializer(TaggitSerializer, serializers.ModelSerializer):
    url = serializers.HyperlinkedIdentityField(view_name="foods:food_details")
    restaurant = RestaurantSerializer(read_only=True)
    tags = TagListSerializerField()
    selling_price = serializers.DecimalField(max_digits=10, decimal_places=2, read_only=True)
    average_ratings = serializers.DecimalField(max_digits=10, decimal_places=2, read_only=True)
    ratings_count = serializers.IntegerField()
    reviews = ReviewSerializer(read_only=True, many=True)

    class Meta:
        model = Food
        exclude = ("created", "updated")


class FoodTemplateSerializer(TaggitSerializer, serializers.ModelSerializer):
    url = serializers.HyperlinkedIdentityField(view_name="foods:food_template_details")
    tags = TagListSerializerField()

    class Meta:
        model = FoodTemplate
        exclude = ("created", "updated")
