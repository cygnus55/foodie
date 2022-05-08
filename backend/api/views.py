from rest_framework.reverse import reverse
from rest_framework.generics import GenericAPIView
from rest_framework.views import APIView
from rest_framework.decorators import permission_classes
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from rest_framework.status import HTTP_200_OK, HTTP_404_NOT_FOUND

from foods.models import Food
from restaurants.models import Restaurant
from foods.serializers import FoodSerializer
from restaurants.serializers import RestaurantSerializer


@permission_classes([AllowAny])
class APIRoot(GenericAPIView):
    def get(self, request, *args, **kwargs):
        return Response(
            {
                "accounts": {
                    "customer_login_and_register": reverse("accounts:customer_login", request=request),
                    "delivery_person_login": reverse("accounts:delivery_person_login", request=request),
                    "logout": reverse("accounts:logout", request=request),
                    "send_otp": reverse("accounts:send_otp", request=request),
                    "details": reverse("accounts:details", request=request),
                },
                "customer": {
                    "my_profile": reverse("customers:profile", request=request),
                    "my_cart": reverse("cart:detail", request=request),
                    "add_to_cart": reverse("cart:add_item", request=request),
                },
                "restaurants": reverse("restaurants:restaurant_list", request=request),
                "foods": {
                    "food_list": reverse("foods:food_list", request=request),
                    "food_template_list": reverse("foods:food_template_list", request=request),
                },
                "reviews_example": {
                    "restaurant_reviews_list": reverse("reviews:restaurant_reviews_list", request=request, kwargs={"pk": 1}),
                    "food_reviews_list": reverse("reviews:food_reviews_list", request=request, kwargs={"pk": 1}),
                    "review_details": reverse("reviews:review_details", request=request, kwargs={"pk": 1}),
                },
                "favourites_example": {
                    "toggle_food_favourite": reverse("favourites:food-toggle-favourite", request=request, kwargs={"pk": 1}),
                    "toggle_restaurant_favourite": reverse("favourites:restaurant-toggle-favourite", request=request, kwargs={"pk": 1}),
                },
                "orders": {
                    "order_list": reverse("orders:list", request=request),
                    "order_create": reverse("orders:create", request=request),
                    "recent_delivery_location": reverse("orders:delivery_location", request=request),
                    "get_delivery_charge": reverse("orders:delivery_charge", request=request),
                },
                "delivery_person": {
                    "change_password": reverse("delivery_person:change_password", request=request),
                    "profile": reverse("delivery_person:profile", request=request),
                    "new_orders_list": reverse("delivery_person:new_orders", request=request),
                    "accepted_orders": reverse("delivery_person:accepted_orders", request=request),
                    "accept_new_order": reverse("delivery_person:accept_order", request=request),
                    "update_order_status": reverse("delivery_person:update_status", request=request),
                },
            }
        )


class Search(APIView):

    permission_classes = [AllowAny]

    def get(self, request, format=None):
        query = self.request.query_params.get("query", None)

        if query:
            foods = Food.available.filter(tags__name__icontains=query).distinct() | \
                            Food.available.filter(name__icontains=query).distinct()
            restaurants = Restaurant.available.filter(tags__name__icontains=query).distinct() | \
                            Restaurant.available.filter(user__full_name__icontains=query).distinct()

            return Response({
                "foods": FoodSerializer(instance=foods, many=True, context={'request': request}).data,
                "restaurants": RestaurantSerializer(instance=restaurants, many=True, context={'request': request}).data
            }, status=HTTP_200_OK)

        return Response({
            "error": "You need to submit non-empty query!"
        }, status=HTTP_404_NOT_FOUND)
