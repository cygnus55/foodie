import 'package:flutter/cupertino.dart';

class Restaurant with ChangeNotifier {
  int? id;
  String? websiteLink;
  String? facebookLink;
  String? name;
  String? description;
  bool? isAvailable;
  String? openTime;
  double? rating;
  int? ratingCount;
  String? closeTime;
  String? logo;
  String? address;
  bool? openStatus;
  // List? tags;

  Restaurant({
    this.address,
    this.id,
    this.websiteLink,
    this.facebookLink,
    this.name,
    this.description,
    this.isAvailable,
    this.openTime,
    this.closeTime,
    this.logo,
    this.rating,
    this.ratingCount,
    this.openStatus,
  });
}
