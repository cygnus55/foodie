from django.urls import path

from favourites.views import FoodFavourite, RestaurantFavourite


app_name = "favourites"

urlpatterns = [
    path("food/<int:pk>/", FoodFavourite.as_view(), name="food-toggle-favourite"),
    path("restaurant/<int:pk>/", RestaurantFavourite.as_view(), name="restaurant-toggle-favourite"),
]