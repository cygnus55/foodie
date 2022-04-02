import 'dart:async';

import 'package:location/location.dart';
import '../datamodels/user_location.dart';
//  import 'package:location_service/datamodels/user_location.dart';

class LocationService {
  // Keep track of current Location
  Location location = Location();
  // Continuously emit location updates
  final StreamController<UserLocation> _locationController =
      StreamController<UserLocation>.broadcast();
  late double oldlatitude =0;
  late double oldlongitude =0;

  LocationService() {
    location.requestPermission().then((granted) {
      if (granted == PermissionStatus.granted) {
        location.onLocationChanged.listen((locationData) {
          if (locationData != null) {
            _locationController.add(UserLocation(
              latitude: locationData.latitude,
              longitude: locationData.longitude,
            ));
            senduserlocation(locationData);
            oldlatitude=locationData.latitude!;
            oldlongitude=locationData.longitude!;
            print('hi');
            print('hell0o');
          }
        });
      }
    });
  }
  Future<bool> senduserlocation(LocationData newlocationData ) async {
    try {
      if (oldlatitude!=newlocationData.latitude || oldlongitude!=newlocationData.longitude) {
            

        print('location changed');
       
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