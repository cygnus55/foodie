from rest_framework import serializers

from customers.models import Customer
from accounts.serializers import UserSerializer


class CustomerProfileSerializer(serializers.ModelSerializer):
    user = UserSerializer()
    class Meta:
        model = Customer
        exclude = ('created', 'updated')