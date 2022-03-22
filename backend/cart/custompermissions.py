from rest_framework import permissions


class AllowOnlyOwner(permissions.BasePermission):

    message = "You must be the owner of this cart."

    def has_object_permission(self, request, view, obj):
        return obj.customer.user == request.user


class AllowOnlyCartOwner(permissions.BasePermission):

    message = "You must be the owner of this cart item."

    def has_object_permission(self, request, view, obj):
        return obj.cart.customer.user == request.user