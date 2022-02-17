from rest_framework.generics import ListCreateAPIView, RetrieveUpdateDestroyAPIView
from rest_framework.permissions import IsAuthenticatedOrReadOnly
from rest_framework.authentication import TokenAuthentication, SessionAuthentication
from rest_framework.response import Response
from rest_framework.status import HTTP_403_FORBIDDEN

from foods.models import Food
from foods.serializers import FoodSerializer
from api import custompermissions, customauthentication
from .custompermissions import IsCurrentRestaurantOwnerOrReadOnly


class FoodList(ListCreateAPIView):
    queryset = Food.objects.all()
    serializer_class = FoodSerializer
    permission_classes = [
        IsAuthenticatedOrReadOnly,
        custompermissions.IsCurrentUserRestaurant,
        IsCurrentRestaurantOwnerOrReadOnly
    ]
    authentication_classes = [
        TokenAuthentication,
        customauthentication.CsrfExemptSessionAuthentication
    ]

    def perform_create(self, serializer):
        serializer.save(restaurant=self.request.user.restaurant)
        return super().perform_create(serializer)


class FoodDetails(RetrieveUpdateDestroyAPIView):
    queryset = Food.objects.all()
    serializer_class = FoodSerializer
    permission_classes = [
        IsAuthenticatedOrReadOnly,
        custompermissions.IsCurrentUserRestaurant,
        IsCurrentRestaurantOwnerOrReadOnly
    ]
    authentication_classes = [TokenAuthentication, SessionAuthentication]
