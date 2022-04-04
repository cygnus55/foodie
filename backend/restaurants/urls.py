from django.contrib.auth import views as auth_views
from django.urls import path, reverse_lazy

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
    change_password,
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
    path("restaurant/foods/new/<int:template_id>/", FoodCreateView.as_view(),
         name="food_create_from_template"),
    path("restaurant/foods/<int:pk>/", FoodDetailView.as_view(), name="food_detail"),
    path("restaurant/foods/edit/<int:pk>/", FoodUpdateView.as_view(), name="food_update"),
    path("restaurant/foods/delete/<int:pk>/", FoodDeleteView.as_view(), name="food_delete"),
    path("restaurant/account/settings/profile/", account_settings, name="account_settings"),
    path("restaurant/account/settings/password/", change_password, name="change_password"),
    path("restaurant/location/", get_location, name="get_location"),
    path("restaurant/location/update/", update_location, name="update_location"),
]
