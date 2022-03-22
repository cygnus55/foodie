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
    authentication_classes = [
        TokenAuthentication,
        customauthentication.CsrfExemptSessionAuthentication
    ]

    def get(self, request, format=None, *args, **kwargs):
        id = self.kwargs.get("pk")
        food = Food.objects.get(id=id)
        serializer = FoodSerializer(food, context={"request": request})
        response = copy.copy(serializer.data)

        if request.user.is_authenticated and request.user.is_customer:
            try:
                customer_id = request.user.customer.id
                response["is_favourite"] = food.customer_favourite_status(id=customer_id)
                return Response(response)
            except ObjectDoesNotExist:
                return Response({"error": "Customer does not exist!"}, status=HTTP_404_NOT_FOUND)
        else:
            response["is_favourite"] = False
            return Response(response)


class FoodTemplateList(ListAPIView):
    queryset = FoodTemplate.objects.all()
    serializer_class = FoodTemplateSerializer
    permission_classes = [IsAuthenticated, custompermissions.AllowOnlyRestaurant]
    authentication_classes = [
        TokenAuthentication,
        customauthentication.CsrfExemptSessionAuthentication
    ]


class FoodTemplateDetailsView(RetrieveAPIView):
    queryset = FoodTemplate.objects.all()
    serializer_class = FoodTemplateSerializer
    permission_classes = [IsAuthenticated, custompermissions.AllowOnlyRestaurant]
    authentication_classes = [
        TokenAuthentication,
        customauthentication.CsrfExemptSessionAuthentication
    ]