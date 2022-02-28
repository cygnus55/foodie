from rest_framework import permissions

class IsCurrentUserOwner(permissions.BasePermission):

    message = "You must be the owner of this review."

    def has_object_permission(self, request, view, obj):
        if request.method in permissions.SAFE_METHODS:
            return True
        return obj.customer.user == request.user