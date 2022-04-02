from django.db import models
from django_better_admin_arrayfield.models.fields import ArrayField

from accounts.models import User


class DeliveryPerson(models.Model):
    user = models.OneToOneField(User, related_name="delivery_person", on_delete=models.CASCADE)
    profile_picture = models.URLField(blank=True)
    location = ArrayField(models.CharField(max_length=500, blank=True), size=2, default=list)
    has_logged_once = models.BooleanField(default=False)
    created = models.TimeField(auto_now_add=True)
    updated = models.TimeField(auto_now=True)

    class Meta:
        ordering = ('-created',)
    
    def __str__(self):
        return f'{self.user.full_name} for user {self.user.username}'
