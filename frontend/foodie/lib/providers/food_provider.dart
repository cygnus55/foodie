import 'package:flutter/material.dart';
import './restaurant_provider.dart';

class Food with ChangeNotifier {
  int? id;
  String? name;
  String? description;
  String? price;
  String? sellingPrice;
  String? image;
  bool? isAvailable = true;
  int? discountPercent;
  Restaurant? restaurant;
  double? rating;
  int? ratingCount;
  List? tags;
  bool? isVeg;

  Food({
    this.id,
    this.name,
    this.description,
    this.price,
    this.image,
    this.discountPercent,
    this.isVeg,
    this.restaurant,
    this.tags,
    this.sellingPrice,
    this.rating,
    this.ratingCount,
  });

  void addFood() {
    notifyListeners();
  }
}
