from django.db import models

from accounts.models import User


class Restaurant(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    website_link = models.URLField(max_length=200, blank=True)
    facebook_link = models.URLField(max_length=200, blank=True)
    logo = models.URLField(blank=True)
    description = models.TextField(blank=True)
    open_hour = models.TimeField(auto_now=False, auto_now_add=False)
    close_hour = models.TimeField(auto_now=False, auto_now_add=False)
    is_available = models.BooleanField(default=True)
    created = models.TimeField(auto_now_add=True)
    updated = models.TimeField(auto_now=True)

    class Meta:
        ordering = ('-is_available',)
    
    def __str__(self):
        return f'{self.user.full_name} for user {self.user.username}'