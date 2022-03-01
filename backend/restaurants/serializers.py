from rest_framework import serializers
from taggit.serializers import TaggitSerializer, TagListSerializerField

from accounts.serializers import UserSerializer
from restaurants.models import Restaurant
from reviews.serializers import ReviewSerializer


class RestaurantSerializer(TaggitSerializer, serializers.ModelSerializer):
    url = serializers.HyperlinkedIdentityField(view_name="restaurants:restaurant_details")
    user = UserSerializer(read_only=True)
    tags = TagListSerializerField()
    average_ratings = serializers.DecimalField(max_digits=10, decimal_places=2, read_only=True)
    ratings_count = serializers.IntegerField(read_only=True)
    reviews = ReviewSerializer(read_only=True, many=True)
    open_hour = serializers.TimeField(format="%I:%M %p")
    close_hour = serializers.TimeField(format="%I:%M %p")
    open_status = serializers.BooleanField(read_only=True)

    def validate(self, data):
        if data["open_hour"] > data["close_hour"]:
            raise serializers.ValidationError({"error": "Open hour must be less than close hour."})
        return data

    class Meta:
        model = Restaurant
        exclude = ("created", "updated")

