from rest_framework import serializers
from taggit.serializers import TagListSerializerField, TaggitSerializer

from restaurants.models import Restaurant
from accounts.serializers import UserSerializer
from reviews.serializers import ReviewSerializer


class RestaurantSerializer(TaggitSerializer, serializers.ModelSerializer):
    url = serializers.HyperlinkedIdentityField(view_name="restaurants:restaurant_details")
    user = UserSerializer(read_only=True)
    tags = TagListSerializerField()
    average_ratings = serializers.DecimalField(max_digits=10, decimal_places=2, read_only=True)
    ratings_count = serializers.IntegerField()
    reviews = ReviewSerializer(read_only=True, many=True)
    open_hour = serializers.DateTimeField(format="%I:%M %p")
    close_hour = serializers.DateTimeField(format="%I:%M %p")


    class Meta:
        model = Restaurant
        exclude = ('created', 'updated')