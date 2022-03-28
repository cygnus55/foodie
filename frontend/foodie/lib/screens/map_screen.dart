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
  MapController mapController = MapController();
  latLng.LatLng currentCenter = latLng.LatLng(27.6253, 85.5561);

  void setLocation(dynamic positio, latLng.LatLng direct) async {
    setState(() {
      lat = direct.latitude;
      long = direct.longitude;
      currentCenter = latLng.LatLng(lat, long);
    });
    mapController.move(currentCenter, 13);
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
    // print(placemarks);

    print(direct.latitude);
    print(direct.longitude);
  }

  void getlocation(place) async {
    List<Location> locations = await locationFromAddress(place);
    setState(() {
      lat = locations[0].latitude;
      long = locations[0].longitude;
      currentCenter = latLng.LatLng(lat, long);
    });
    mapController.move(currentCenter, 13);

    print(locations[0].latitude);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text(' Set Delivery location')),
        body: Stack(children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              onTap: setLocation,
              center: currentCenter,
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
          TextField(
            decoration: const InputDecoration(
                label: Text('Search your location'),
                fillColor: Colors.white,
                filled: true,
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder()),
            style: const TextStyle(color: Colors.black),
            textInputAction: TextInputAction.search,
            onSubmitted: (value) {
              getlocation(value);
            },
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
