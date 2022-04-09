import json
from channels.generic.websocket import AsyncJsonWebsocketConsumer
from asgiref.sync import async_to_sync


class OrderStatusConsumer(AsyncJsonWebsocketConsumer):

    async def connect(self):
        self.id = self.scope['url_route']['kwargs']['order_id']
        self.room_group_name = f"order_{self.id}"


        await self.channel_layer.group_add(
            self.room_group_name,
            self.channel_name
        )

        await self.accept()

    async def disconnect(self, code):
        await self.channel_layer.group_discard(
            self.room_group_name,
            self.channel_name
        )

    async def receive(self, text_data):
        text_data_json = json.loads(text_data)
        message = text_data_json['message']
        # send message to WebSocket
        await self.channel_layer.group_send (
            self.room_group_name,
            {
            'type': 'order_status',
            'message': message,
            }
        )
    
    async def order_status(self, event):
        # send message to WebSocket
        await self.send(text_data=json.dumps(event))