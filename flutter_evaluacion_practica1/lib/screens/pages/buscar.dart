import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_evaluacion_practica1/src/model/pastel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class Buscar extends StatefulWidget {
  final Pastel pastel;
  Buscar(this.pastel);

  @override
  _Buscar createState() => _Buscar();
}

//Referencia a la tabla firebase
final pastelRef = FirebaseDatabase.instance.reference().child('pastel');
final pastelRefActivo =
    FirebaseDatabase.instance.reference().child('pastel').child('paginas');
//final pastelRefInactivo = FirebaseDatabase.instance.reference().child('pastel').child('inactivo');

String? articulo = "";
String? contacto = "";
String? descripcion = "";
String? fecha = "";
String? foto = "";
double? latitude = 0;
double? longitude = 0;
String? precio = "";

var respuesta;
String error = "";

bool seEncontroAlgo = false;

DataSnapshot? snapshot;
late List<dynamic> valores;

class _Buscar extends State<Buscar> {
  late TextEditingController articuloController;

  late List<Pastel> items;
  @override
  void initState() {
    articuloController =
        new TextEditingController(text: widget.pastel.articulo);
    seEncontroAlgo = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscar un Pastel'),
        backgroundColor: new Color.fromRGBO(48, 71, 94, 1),
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: new Color.fromRGBO(48, 71, 94, 1),
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      body: seEncontroAlgo == true
          ? Container(
              height: 800.0,
              padding: const EdgeInsets.all(20.0),
              child: Card(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: TextField(
                            controller: articuloController,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                fontFamily: 'Lato'),
                            decoration: InputDecoration(
                                icon: Icon(Icons.cake,
                                    color: new Color.fromRGBO(48, 71, 94, 1)),
                                labelText: 'ID del Articulo'),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 8.0)),
                        // ignore: deprecated_member_use
                        RaisedButton(
                          onPressed: () =>
                              _buscarPastel(articuloController.text),
                          child: Container(
                            padding: EdgeInsets.only(
                                  bottom: 10, top: 10, left: 15, right: 15),
                            child: Text(
                              'Buscar Producto',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                fontFamily: 'Lato',
                              ),
                            ),
                          ),
                          color: new Color.fromRGBO(48, 71, 94, 1),
                        ),

                        Padding(padding: EdgeInsets.only(top: 8.0)),
                        Divider(),

                        Container(
                          padding:
                              EdgeInsets.only(top: 10, left: 10, right: 10),
                          child: new Text(
                            "Nombre del Articulo: $articulo",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 8.0)),
                        Divider(),
                        Container(
                          padding:
                              EdgeInsets.only(top: 10, left: 10, right: 10),
                          child: new Text(
                            "Descripción: $descripcion",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18.0),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 8.0)),
                        Divider(),
                        Container(
                          padding:
                              EdgeInsets.only(top: 10, left: 10, right: 10),
                          child: new Text(
                            "Precio: $precio",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18.0),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 8.0)),
                        Divider(),
                        Container(
                          padding:
                              EdgeInsets.only(top: 10, left: 10, right: 10),
                          child: new Text(
                            "Fecha de Publicación: $fecha",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18.0),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 8.0)),
                        Divider(),
                        Container(
                          padding:
                              EdgeInsets.only(top: 10, left: 10, right: 10),
                          child: new Text(
                            "Contacto: $contacto",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18.0),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 8.0)),
                        Divider(),
                        Container(
                          padding:
                              EdgeInsets.only(top: 10, left: 10, right: 10),
                          child: Center(
                            child: Column(
                              children: [
                                new Text(
                                  "Ubicación de la Pastelería:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
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
                                      center: LatLng(latitude!, longitude!),
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
                                            point:
                                                LatLng(latitude!, longitude!),
                                            builder: (ctx) => Container(
                                              child: Icon(
                                                  Icons.pin_drop_rounded,
                                                  color: Colors.red,
                                                  size: 34),
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
                        Padding(padding: EdgeInsets.only(top: 8.0)),
                        Divider(),
                        // new Image.network("https://firebasestorage.googleapis.com/v0/b/flutterlogincrud.appspot.com/o/files%2FIMG-20210907-WA0001.jpg?alt=media&token=e58e7bc5-0080-4c00-9b7c-b4801ddb3815"),
                        // new Image.asset(widget.pastel.photo),
                        Container(
                            padding:
                                EdgeInsets.only(top: 10, left: 10, right: 10),
                            child: Column(
                              children: [
                                new Text(
                                  "Fotografía del producto:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                  textAlign: TextAlign.center,
                                ),
                                Container(
                                    padding: EdgeInsets.only(
                                      top: 18,
                                    ),
                                    child: new Image.file(new File("$foto"))),
                              ],
                            )),
                        Padding(padding: EdgeInsets.only(top: 8.0)),
                        Divider(),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : Container(
              height: 200.0,
              padding: const EdgeInsets.all(20.0),
              child: Card(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: TextField(
                            controller: articuloController,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                fontFamily: 'Lato'),
                            decoration: InputDecoration(
                                icon: Icon(Icons.cake,
                                    color: new Color.fromRGBO(48, 71, 94, 1)),
                                labelText: 'ID del Articulo'),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 20.0)),
                        Container(
                          // ignore: deprecated_member_use
                          child: RaisedButton(
                            onPressed: () =>
                                _buscarPastel(articuloController.text),
                            child: Container(
                              padding: EdgeInsets.only(
                                  bottom: 10, top: 10, left: 15, right: 15),
                              child: Text(
                                'Buscar Producto',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  fontFamily: 'Lato',
                                ),
                              ),
                            ),
                            color: new Color.fromRGBO(48, 71, 94, 1),
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 8.0)),
                        Divider(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  _buscarPastel(String id) async {
    try {
      seEncontroAlgo = false;
      respuesta =
          await pastelRef.child(id).once().then((DataSnapshot dataSnapshot) => {
                //print(dataSnapshot),
                //print(dataSnapshot.value),
                print(dataSnapshot.value.values),
                //valores = [...dataSnapshot.value.values],
                if (respuesta != null)
                  {
                    seEncontroAlgo = true,
                    valores = [...dataSnapshot.value.values],
                    print(valores[0]),
                    articulo = valores[0],
                    contacto = valores[1],
                    descripcion = valores[2],
                    fecha = valores[3],
                    foto = valores[4],
                    latitude = valores[5],
                    longitude = valores[6],
                    precio = valores[7],
                  }
                else
                  {seEncontroAlgo = false},
              });
      print("Respuestaaaaaa");
      print(respuesta);
    } catch (e) {
      print("Errrroooorr");
    }
    print(seEncontroAlgo);
  }
}

//print(dataSnapshot.value.entries.elementAt(0).value)
