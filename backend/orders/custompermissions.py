from rest_framework import permissions

class AllowOnlyOwner(permissions.BasePermission):

    message = "You must be the owner of this order."

    def has_object_permission(self, request, view, obj):
        return obj.customer.user == request.user


class AllowOnlyOrderOwner(permissions.BasePermission):

    message = "You must be the owner of this order item."

    def has_object_permission(self, request, view, obj):
        return obj.cart.customer.user == request.user