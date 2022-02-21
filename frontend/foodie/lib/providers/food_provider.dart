import 'package:flutter/material.dart';

class Food with ChangeNotifier {
  String? id;
  String? name;
  String? description;
  double? price;
  String? image;
  bool? isAvailable = true;
  int? discountPercent;
  // Map<String,dynamic>? restaurant;
  // List? tags;
  bool? isVeg;

  Food({
    this.id,
    this.name,
    this.description,
    this.price,
    this.image,
    this.discountPercent,
    this.isVeg,
  });

  void addFood() {
    notifyListeners();
  }
}
