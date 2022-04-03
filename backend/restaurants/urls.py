from django.urls import path

from restaurants.views import (
    restaurant_dashboard,
    RestaurantDetails,
    RestaurantList,
    FoodCreateView,
    FoodDeleteView,
    FoodDetailView,
    FoodListView,
    FoodUpdateView,
    account_settings,
    get_location,
    update_location,
)


app_name = "restaurants"

urlpatterns = [
    # APIs for mobile app
    path("restaurants/", RestaurantList.as_view(), name="restaurant_list"),
    path("restaurants/<int:pk>/", RestaurantDetails.as_view(), name="restaurant_details"),

    # URLs for restaurant dashboard
    path("", restaurant_dashboard, name="restaurant_home"),
    path("restaurant/foods/", FoodListView.as_view(), name="food_list"),
    path("restaurant/foods/new/", FoodCreateView.as_view(), name="food_create"),
    path("restaurant/foods/<int:pk>/", FoodDetailView.as_view(), name="food_detail"),
    path("restaurant/foods/edit/<int:pk>", FoodUpdateView.as_view(), name="food_update"),
    path("restaurant/foods/delete/<int:pk>", FoodDeleteView.as_view(), name="food_delete"),
    path("restaurant/account/settings/", account_settings, name="account_settings"),
    path("restaurant/location/", get_location, name="get_location"),
    path("restaurant/location/update/", update_location, name="update_location"),
]
