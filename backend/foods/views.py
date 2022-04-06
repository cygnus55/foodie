import copy
from django.core.exceptions import ObjectDoesNotExist

from rest_framework.generics import (
    ListAPIView,
    RetrieveAPIView,
    ListCreateAPIView,
    RetrieveUpdateDestroyAPIView
)
from rest_framework.permissions import IsAuthenticatedOrReadOnly, IsAuthenticated
from rest_framework.authentication import TokenAuthentication, SessionAuthentication
from rest_framework.response import Response
from rest_framework.status import HTTP_403_FORBIDDEN, HTTP_404_NOT_FOUND

from api import custompermissions, customauthentication

from foods.models import Food, FoodTemplate
from foods.serializers import FoodSerializer, FoodTemplateSerializer
from foods.custompermissions import IsCurrentRestaurantOwnerOrReadOnly


class FoodList(ListCreateAPIView):
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
    
    def get_queryset(self):
        queryset = Food.objects.all()
        latitude = self.request.query_params.get('lat', None)
        longitude = self.request.query_params.get('lng', None)
        top_rated = self.request.query_params.get('top_rated', None)
        favorite = self.request.query_params.get('favorite', None)
        veg = self.request.query_params.get('veg', None)
        offers = self.request.query_params.get('offers', None)

        if latitude and longitude:
            # for every queryset, calculate distance from the given lat and lng and filter if distance is less than 4km
            for q in queryset:
                if q.restaurant.distance(latitude, longitude) > 10:
                    queryset = queryset.exclude(id=q.id)
        if top_rated:
            for q in queryset:
                if q.average_ratings <= 3:
                    queryset = queryset.exclude(id=q.id)
        if favorite:
            if self.request.user.is_authenticated and self.request.user.is_customer:
                for q in queryset:
                    if q.customer_favourite_status(id=self.request.user.customer.id) == False:
                        queryset = queryset.exclude(id=q.id)
        if veg:
            for q in queryset:
                if q.is_veg == False:
                    queryset = queryset.exclude(id=q.id)
        if offers:
            for q in queryset:
                if not q.discount_percent:
                    queryset = queryset.exclude(id=q.id)
            queryset = queryset.order_by('-discount_percent')
        return queryset


class FoodDetails(RetrieveUpdateDestroyAPIView):
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


class FoodTemplateList(ListAPIView):
    queryset = FoodTemplate.objects.all()
    serializer_class = FoodTemplateSerializer
    permission_classes = [IsAuthenticated,
                          custompermissions.AllowOnlyRestaurant]
    authentication_classes = [
        TokenAuthentication,
        customauthentication.CsrfExemptSessionAuthentication
    ]


class FoodTemplateDetailsView(RetrieveAPIView):
    queryset = FoodTemplate.objects.all()
    serializer_class = FoodTemplateSerializer
    permission_classes = [IsAuthenticated,
                          custompermissions.AllowOnlyRestaurant]
    authentication_classes = [
        TokenAuthentication,
        customauthentication.CsrfExemptSessionAuthentication
    ]
