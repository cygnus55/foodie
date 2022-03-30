from django.db import models

from accounts.models import User


class DeliveryPerson(models.Model):
    user = models.OneToOneField(User, related_name="delivery_person", on_delete=models.CASCADE)
    profile_picture = models.URLField(blank=True)
    has_logged_once = models.BooleanField(default=False)
    created = models.TimeField(auto_now_add=True)
    updated = models.TimeField(auto_now=True)

    class Meta:
        ordering = ('-created',)
    
    def __str__(self):
        return f'{self.user.full_name} for user {self.user.username}'
