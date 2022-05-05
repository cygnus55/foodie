from rest_framework.exceptions import NotFound
from rest_framework.exceptions import APIException
from rest_framework.generics import ListCreateAPIView, RetrieveUpdateDestroyAPIView
from rest_framework.permissions import IsAuthenticatedOrReadOnly
from rest_framework.authentication import TokenAuthentication
from reviews.models import Review

from reviews.serializers import ReviewSerializer
from reviews.custompermissions import IsCurrentUserOwner
from api import customauthentication, custompermissions
from foods.models import Food
from restaurants.models import Restaurant
from orders.models import OrderItem


class NotAllowed(APIException):
    status_code = 403
    default_detail = "Not allowed to access this endpoint!"


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
        try:
            restaurant = Restaurant.objects.get(id=id_)
            return restaurant.reviews.all()
        except Exception as e:
            raise NotFound(detail="Error 404, resource not found!", code=404)

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
        try:
            food = Food.objects.get(id=id_)
            return food.reviews.all()
        except Exception:
            raise NotFound(detail="Error 404, resource not found!", code=404)

    def perform_create(self, serializer):
        id_ = self.kwargs.get("pk")
        content_object = Food.objects.get(id=id_)
        customer = self.request.user.customer
        order_items = OrderItem.objects.filter(order__customer=customer)
        already_ordered_foods = list(set(map(lambda x: x.food, order_items)))
        if content_object not in already_ordered_foods:
            raise NotAllowed()
        serializer.save(content_object=content_object, customer=customer)


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
