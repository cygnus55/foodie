import copy

from django.core.exceptions import ObjectDoesNotExist

from rest_framework.authentication import TokenAuthentication
from rest_framework.generics import (
    ListCreateAPIView,
    RetrieveUpdateDestroyAPIView
)
from rest_framework.permissions import IsAuthenticatedOrReadOnly
from rest_framework.response import Response
from rest_framework.status import HTTP_403_FORBIDDEN, HTTP_404_NOT_FOUND

from api import customauthentication, custompermissions
from restaurants.models import Restaurant
from restaurants.serializers import RestaurantSerializer
from restaurants.custompermissions import (
    IsCurrentUserAlreadyAnOwner,
    IsCurrentUserOwnerOrReadOnly
)


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
        IsCurrentUserOwnerOrReadOnly,
    ]
    authentication_classes = [
        TokenAuthentication,
        customauthentication.CsrfExemptSessionAuthentication
    ]

    def get(self, request, format=None, *args, **kwargs):
        id = self.kwargs.get("pk")
        restaurant = Restaurant.objects.get(id=id)
        serializer = RestaurantSerializer(restaurant, context={"request": request})
        response = copy.copy(serializer.data)

        if request.user.is_authenticated and request.user.is_customer:
            try:
                customer_id = request.user.customer.id
                response["is_favourite"] = restaurant.customer_favourite_status(id=customer_id)
                return Response(response)
            except ObjectDoesNotExist:
                return Response({"error": "Customer does not exist!"}, status=HTTP_404_NOT_FOUND)
        else:
            response["is_favourite"] = False
            return Response(response)