from django.db import models
from django.db.models import Avg, Count
from django.contrib.contenttypes.fields import GenericRelation

from taggit.managers import TaggableManager

from accounts.models import User
from reviews.models import Review
from api.custom_managers import AvailabilityManager


class Restaurant(models.Model):
    user = models.OneToOneField(User, related_name="restaurant", on_delete=models.CASCADE)
    website_link = models.URLField(max_length=200, blank=True)
    facebook_link = models.URLField(max_length=200, blank=True)
    logo = models.URLField(blank=True, max_length=1000)
    description = models.TextField(blank=True)
    open_hour = models.TimeField(auto_now=False, auto_now_add=False)
    close_hour = models.TimeField(auto_now=False, auto_now_add=False)
    is_available = models.BooleanField(default=True)
    reviews = GenericRelation(
        Review,
        related_query_name="restaurant",
        content_type_field="content_type",
        object_id_field="object_id",
    )
    longitude = models.FloatField(blank=True)
    latitude = models.FloatField(blank=True)
    address = models.CharField(blank=True, max_length=250)
    created = models.TimeField(auto_now_add=True)
    updated = models.TimeField(auto_now=True)

    # Managers
    objects = models.Manager()
    available = AvailabilityManager()
    tags = TaggableManager()

    class Meta:
        ordering = ("-is_available",)

    @property
    def average_ratings(self):
        avg_ratings = self.reviews.aggregate(Avg("ratings")).get("ratings__avg", 0)
        if avg_ratings == None: avg_ratings = 0
        return avg_ratings

    @property
    def ratings_count(self):
        ratings_cnt = self.reviews.aggregate(Count("ratings")).get("ratings__count", 0)
        if ratings_cnt == None: ratings_cnt = 0
        return ratings_cnt

    def __str__(self):
        return f"{self.user.full_name} for user {self.user.username}"
