from rest_framework import permissions

class IsCurrentUserCustomer(permissions.BasePermission):

    message = "You must be a customer to access this resource."

    def has_permission(self, request, view):
        if request.method in permissions.SAFE_METHODS:
            return True
        return request.user.is_customer


class IsCurrentUserRestaurant(permissions.BasePermission):

    message = "You must be a restaurant to access this resource."

    def has_permission(self, request, view):
        if request.method in permissions.SAFE_METHODS:
            return True
        return request.user.is_restaurant


class IsCurrentUserDeliveryPerson(permissions.BasePermission):

    message = "You must be a delivery person to access this resource."

    def has_permission(self, request, view):
        if request.method in permissions.SAFE_METHODS:
            return True
        return request.user.is_delivery_person