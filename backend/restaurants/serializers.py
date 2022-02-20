from rest_framework import serializers
from taggit.serializers import (TagListSerializerField, TaggitSerializer)

from restaurants.models import Restaurant
from accounts.serializers import UserSerializer


class RestaurantSerializer(TaggitSerializer, serializers.ModelSerializer):
    url = serializers.HyperlinkedIdentityField(view_name="restaurants:restaurant_details")
    user = UserSerializer(read_only=True)
    tags = TagListSerializerField()
    class Meta:
        model = Restaurant
        exclude = ('created', 'updated')