import datetime
import pytz

from django.contrib.contenttypes.fields import GenericRelation
from django.core.exceptions import ObjectDoesNotExist, ValidationError
from django.db import models
from django.db.models import Avg, Count

from taggit.managers import TaggableManager
from django_better_admin_arrayfield.models.fields import ArrayField

from accounts.models import User
from api.custom_managers import AvailabilityManager
from customers.models import Customer
from favourites.models import Favourite
from reviews.models import Review


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
    favourites = GenericRelation(
        Favourite,
        related_query_name="food",
        content_type_field="content_type",
        object_id_field="object_id",
    )
    location = ArrayField(models.CharField(max_length=500, blank=True), size=3)
    has_logged_once = models.BooleanField(default=False)
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

    @property
    def open_status(self):
        open_hour = self.open_hour
        close_hour = self.close_hour
        IST = pytz.timezone("Asia/Kathmandu")
        current_time = datetime.datetime.now(IST).time()
        return current_time >= open_hour and current_time <= close_hour

    def clean(self):
        if self.open_hour > self.close_hour:
            raise ValidationError('Opening hour should be greater than closing hours.')
        return super().clean()

    def customer_favourite_status(self, id):
        try:
            customer = Customer.objects.get(id=id)
            item = self.favourites.filter(customer=customer)
            if item:
                return True
            return False
        except ObjectDoesNotExist:
            return False

    def distance(self, lat, lng):
        from geopy.distance import geodesic
        location = self.location
        return geodesic((location[0], location[1]), (lat, lng)).km
    
    @property
    def has_location(self):
        return all(self.location)
    

    def __str__(self):
        return f"{self.user.full_name} for user {self.user.username}"