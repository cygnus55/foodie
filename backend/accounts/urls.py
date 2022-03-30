from django.urls import path

from accounts.views import (
    customer_login,
    delivery_person_login,
    restaurant_login,
    account_logout,
    send_otp_code,
    AccountDetails,
)

app_name = "accounts"

urlpatterns = [
    path("send-otp/", send_otp_code, name="send_otp"),
    path("login/", customer_login, name="customer_login"),
    path("login/delivery-person/", delivery_person_login, name="delivery_person_login"),
    path("login/restaurant/", restaurant_login, name="restaurant_login"),
    path("logout/", account_logout, name="logout"),
    path("details/", AccountDetails.as_view(), name="details"),
]
