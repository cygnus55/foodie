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
  // ignore: recursive_getters
  // Future<Void> get responseData => responseData;

  String? _token;
  String? _userId;
  // ignore: prefer_typing_uninitialized_variables
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

  bool get isNewuser {
    return isNewusertoken;
  }

  bool get isAuth {
    return authtoken != null;
  }

  Future<bool> signup(String phoneNumber, String otp) async {
    try {
      var url = Uri.http('10.0.2.2:8000', 'accounts/login/');
      print(otp);
      // ignore: unused_local_variable

      final http.Response response = await http.post(
        url,
        body: json.encode(
          {
            'mobile': phoneNumber,
            'otp': otp,
          },
        ),
      );
      final responseData = json.decode(response.body);
      print(responseData);
      if (response.body.toString().contains('User Login')) {
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
          // final userData = //_token;
          //     json.encode({
          //   'token': _token,
          //   'userId': _userId,
          // });
          // prefs.setString('userData', userData);
          print(isAuth);
          prefs.setString('token', _token);
          prefs.setString('userId', _userId);
          print(prefs.getString('userId'));
          // print(prefs.getString('userData'));

        }
        return true;
      }

      if (response.body.toString().contains('New user created')) {
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
        isNewusertoken = true;
        isNewuser;
        getauthToken;
        notifyListeners();

        if (_token != null) {
          // final userData = //_token;
          //     json.encode({
          //   'token': _token,
          //   'userId': _userId,
          // });
          // prefs.setString('userData', userData);
          print(isAuth);
          prefs.setString('token', _token);
          prefs.setString('userId', _userId);
          print(prefs.getString('userId'));
          // print(prefs.getString('userData'));

        }
        return true;
      }
      if (response.body.toString().contains('Invalid OTP')) {
        return true;
      } else {
        print("error1");
        throw Exception('Something went wrong');
      }
      // final responseData = json.decode(response.body);
      // print(responseData);
    } catch (error) {
      throw error;
    }
    return true;
  }

  // var status = response.statusCode;
  // if (status == 200) {
  //   Navigator.of(context)
  //       .pushNamed(OtpVerificationScreen.routeName, arguments: phoneNumber);
  //   return true;
  // } else {
  //   return false;
  // }

  Future<void> authenticate() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = //_token;
        json.encode({
      'token': _token,
      'userId': _userId,
    });
    prefs.setString('userData', userData);

    if (!prefs.containsKey('token') || !prefs.containsKey('userId')) {
      return;
    }
    _token = prefs.getString('token');
    _userId = prefs.getString('userId');
    notifyListeners();
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

  Future<void> submitName(String name) async {
    try {
      var url = Uri.http('10.0.2.2:8000', 'accounts/details/');
      print(name);
      // ignore: unused_local_variable

      final http.Response response = await http.patch(
        url,
        headers: {
          'Authorization': 'Token ' + authToken,
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'full_name': name,
          },
        ),
      );
      final responseData = json.decode(response.body);
      print(responseData);
    } catch (error) {
      print(error);
    }
  }

  Future<void> editName(String name) async {
    try {
      var url = Uri.http('10.0.2.2:8000', 'customers/profile/');
      print(name);
      // ignore: unused_local_variable

      final http.Response response = await http.patch(
        url,
        headers: {
          'Authorization': 'Token ' + authToken,
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'full_name': name,
          },
        ),
      );
      final responseData = json.decode(response.body);
      print(responseData);
    } catch (error) {
      print(error);
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
    _userId = null;
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    prefs.clear();
    notifyListeners();
  }
}
