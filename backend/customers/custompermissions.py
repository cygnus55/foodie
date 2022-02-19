from rest_framework import permissions

class IsCurrentUserOwner(permissions.BasePermission):

    message = "You must be the owner of this customer profile."

    def has_object_permission(self, request, view, obj):
        return obj.user == request.user
