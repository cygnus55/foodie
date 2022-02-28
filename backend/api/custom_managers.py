from django.db import models


class AvailabilityManager(models.Manager):
    """ Filter the objects on the basis of availability. """
    def get_queryset(self):
        return super().get_queryset().filter(is_available=True)