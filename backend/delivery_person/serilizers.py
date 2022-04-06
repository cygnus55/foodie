from rest_framework import serializers

from delivery_person.models import DeliveryPerson
from accounts.views import change_profile_pic


class DeliveryPersonProfileSerializer(serializers.ModelSerializer):
    full_name = serializers.CharField(source='user.full_name')
    email = serializers.CharField(source='user.email')
    mobile = serializers.CharField(source='user.mobile', read_only=True)

    class Meta:
        model = DeliveryPerson
        exclude = ('created', 'updated', 'has_logged_once', 'user')
    
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