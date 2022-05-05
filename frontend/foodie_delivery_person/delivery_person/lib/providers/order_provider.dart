import 'dart:convert';
import 'dart:async';
// import 'dart:ffi';
// import 'dart:html';

import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import './auth_provider.dart';
import '../models/httpexception.dart';

class Order with ChangeNotifier {
  List<OrderItem> _orderItem = [];
  List<OrderItem> get OrderItems {
    return [..._orderItem];
  }

  // String? get orderid {
  //   return OrderItem.orderid;
  // }

  OrderItem findById(String id) {
    return _orderItem.firstWhere((order) => order.orderid == id);
  }

  Future<void> acceptOrder(String orderid, BuildContext context) async {
    try {
      var url = Uri.http('10.0.2.2:8000', 'delivery-person/accept-order/');
      http.Response response = await http.post(
        url,
        headers: {
          'Authorization': 'Token ' +
              Provider.of<Auth>(context, listen: false).getauthToken!,
          'Content-Type': 'application/json'
        },
        body: json.encode({'order_id': orderid}),
      );
      print(response.body);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> verifyOrder(String orderid, BuildContext context) async {
    try {
      var url = Uri.http('10.0.2.2:8000', 'delivery-person/update-status/');
      http.Response response = await http.post(
        url,
        headers: {
          'Authorization': 'Token ' +
              Provider.of<Auth>(context, listen: false).getauthToken!,
          'Content-Type': 'application/json'
        },
        body: json.encode({'order_id': orderid, 'status': 'Verified'}),
      );

      print(response.body);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> cancelOrder(String orderid, BuildContext context) async {
    try {
      var url = Uri.http('10.0.2.2:8000', 'delivery-person/update-status/');
      http.Response response = await http.post(
        url,
        headers: {
          'Authorization': 'Token ' +
              Provider.of<Auth>(context, listen: false).getauthToken!,
          'Content-Type': 'application/json'
        },
        body: json.encode({'order_id': orderid, 'status': 'Verified'}),
      );

      print(response.body);
    } catch (e) {
      rethrow;
    }
  }

  List<OrderItem> _items = [];
  Future<void> getorder() async {
    try {
      _orderItem.clear();
      final prefs = await SharedPreferences.getInstance();
      print('for order pref is${prefs.getString('token')}');
      var url = Uri.http('10.0.2.2:8000', 'delivery-person/new-orders/');
      final http.Response response = await http.get(
        url,
        headers: {
          'Authorization': 'Token ' + prefs.getString('token')!,
        },
      );
      print(response);
      final data = json.decode(response.body) as List;
      List<OrderItem> orderitem = [];
      for (var element in data) {
        List<FoodItem> food = [];
        List<Restaurantlocation> restaurantLocation = [];

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

        for (var ele in (element['restaurant_location'] as List)) {
          print(ele);
          restaurantLocation.add(Restaurantlocation(
            name: ele['name'],
            location: ele['location'],
            distance: ele['distance'],
          ));
        }
        print(restaurantLocation);
        orderitem.add(
          OrderItem(
            customerName: element['customer']['full_name'],
            mobileNumber: element['customer']['mobile'],
            distance: element['customer']['distance'],
            orderid: element['order_id'],
            deliverycharge: element['delivery_charge'],
            food: [...food],
            deliverylocation: element['delivery_location'],
            paymentmethod: element['payment_method'],
            status: element['status'],
            totalamount: element['total_amount'],
            location: [...restaurantLocation],
          ),
        );
        print(orderitem);
      }
      _orderItem = orderitem;
      notifyListeners();
    } catch (error) {
      throw HttpException("Couldn't get the order");
    }
  }
}

class OrderItem {
  String? customerName;
  String? mobileNumber;
  int? distance;
  String? orderid;
  String? totalamount;
  String? deliverycharge;
  List? deliverylocation;
  String? paymentmethod;
  String? status;
  List<FoodItem>? food;
  List<Restaurantlocation>? location;
  OrderItem({
    this.customerName,
    this.mobileNumber,
    this.distance,
    this.orderid,
    this.deliverycharge,
    this.deliverylocation,
    this.food,
    this.paymentmethod,
    this.status,
    this.totalamount,
    this.location,
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

class Restaurantlocation {
  String? name;
  List? location;
  int? distance;
  Restaurantlocation({
    this.name,
    this.location,
    this.distance,
  });
}
