import imp
from rest_framework import permissions

class IsCurrentUserOwner(permissions.BasePermission):
    message = "You must be the owner of this account."

    def has_object_permission(self, request, view, obj):
        return obj == request.user