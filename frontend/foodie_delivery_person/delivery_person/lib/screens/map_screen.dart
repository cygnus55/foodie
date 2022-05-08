import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng;
import '../datamodels/user_location.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  static const routeName = '/map_screen';

  MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)?.settings.arguments as Map;

    double lat = double.parse(args['latitude']);
    double long = double.parse(args['longitude']);
    return Scaffold(
      appBar: AppBar(title: const Text('View Locations')),
      body: FlutterMap(
        options: MapOptions(
          center: latLng.LatLng(lat, long),
          zoom: 13,
        ),
        layers: [
          TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
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
              Marker(
                width: 80.0,
                height: 80.0,
                point: latLng.LatLng(
                    Provider.of<UserLocation>(context).latitude!,
                    Provider.of<UserLocation>(context).longitude!),
                builder: (ctx) => const Icon(
                  Icons.location_on,
                  color: Colors.blue,
                  size: 25,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
