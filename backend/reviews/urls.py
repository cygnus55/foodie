from django.urls import path

from reviews.views import ReviewDetails, RestaurantReviewList, FoodReviewList

app_name = "reviews"

urlpatterns = [
    path("restaurants/<int:pk>/", RestaurantReviewList.as_view(), name="restaurant_reviews_list"),
    path("foods/<int:pk>/", FoodReviewList.as_view(), name="food_reviews_list"),
    path("<int:pk>/", ReviewDetails.as_view(), name="review_details"),
]