import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(MaterialApp(
//     title: 'Ubicación',
//     home: MapaGoogle(),
//   ));
// }

// ignore: must_be_immutable
class MapaGoogle extends StatefulWidget {
  final Location location = Location();
  late Future<LocationData> locData;
  final MapController controller = MapController();
  //UTE Occidental
  double lat = -0.17951276077818973;
  double lng = -78.50650870312631;
  double zoom = 15;

  MapaGoogle({Key? key}) : super(key: key) {
    initLocation();
    locData = getLocation();
  }

  @override
  MapaGoogleState createState() => MapaGoogleState();

  void initLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return Future.error('Servicios de ubicación deshabilitados!');
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return Future.error('Permisos de ubicación no otorgados!');
      }
    }

    await location.changeSettings(interval: 2000, distanceFilter: 2);
  }

  Future<LocationData> getLocation() {
    return location.getLocation();
  }
}

class MapaGoogleState extends State<MapaGoogle> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            Container(
              width: 300,
              height: 300,
              child: Center(
                child: FlutterMap(
                  mapController: widget.controller,
                  options: MapOptions(
                    center: LatLng(widget.lat, widget.lng),
                    zoom: widget.zoom,
                  ),
                  layers: [
                    TileLayerOptions(
                        urlTemplate:
                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c']),
                    MarkerLayerOptions(
                      markers: [
                        Marker(
                          point: LatLng(widget.lat, widget.lng),
                          builder: (ctx) => Container(
                            child: Icon(Icons.pin_drop_rounded,
                                color: Colors.red, size: 34),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                widget.locData = widget.getLocation();

                widget.locData.then((value) {
                  widget.lat = value.latitude!;
                  widget.lng = value.longitude!;
                  widget.controller
                      .move(LatLng(widget.lat, widget.lng), widget.zoom);
                  print(widget.lat);
                  print(widget.lng);
                  setState(() {
                    //Navigator.pop(context);
                  });
                });

              },
              child: Text('Obtener Ubicación'),
            ),
          ],
        ),
      ),
    );
  }
}
