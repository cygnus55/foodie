import 'dart:convert';
import 'dart:async';
// import 'dart:ffi';
// import 'dart:html';

import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../models/httpexception.dart';

class Auth with ChangeNotifier {
  late String _token;
  late String _userId;
  var authToken;
  var authtoken;

  var isNewusertoken = false;

  bool token(String _token) {
    if (_token == '') {
      return false;
    }
    return true;
  }

  String? get getauthToken {
    return authToken;
  }

  String? get userId {
    return _userId;
  }

  bool get isAuth {
    return authtoken != null;
  }

  Future<bool> login(String phoneNumber, String password) async {
    try {
      var url = Uri.http('10.0.2.2:8000', 'accounts/login/delivery-person/');
      final http.Response response = await http.post(
        url,
        body: json.encode(
          {
            'mobile': phoneNumber,
            'password': password,
          },
        ),
      );
      final responseData = json.decode(response.body);
      print(responseData);
      if (response.body.toString().contains('User logged in!')) {
        final prefs = await SharedPreferences.getInstance();
        final extractedData = json.decode(response.body);
        print(extractedData['token']);
        final _token = extractedData['token'];
        final _userId = extractedData['mobile'];
        authtoken = token(_token);
        authToken = _token;
        print(authtoken);
        print(_token);
        isAuth;
        getauthToken;
        notifyListeners();
        if (_token != null) {
          print(isAuth);
          prefs.setString('token', _token);
          prefs.setString('userId', _userId);
          print(prefs.getString('userId'));
        }
        return true;
      } else {
        print("error1");
        throw HttpException('Something went wrong');
      }
    } catch (error) {
      throw error;
    }
  }
   Future<void> submitPassword(String password) async {
    try {
      var url = Uri.http('10.0.2.2:8000', 'accounts/details/');
      print(password);
      // ignore: unused_local_variable

      final http.Response response = await http.patch(
        url,
        headers: {
          'Authorization': 'Token ' + authToken,
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            '[password]': password,
          },
        ),
      );
      final responseData = json.decode(response.body);
      print(responseData);
    } catch (error) {
      print(error);
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      if (!prefs.containsKey('token')) {
        return false;
      }
      if (prefs.containsKey('token')) {
        print(prefs.getString('token'));

        final extractedUserData = prefs.getString('token')!;
        print(extractedUserData);

        authToken = extractedUserData;
        authtoken = true;

        // _userId = extractedUserData['userId'] as String;
        notifyListeners();
        return true;
      }
      return false;
    } catch (error) {
      print(error);
      print('auto login error');
      throw HttpException('could not authenticate');
    }
  }
   Future<void> logout() async {
    print(authtoken);
    print(authToken);

    var url = Uri.http('10.0.2.2:8000', 'accounts/logout/');
    await http.get(url, headers: {
      'Authorization': 'Token ' + authToken,
    });
    // print(authtoken);

    authtoken = null;
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    prefs.clear();
    notifyListeners();
  }
}
