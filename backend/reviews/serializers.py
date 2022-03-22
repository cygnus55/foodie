from rest_framework import serializers

from reviews.models import Review
from customers.serializers import CustomerProfileSerializer


class ReviewSerializer(serializers.ModelSerializer):
    url = serializers.HyperlinkedIdentityField(view_name="reviews:review_details")
    customer = CustomerProfileSerializer(read_only=True)

    class Meta:
        model = Review
        exclude = ("created", "updated", "content_type", "object_id",)