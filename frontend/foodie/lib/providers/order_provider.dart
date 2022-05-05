import 'dart:convert';
import 'dart:async';
// import 'dart:ffi';
// import 'dart:html';

import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import './auth_provider.dart';
import 'package:provider/provider.dart';

import '../models/httpexception.dart';

class Order with ChangeNotifier {
  List<OrderItem> _orderItem = [];
  List<OrderItem> get OrderItems {
    return [..._orderItem];
  }

  OrderItem findById(String id) {
    return _orderItem.firstWhere((order) => order.orderid == id);
  }

  List<OrderItem> _items = [];
  Future<void> getorder(BuildContext context) async {
    try {
      var url = Uri.http('10.0.2.2:8000', 'orders/');
      http.Response response = await http.get(
        url,
        headers: {
          'Authorization': 'Token ' +
              Provider.of<Auth>(context, listen: false).getauthToken!,
        },
      );
      final data = json.decode(response.body) as Map<String, dynamic>;

      List<OrderItem> orderitem = [];
      for (var element in data['results']) {
        List<FoodItem> food = [];

        print(element);

        for (var ele in (element['items'] as List)) {
          print(ele);
          food.add(
            FoodItem(
              cost: ele['cost'],
              name: ele['food_name'],
              price: ele['price'],
              quantity: ele['quantity'],
              restaurantname: ele['restaurant_name'],
            ),
          );
        }
        orderitem.add(OrderItem(
            orderid: element['order_id'],
            totalamount: element['total_amount'],
            deliverycharge: element['delivery_charge'],
            paymentmethod: element['payment_method'],
            deliverylocation: element['delivery_location'],
            food: [...food],
            status: element['status']));
        print(food);
      }
      _orderItem = orderitem;
      print(orderitem);
      notifyListeners();
    } catch (error) {
      throw HttpException("Couldn't get the order");
    }
  }
}

class OrderItem {
  String? orderid;
  String? totalamount;
  String? deliverycharge;
  List? deliverylocation;
  String? paymentmethod;
  List<FoodItem>? food;
  String? status;
  OrderItem({
    this.orderid,
    this.deliverycharge,
    this.deliverylocation,
    this.paymentmethod,
    this.status,
    this.totalamount,
    this.food,
  });
}

class FoodItem {
  int? quantity;
  String? price;
  String? name;
  String? cost;
  String? restaurantname;

  FoodItem({
    this.quantity,
    this.price,
    this.name,
    this.cost,
    this.restaurantname,
  });
}
