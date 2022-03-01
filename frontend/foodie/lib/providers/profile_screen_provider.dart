import 'dart:convert';
import 'dart:async';
// import 'dart:ffi';
// import 'dart:html';

import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Profile with ChangeNotifier {
  Map userProfile = {
    'username': '',
    'userid': '',
    'userMobile': '',
    'userEmail': '',
    'userProfilePicture': '',
  };
  // String? _userId;
  // String? _userName;
  // String? _userEmail;
  var authToken;
  // String? _userPhone;

  // String? get userName {
  //   return _userName;
  // }

  Map? get userprofile {
    return {...userProfile};
  }

  Profile(this.authToken);

  Future<void> getAccountDetails() async {
    try {
      var url = Uri.http('10.0.2.2:8000', 'customers/profile');

      final http.Response response = await http.get(
        url,
        headers: {
          'Authorization': 'Token ' + authToken,
        },
      );

      final responseData = json.decode(response.body);
      // print(responseData);
      // _userName = responseData['full_name'];
      // userName;
      userProfile['username'] = responseData['full_name'];
      userProfile['userid'] = responseData['id'];
      userProfile['userMobile'] = responseData['mobile'];
      userProfile['userEmail'] = responseData['email'];
      userProfile['userProfilePicture'] = responseData['profile_picture'];

      userprofile;
      // print(userprofile);

      notifyListeners();
      // print(_userName);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> changeProfilePicture(String image) async {
    try {
      var url = Uri.http('10.0.2.2:8000', 'customers/profile/');

      // ignore: unused_local_variable

      final http.Response response = await http.patch(
        url,
        headers: {
          'Authorization': 'Token ' + authToken,
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'profile_picture': image,
          },
        ),
      );
      final responseData = json.decode(response.body);
      print(responseData);
    } catch (error) {
      rethrow;
    }
  }
}
