from rest_framework import permissions


class AllowOnlyOwner(permissions.BasePermission):

    message = "You do not have access to this item."

    def has_object_permission(self, request, view, obj):
        return obj.customer.user == request.user