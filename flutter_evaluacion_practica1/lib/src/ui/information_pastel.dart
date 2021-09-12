import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:flutter_evaluacion_practica1/src/model/pastel.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class InfoPastel extends StatefulWidget{
  final Pastel pastel;
  InfoPastel(this.pastel);
  @override
  _InfoPastelState createState() => _InfoPastelState();
}
final pastelRF = FirebaseDatabase.instance.reference().child('pastel');

class _InfoPastelState extends State<InfoPastel>{
  late List<Pastel> items;
  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backwardsCompatibility: false,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: new Color.fromRGBO(48, 71, 94, 1),
            statusBarIconBrightness: Brightness.light,
          ),
        title:Text("Información"),
        backgroundColor: new Color.fromRGBO(48, 71, 94, 1),
      ),
      body:Container(
        height: 800.0,
        padding: const EdgeInsets.all(20.0),
        child: Card(
          child:Center(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: new Text(
                      "Nombre del Articulo: ${widget.pastel.articulo}",
                      style: TextStyle(fontWeight:FontWeight.bold, fontSize:18.0,),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(padding:EdgeInsets.only(top:8.0)),
                  Divider(),
                  Container(
                    padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: new Text(
                      "Descripción: ${widget.pastel.descripcion}",
                      style: TextStyle(fontWeight:FontWeight.bold, fontSize:18.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(padding:EdgeInsets.only(top:8.0)),
                  Divider(),
                  Container(
                    padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: new Text(
                      "Precio: ${widget.pastel.precio}",
                      style: TextStyle(fontWeight:FontWeight.bold, fontSize:18.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(padding:EdgeInsets.only(top:8.0)),
                  Divider(),
                  Container(
                    padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: new Text(
                      "Fecha de Publicación: ${widget.pastel.fecha}",
                      style: TextStyle(fontWeight:FontWeight.bold, fontSize:18.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(padding:EdgeInsets.only(top:8.0)),
                  Divider(),
                  Container(
                    padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: new Text(
                      "Contacto: ${widget.pastel.contacto}",
                      style: TextStyle(fontWeight:FontWeight.bold, fontSize:18.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(padding:EdgeInsets.only(top:8.0)),
                  Divider(),
                  Container(
                    padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                    
                    child: Center(
                      child: Column(
                        children: [
                            new Text(
                          "Ubicación de la Pastelería:",
                            style: TextStyle(fontWeight:FontWeight.bold, fontSize:18.0),
                            textAlign: TextAlign.center,
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 18,),
                            width: 300,
                            height: 300,
                            child: FlutterMap(
                              //mapController: widget.controller,
                              options: MapOptions(
                                center: LatLng(widget.pastel.latitude, widget.pastel.longitude),
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
                                      point: LatLng(widget.pastel.latitude, widget.pastel.longitude),
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
                  Padding(padding:EdgeInsets.only(top:8.0)),
                  Divider(),
                  // new Image.network("https://firebasestorage.googleapis.com/v0/b/flutterlogincrud.appspot.com/o/files%2FIMG-20210907-WA0001.jpg?alt=media&token=e58e7bc5-0080-4c00-9b7c-b4801ddb3815"),
                  // new Image.asset(widget.pastel.photo),
                  Container(
                    padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: Column(
                      children: [
                        new Text(
                        "Fotografía del producto:",
                          style: TextStyle(fontWeight:FontWeight.bold, fontSize:18.0),
                          textAlign: TextAlign.center,
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 18,),
                          child: new Image.file(new File("${widget.pastel.foto}"))
                        ),
                      ],
                    )
                  ),
                  Padding(padding:EdgeInsets.only(top:8.0)),
                  Divider(),
                ],
              ),
            ),
          )
        )
      ),
    );
  }
}