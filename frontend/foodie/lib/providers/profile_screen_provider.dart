import 'dart:convert';
import 'dart:async';
// import 'dart:ffi';
// import 'dart:html';

import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../models/httpexception.dart';

class Profile with ChangeNotifier {
  String? _userId;
  String? _userName;
  String? _userEmail;
  final String authToken;
  String? _userPhone;

  String? get userName {
    return _userName;
  }

  Profile(this.authToken);

  Future<void> getAccountDetails() async {
    try {
      var url = Uri.http('10.0.2.2:8000', 'accounts/details/');

      final http.Response response = await http.get(
        url,
        headers: {
          'Authorization': 'Token ' + authToken,
        },
      );
      
      final responseData = json.decode(response.body);
      print(responseData);
      _userName= responseData['full_name'];
      notifyListeners();
      print(_userName);
    } catch (error) {
      print(error);
    }
  }
}