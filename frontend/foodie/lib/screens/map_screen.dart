import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';

class MapScreen extends StatefulWidget {
  MapScreen({Key? key}) : super(key: key);
  static const routeName = '/map';

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  var location = [];
  var lat = 27.6253;
  var long = 85.5561;

  void setLocation(dynamic positio, latLng.LatLng direct) async {
    setState(() {
      lat = direct.latitude;
      long = direct.longitude;
    });
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
    print(placemarks);

    print(direct.latitude);
    print(direct.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text(' Set Delivery location')),
        body: Stack(children: [
          FlutterMap(
            options: MapOptions(
              onTap: setLocation,
              center: latLng.LatLng(lat, long),
              zoom: 15,
            ),
            layers: [
              TileLayerOptions(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c']),
              MarkerLayerOptions(
                markers: [
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: latLng.LatLng(lat, long),
                    builder: (ctx) => const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 25,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                          ),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text('Continue')),
                ),
              ))
        ]),
      ),
    );
  }
}
