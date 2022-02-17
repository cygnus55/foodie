from rest_framework import serializers

from .models import User

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        exclude = ('created_at', 'updated_at', 'password', 'is_active', 'is_staff', 'is_superuser', 'is_customer', 'is_restaurant', 'is_delivery_person', 'is_verified', 'last_login')