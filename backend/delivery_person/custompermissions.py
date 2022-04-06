from rest_framework import permissions

class IsCurrentUserOwner(permissions.BasePermission):

    message = "You must be the owner of this delivery person profile."

    def has_object_permission(self, request, view, obj):
        return obj.user == request.user


class HasCurrentUserAcceptedThisOrder(permissions.BasePermission):

    message = "You must have accepted this order."

    def has_object_permission(self, request, view, obj):
        return obj.accepted_by == request.user.delivery_person