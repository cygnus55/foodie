import 'package:flutter/cupertino.dart';

class Restaurant with ChangeNotifier {
  String? id;
  String? websiteLink;
  String? facebookLink;
  String? name;
  String? description;
  bool? isAvailable;
  DateTime? openTime;
  DateTime? closeTime;
  String? logo;
  // List? tags;

  Restaurant({
    this.id,
    this.websiteLink,
    this.facebookLink,
    this.name,
    this.description,
    this.isAvailable,
    this.openTime,
    this.closeTime,
    this.logo,
  });
}
