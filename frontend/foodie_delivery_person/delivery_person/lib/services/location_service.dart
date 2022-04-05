import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';
// import 'package:provider/provider.dart';
import '../datamodels/user_location.dart';
import 'package:http/http.dart' as http;

// import '../providers/auth_provider.dart';


class LocationService with ChangeNotifier {
  // Keep track of current Location
  Location location = Location();
  // Continuously emit location updates
  final StreamController<UserLocation> _locationController =
      StreamController<UserLocation>.broadcast();
  late double oldlatitude =1;
  late double oldlongitude =1;

  LocationService() {
    location.requestPermission().then((granted) {
      if (granted == PermissionStatus.granted) {
        location.onLocationChanged.listen((locationData) {
          if (locationData != null) {
            _locationController.add(UserLocation(
              latitude: locationData.latitude,
              longitude: locationData.longitude,
            ));
            senduserlocation(locationData,);
            oldlatitude=locationData.latitude!;
            oldlongitude=locationData.longitude!;
          }
        });
      }
      else{
        print('Permission denied');}
    });
  }

  
  Future<bool> senduserlocation(LocationData newlocationData) async {
    try {
      if (oldlatitude!=newlocationData.latitude || oldlongitude!=newlocationData.longitude) {
        final prefs = await SharedPreferences.getInstance();
        print('pref is${prefs.getString('token')}'); 
        var url = Uri.http('10.0.2.2:8000', 'delivery-person/profile/');
        final http.Response response = await http.patch(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Token ' + prefs.getString('token')!,
          },
          body: json.encode(
            {
              'location':[newlocationData.latitude.toString(),newlocationData.longitude.toString()],
            },
          ),
        );    

        
       
      }
      }
      catch (e) {
        print(e);
      }
      return true;
  }
  Stream<UserLocation> get locationStream => _locationController.stream;

  // Future<UserLocation> getuserLocation() async {
  //   try {
  //     var userLocation = await location.getLocation();
  //     _currentLocation = UserLocation(
  //       latitude: userLocation.latitude,
  //       longitude: userLocation.longitude,
  //     );
  //     print('current location is $_currentLocation');
  //   } catch (e) {
  //     print('Could not get the location: $e');
  //   }

  //   return _currentLocation;
  // }
}