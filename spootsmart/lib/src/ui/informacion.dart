import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:spootsmart/src/model/habitacion.dart';

class InfoProducto extends StatefulWidget {
  final Habitacion habitacion;
  InfoProducto(this.habitacion);

  @override
  _InfoProductoState createState() => _InfoProductoState();
}

class _InfoProductoState extends State<InfoProducto> {
  late List<Habitacion> items;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backwardsCompatibility: false,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: new Color.fromRGBO(119, 172, 241, 1),
            statusBarIconBrightness: Brightness.light,
          ),
          title: Text('Información Habitación'),
          backgroundColor: new Color.fromRGBO(119, 172, 241, 1),
        ),
        body: SingleChildScrollView(
          //height: 400.0,
          padding: const EdgeInsets.all(20.0),
          child: Card(
            child: Center(
                child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 15.0, bottom: 10),
                  child: new Text("Nombre: ${widget.habitacion.id}",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 18.0,
                          fontFamily: 'Poppins')),
                ),
                Divider(),
                // Padding(padding: EdgeInsets.only(top: 10.0)),
                Container(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10),
                  child: new Text("Fecha: ${widget.habitacion.fecha}",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 18.0,
                          fontFamily: 'Poppins')),
                ),
                Divider(),
                // Padding(padding: EdgeInsets.only(top: 10.0)),
                Container(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10),
                  child: new Text("Status: ${widget.habitacion.status}",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 18.0,
                          fontFamily: 'Poppins')),
                ),
                Divider(),
                // Padding(padding: EdgeInsets.only(top: 8.0)),
                Container(
                  padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: Center(
                    child: Column(
                      children: [
                        new Text(
                          "Ubicación de la Habitación:",
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 18.0,
                              fontFamily: 'Poppins'),
                          textAlign: TextAlign.center,
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            top: 18,
                          ),
                          width: 300,
                          height: 300,
                          child: FlutterMap(
                            //mapController: widget.controller,
                            options: MapOptions(
                              center: LatLng(
                                  double.parse(widget.habitacion.latitud!),
                                  double.parse(widget.habitacion.longitud!)),
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
                                    point: LatLng(
                                        double.parse(
                                            widget.habitacion.latitud!),
                                        double.parse(
                                            widget.habitacion.longitud!)),
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
                      ],
                    ),
                  ),
                ),
                // Padding(padding: EdgeInsets.only(top: 12.0)),
                Container(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10),
                  child: new Text("Latitud: ${widget.habitacion.latitud}",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 18.0,
                          fontFamily: 'Poppins')),
                ),
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 10),
                  child: new Text("Longitud: ${widget.habitacion.longitud}",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 18.0,
                          fontFamily: 'Poppins')),
                ),
                Divider(),
                Container(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10),
                  child: new Text(
                    "Foto de la Habitación:",
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 18.0,
                        fontFamily: 'Poppins'),
                    textAlign: TextAlign.center,
                  ),
                ),
                // Padding(padding: EdgeInsets.only(top: 15.0)),
                Container(
                  padding: EdgeInsets.only(top: 5.0, bottom: 20.0),
                  child: new Image.file(
                    File(widget.habitacion.foto.toString()),
                    height: 200,
                    width: double.infinity,
                  ),
                ),
                // Padding(padding: EdgeInsets.only(top: 8.0)),
              ],
            )),
          ),
        ));
  }
}
