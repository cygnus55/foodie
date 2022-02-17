from rest_framework import permissions

class IsCurrentRestaurantOwnerOrReadOnly(permissions.BasePermission):

    message = "You are not the owner of this food."

    def has_object_permission(self, request, view, obj):
        if request.method in permissions.SAFE_METHODS:
            return True
        return obj.restaurant == request.user.restaurant
