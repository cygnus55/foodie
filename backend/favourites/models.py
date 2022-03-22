from django.db import models
from django.contrib.contenttypes.fields import GenericForeignKey
from django.contrib.contenttypes.models import ContentType

from customers.models import Customer


class Favourite(models.Model):
    customer = models.ForeignKey(
        Customer,
        related_name="favourite",
        on_delete=models.CASCADE
    )
    content_type = models.ForeignKey(ContentType, related_name="object_type", on_delete=models.CASCADE)
    object_id = models.PositiveIntegerField()
    content_object = GenericForeignKey("content_type", "object_id")
    created = models.TimeField(auto_now_add=True)
    updated = models.TimeField(auto_now=True)

    class Meta:
        unique_together = ("customer", "content_type", "object_id",)

    def __str__(self):
        return f"Favourite: {self.content_object} for {self.customer.user.full_name}"