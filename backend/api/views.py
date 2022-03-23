from rest_framework.reverse import reverse
from rest_framework.generics import GenericAPIView
from rest_framework.decorators import permission_classes
from rest_framework.permissions import AllowAny
from rest_framework.response import Response


@permission_classes([AllowAny])
class APIRoot(GenericAPIView):
    def get(self, request, *args, **kwargs):
        return Response(
            {
                "accounts": {
                    "login (customer register)": reverse("accounts:customer_login", request=request),
                    "logout": reverse("accounts:logout", request=request),
                    "send-otp": reverse("accounts:send_otp", request=request),
                    "details": reverse("accounts:details", request=request),
                },
                "customer": {
                    "my-profile": reverse("customers:profile", request=request),
                    "my-cart": reverse("cart:detail", request=request),
                    "add-to-cart": reverse("cart:add_item", request=request),
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
                "orders": {
                    "order_list": reverse("orders:list", request=request),
                    "order_create": reverse("orders:create", request=request),
                }
            }
        )