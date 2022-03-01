from rest_framework.views import APIView
from rest_framework.generics import ListCreateAPIView, RetrieveUpdateDestroyAPIView
from rest_framework.permissions import IsAuthenticatedOrReadOnly
from rest_framework.authentication import TokenAuthentication
from rest_framework.response import Response
from rest_framework.status import HTTP_400_BAD_REQUEST, HTTP_200_OK
from reviews.models import Review

from reviews.serializers import ReviewSerializer
from reviews.custompermissions import IsCurrentUserOwner
from api import customauthentication, custompermissions
from foods.models import Food
from restaurants.models import Restaurant


class RestaurantReviewList(ListCreateAPIView):
    permission_classes = [
        IsAuthenticatedOrReadOnly,
        custompermissions.IsCurrentUserCustomer,
        IsCurrentUserOwner,
    ]
    authentication_classes = [
        TokenAuthentication,
        customauthentication.CsrfExemptSessionAuthentication
    ]

    serializer_class = ReviewSerializer

    def get_queryset(self):
        id_ = self.kwargs.get("pk")
        restaurant = Restaurant.objects.get(id=id_)
        return restaurant.reviews

    def perform_create(self, serializer):
        id_ = self.kwargs.get("pk")
        content_object = Restaurant.objects.get(id=id_)
        customer = self.request.user.customer
        serializer.save(content_object=content_object, customer=customer)


class FoodReviewList(ListCreateAPIView):
    permission_classes = [
        IsAuthenticatedOrReadOnly,
        custompermissions.IsCurrentUserCustomer,
        IsCurrentUserOwner,
    ]
    authentication_classes = [
        TokenAuthentication,
        customauthentication.CsrfExemptSessionAuthentication
    ]

    serializer_class = ReviewSerializer

    def get_queryset(self):
        id_ = self.kwargs.get("pk")
        food = Food.objects.get(id=id_)
        return food.reviews

    def perform_create(self, serializer):
        id_ = self.kwargs.get("pk")
        content_object = Food.objects.get(id=id_)
        customer = self.request.user.customer
        serializer.save(content_object=content_object, customer=customer, sentiment_score=0)


class ReviewDetails(RetrieveUpdateDestroyAPIView):
    permission_classes = [
        IsAuthenticatedOrReadOnly,
        custompermissions.IsCurrentUserCustomer,
        IsCurrentUserOwner,
    ]
    authentication_classes = [
        TokenAuthentication,
        customauthentication.CsrfExemptSessionAuthentication
    ]

    serializer_class = ReviewSerializer
    queryset = Review.objects.all()
