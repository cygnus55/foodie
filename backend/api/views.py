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
                    "login": reverse("accounts:customer_login", request=request),
                    "logout": reverse("accounts:logout", request=request),
                    "send-otp": reverse("accounts:send_otp", request=request) 
                },
                "customer": {
                    "customer-name": reverse("accounts:customer_name", request=request)
                },
                "restaurants": reverse("restaurants:restaurant_list", request=request),
                "foods": reverse("foods:food_list", request=request)
            }
        )