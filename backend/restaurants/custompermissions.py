from rest_framework import permissions

from restaurants.models import Restaurant


class IsCurrentUserOwnerOrReadOnly(permissions.BasePermission):
    message = "You must be the owner of this restaurant."

    def has_object_permission(self, request, view, obj):
        if request.method in permissions.SAFE_METHODS:
            return True
        return obj.user == request.user


class IsCurrentUserAlreadyAnOwner(permissions.BasePermission):
    message = "You are already the owner of a restaurant. You cannot create a new one."

    def has_permission(self, request, view):
        if request.method in permissions.SAFE_METHODS:
            return True

        restaurant = Restaurant.objects.filter(user=request.user)
        print(restaurant)
        if restaurant:
            return False
        else:
            return True

