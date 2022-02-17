from sqlite3 import IntegrityError
from rest_framework.generics import ListCreateAPIView, RetrieveUpdateDestroyAPIView
from rest_framework.permissions import IsAuthenticatedOrReadOnly
from rest_framework.authentication import TokenAuthentication, SessionAuthentication
from rest_framework.response import Response
from rest_framework.status import HTTP_403_FORBIDDEN

from restaurants.models import Restaurant
from restaurants.serializers import RestaurantSerializer
from api import custompermissions, customauthentication
from .custompermissions import IsCurrentUserAlreadyAnOwner, IsCurrentUserOwnerOrReadOnly

class RestaurantList(ListCreateAPIView):
    queryset = Restaurant.objects.all()
    serializer_class = RestaurantSerializer
    permission_classes = [
        IsAuthenticatedOrReadOnly,
        custompermissions.IsCurrentUserRestaurant,
        IsCurrentUserAlreadyAnOwner,
        IsCurrentUserOwnerOrReadOnly
    ]
    authentication_classes = [
        TokenAuthentication, 
        customauthentication.CsrfExemptSessionAuthentication
    ]

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)


class RestaurantDetails(RetrieveUpdateDestroyAPIView):
    queryset = Restaurant.objects.all()
    serializer_class = RestaurantSerializer
    permission_classes = [
        IsAuthenticatedOrReadOnly,
        custompermissions.IsCurrentUserRestaurant,
        IsCurrentUserAlreadyAnOwner,
        IsCurrentUserOwnerOrReadOnly,
    ]
    authentication_classes = [
        TokenAuthentication,
        customauthentication.CsrfExemptSessionAuthentication
        ]
