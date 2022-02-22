from rest_framework import serializers

from customers.models import Customer
from accounts.views import change_profile_pic

class CustomerProfileSerializer(serializers.ModelSerializer):
    full_name = serializers.CharField(source='user.full_name')
    email = serializers.CharField(source='user.email')
    mobile = serializers.CharField(source='user.mobile', read_only=True)
    username = serializers.CharField(source='user.username')
    class Meta:
        model = Customer
        exclude = ('created', 'updated')
    
    def update(self, instance, validated_data):
        for key in validated_data.keys():
            if key == 'user':
                for k in validated_data.get(key).keys():
                    setattr(instance.user, k, validated_data.get(key).get(k))
                    if k == "full_name":
                        change_profile_pic(instance.user)
            elif key != 'user':
                setattr(instance, key, validated_data.get(key))
        instance.user.save()
        instance.save()
        return instance