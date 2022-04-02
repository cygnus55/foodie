from rest_framework import serializers
from taggit.serializers import TaggitSerializer, TagListSerializerField

from accounts.serializers import UserSerializer
from restaurants.models import Restaurant
from reviews.serializers import ReviewSerializer


class RestaurantSerializer(TaggitSerializer, serializers.ModelSerializer):
    url = serializers.HyperlinkedIdentityField(
        view_name="restaurants:restaurant_details")
    user = UserSerializer(read_only=True)
    tags = TagListSerializerField()
    average_ratings = serializers.DecimalField(
        max_digits=10, decimal_places=2, read_only=True)
    ratings_count = serializers.IntegerField(read_only=True)
    # reviews = ReviewSerializer(read_only=True, many=True)
    open_hour = serializers.TimeField(format="%I:%M %p")
    close_hour = serializers.TimeField(format="%I:%M %p")
    open_status = serializers.BooleanField(read_only=True)
    is_favourite = serializers.SerializerMethodField("get_favourite_status")
    distance = serializers.SerializerMethodField("get_distance")

    def get_favourite_status(self, obj):
        user = self.context["request"].user
        if user.is_authenticated and user.is_customer:
            customer_id = user.customer.id
            is_fav = obj.customer_favourite_status(id=customer_id)
            return is_fav
        return False
    
    def get_distance(self, obj):
        latitude = self.context["request"].query_params.get('lat', None)
        longitude = self.context["request"].query_params.get('lng', None)
        if latitude and longitude:
            return round(obj.distance(latitude, longitude))

    def validate(self, data):
        if data["open_hour"] > data["close_hour"]:
            raise serializers.ValidationError(
                {"error": "Open hour must be less than close hour."})
        return data

    class Meta:
        model = Restaurant
        exclude = ("created", "updated", "has_logged_once")
