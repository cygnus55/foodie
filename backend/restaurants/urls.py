from django.urls import path

from restaurants.views import RestaurantDetails, RestaurantList


app_name = "restaurants"

urlpatterns = [
    path("", RestaurantList.as_view(), name="restaurant_list"),
    path("<int:pk>/", RestaurantDetails.as_view(), name="restaurant_details"),
]