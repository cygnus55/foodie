import os

from django.core.asgi import get_asgi_application
from channels.auth import AuthMiddlewareStack
from channels.routing import ProtocolTypeRouter, URLRouter

import orders.routing

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'foodie.settings')

application = ProtocolTypeRouter({
  "http": get_asgi_application(),
  ## IMPORTANT::Just HTTP for now. (We can add other protocols later.)
  'websocket': AuthMiddlewareStack(
        URLRouter(
            orders.routing.websocket_urlpatterns
        )
    ),
})