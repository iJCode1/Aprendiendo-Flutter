import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as lt;
import 'package:location/location.dart';
import 'package:spootsmart/src/model/habitacion.dart';
import 'package:firebase_database/firebase_database.dart';

String? fotoController = "";

// ignore: must_be_immutable
class Buscar extends StatefulWidget {
  // ********************* Mapa
  late final Location location = Location();
  late Future<LocationData> locData;
  late final MapController controller = MapController();
  //UTE Occidental
  late double lat = 19.256175898897993;
  late double lng = -99.57963267652704;
  late double zoom = 17;
// * Mapa **********************
  final Habitacion habitacion;
  Buscar(this.habitacion);

  @override
  _Buscar createState() => _Buscar();

  // ********************* Mapa
  void initLocation() async {
    late bool _serviceEnabled;
    late PermissionStatus _permissionGranted;

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
// * Mapa **********************
}

//Referencia a la tabla firebase
final productoRef = FirebaseDatabase.instance.reference().child('Habitacion');
final productoRefActivo =
    FirebaseDatabase.instance.reference().child('Habitacion').child('Activa');
final productoRefInactivo =
    FirebaseDatabase.instance.reference().child('Habitacion').child('Inactiva');

String? imagen;
late List<dynamic> valores;
late List<dynamic> valoresIn;
late List<dynamic> val;
DataSnapshot? snapshot;

bool seEncontroAlgo = false;

class _Buscar extends State<Buscar> {
  late TextEditingController nombreController;
  late TextEditingController fechaController;
  late TextEditingController statusController;

  late TextEditingController latitudController;
  late TextEditingController longitudController;
  late List<Habitacion> items;

  late double latitudeController = 19.256175898897993;
  late double longitudeController = -99.57963267652704;

  @override
  void initState() {
    nombreController = new TextEditingController(text: '');
    fechaController = new TextEditingController(text: '');
    statusController = new TextEditingController(text: '');
    fotoController = '';
    latitudController = new TextEditingController(text: '');
    longitudController = new TextEditingController(text: '');
    seEncontroAlgo = false;
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
          backgroundColor: new Color.fromRGBO(119, 172, 241, 1),
        ),
        body: SingleChildScrollView(
          //height: 400.0,
          // padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Container(
              child: Column(
                children: [
                  ClipPath(
                    clipper: MyClipper(),
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: new Color.fromRGBO(119, 172, 241, 1),
                        // borderRadius: BorderRadius.only(
                        //   bottomLeft: Radius.circular(36),
                        //   bottomRight: Radius.circular(36),
                        // ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Búsqueda',
                              style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 38,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              // style: Theme.of(context)
                              //     .textTheme
                              //     .headline5
                              //     .copyWith(
                              //         fontSize: 38,
                              //         color: Colors.white,
                              //         fontFamily: 'Poppins',
                              //         fontWeight: FontWeight.bold),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                "Ingresa el nombre de la Habitación",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.bold,
                                  color: new Color.fromRGBO(220, 220, 220, 1),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Image.asset("assets/images/logo.png", width: 100)
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 40),

                          //TextField en donde ingresaremos el Nombre de la Habitación
                          child: TextField(
                            controller: nombreController,
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.normal,
                                fontSize: 18.0),
                            decoration: InputDecoration(
                              icon: Icon(Icons.king_bed_outlined),
                              labelText: 'Nombre Habitación',
                            ),
                            keyboardType: TextInputType.text,
                          ),
                        ),

                        Padding(padding: EdgeInsets.only(top: 8.0)),
                        Divider(),

                        //Botón para realizar la busqueda
                        // ignore: deprecated_member_use
                        Container(
                          width: 250,
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            // color: new Color.fromRGBO(119, 172, 241, 1),
                          ),
                          // ignore: deprecated_member_use
                          child: RaisedButton(
                            onPressed: () =>
                                {_buscarProducto(nombreController.text)},
                            child: Text(
                              'Buscar Habitación',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18),
                            ),
                            color: new Color.fromRGBO(119, 172, 241, 1),
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 8.0)),
                        Divider(),

                        //TextField en donde se muestra la Fecha
                        Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: TextField(
                            enabled: false,
                            controller: fechaController,
                            onChanged: (text) => {fechaController.text},
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.normal,
                                fontSize: 18.0),
                            decoration: InputDecoration(
                              icon: Icon(Icons.calendar_today),
                              labelText: 'Fecha: ',
                            ),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 8.0)),
                        Divider(),

                        //TextField en donde se muestra el Status
                        Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: TextField(
                            enabled: false,
                            controller: statusController,
                            onChanged: (text) => {statusController.text},
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.normal,
                                fontSize: 18.0),
                            decoration: InputDecoration(
                              icon: Icon(Icons.check),
                              labelText: 'Status: ',
                            ),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 8.0)),
                        Divider(),

                        //TextField en donde se muestra la Latitud
                        Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: TextField(
                            enabled: false,
                            controller: latitudController,
                            onChanged: (text) => {latitudController.text},
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.normal,
                                fontSize: 18.0),
                            decoration: InputDecoration(
                              icon: Icon(Icons.room),
                              labelText: 'Latitud: ',
                            ),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 8.0)),
                        Divider(),

                        //TextField en donde se muestra la Longitud
                        Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: TextField(
                            enabled: false,
                            controller: longitudController,
                            onChanged: (text) => {longitudController.text},
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.normal,
                                fontSize: 18.0),
                            decoration: InputDecoration(
                              icon: Icon(Icons.room),
                              labelText: 'Longitud: ',
                            ),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 8.0)),
                        Divider(),
                        //Mapa
                        // Container(
                        //   //padding: EdgeInsets.only(left: 10, right: 10),
                        //   child: Column(
                        //     children: [
                        //       Container(
                        //         width: 300,
                        //         height: 300,
                        //         child: Center(
                        //           child: FlutterMap(
                        //             mapController: widget.controller,
                        //             options: MapOptions(
                        //               // center: LatLng( widget.lat, widget.lng),
                        //               center: latitudeController != 0
                        //                   ? lt.LatLng(latitudeController,
                        //                       longitudeController)
                        //                   : lt.LatLng(widget.lat, widget.lng),
                        //               zoom: widget.zoom,
                        //             ),
                        //             layers: [
                        //               TileLayerOptions(
                        //                   urlTemplate:
                        //                       "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        //                   subdomains: ['a', 'b', 'c']),
                        //               MarkerLayerOptions(
                        //                 markers: [
                        //                   Marker(
                        //                     point: latitudeController != 0
                        //                         ? lt.LatLng(latitudeController,
                        //                             longitudeController)
                        //                         : lt.LatLng(
                        //                             widget.lat, widget.lng),
                        //                     builder: (ctx) => Container(
                        //                       child: Icon(
                        //                           Icons.pin_drop_rounded,
                        //                           color: Colors.red,
                        //                           size: 34),
                        //                     ),
                        //                   ),
                        //                 ],
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       ),
                        //       TextButton(
                        //         onPressed: () {
                        //           widget.locData = widget.getLocation();

                        //           widget.locData.then((value) {
                        //             widget.lat = value.latitude!;
                        //             widget.lng = value.longitude!;
                        //             widget.controller.move(
                        //                 lt.LatLng(widget.lat, widget.lng),
                        //                 widget.zoom);
                        //             print(widget.lat);
                        //             latitudeController = value.latitude!;
                        //             latitudController.text =
                        //                 value.latitude!.toString();
                        //             print(widget.lng);
                        //             longitudeController = value.longitude!;
                        //             longitudController.text =
                        //                 value.longitude!.toString();
                        //             setState(() {
                        //               //Navigator.pop(context);
                        //             });
                        //           });
                        //         },
                        //         child: Text(
                        //           'Obtener Ubicación',
                        //           style: TextStyle(
                        //             fontFamily: 'Poppins',
                        //             fontWeight: FontWeight.normal,
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        Padding(padding: EdgeInsets.only(top: 8.0)),
                        Divider(),

                        //TextField en donde se muestra el URL de la imagen
                        // Container(
                        //   padding: EdgeInsets.only(left: 10, right: 10),
                        //   child: TextField(
                        //     enabled: false,
                        //     controller: fotoController,
                        //     onChanged: (text) => {imagenController.text},
                        //     style: TextStyle(
                        //         fontWeight: FontWeight.bold, fontSize: 18.0),
                        //     decoration: InputDecoration(
                        //       icon: Icon(Icons.picture_in_picture),
                        //       labelText: 'Imagen: ',
                        //     ),
                        //     keyboardType: TextInputType.text,
                        //   ),
                        // ),
                        // Padding(padding: EdgeInsets.only(top: 8.0)),
                        // Divider(),
                        // new Text(
                        //   "Foto de la Habitación:",
                        //   style: TextStyle(
                        //       fontWeight: FontWeight.normal,
                        //       fontSize: 18.0,
                        //       fontFamily: "Poppins"),
                        //   textAlign: TextAlign.center,
                        // ),
                        // //Para que apresca la imagen registrada en la BD
                        // Container(
                        //     padding: EdgeInsets.only(
                        //       top: 18,
                        //     ),
                        //     width: 200,

                        //     // ignore: unnecessary_null_comparison
                        //     // child: fotoController != null
                        //     //     ? Image.file(File(fotoController.toString()),
                        //     //         key: Key(fotoController.toString()))
                        //     //     : Text('No hay imagen')

                        //     // : new Image.file(
                        //     //     new File(fotoController.toString())),
                        //     // ignore: unnecessary_null_comparison
                        //     // child: imagenController.text == null
                        //     //     ? Text('No hay imagen')
                        //     //     : Image.network(
                        //     //         imagenController.text,
                        //     //         height: 200,
                        //     //         width: double.infinity,
                        //     //       ),
                        //     child: new Image.file(new File(widget.habitacion.foto.toString())),
                        //     ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  _buscarProducto(String nombre) async {
    print(nombreController.text);
    print(nombre);
    // ignore: unnecessary_null_comparison
    if (nombre == '' || nombre == null) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text("Error"),
              content: new Text("No se llenaron los campos de forma adecuada"),
            );
          });
    } else {
      await productoRefActivo.once().then((DataSnapshot dataSnapshot) => {
            //valores = [...dataSnapshot.value.values],
            fechaController.text = '',
            fotoController = '',
            latitudController.text = '',
            longitudController.text = '',
            statusController.text = '',
            valores = [...dataSnapshot.value.keys],
            if (valores.contains(nombre))
              {
                print('Encontro el valor en la lista'),
                print(valores),
                productoRefActivo
                    .child(nombre)
                    .once()
                    .then((DataSnapshot dataSnapshot) => {
                          val = [...dataSnapshot.value.values],
                          fechaController.text = val[0],
                          fotoController = val[1],
                          latitudController.text = val[2],
                          longitudController.text = val[3],
                          statusController.text = val[4],
                          print(val),
                          print(fotoController),
                          val = []
                        })
              }
            else
              {
                print('No lo encontro en la lista'),
                print(valores),
                productoRefInactivo.once().then((DataSnapshot dataSnapshot) => {
                      valoresIn = [...dataSnapshot.value.keys],
                      if (valoresIn.contains(nombre))
                        {
                          print('Lo encontro en Inactivos'),
                          print(valoresIn),
                          productoRefInactivo
                              .child(nombre)
                              .once()
                              .then((DataSnapshot dataSnapshot) => {
                                    val = [...dataSnapshot.value.values],
                                    fechaController.text = val[0],
                                    fotoController = val[1],
                                    widget.habitacion.foto = val[1],
                                    latitudController.text = val[2],
                                    longitudController.text = val[3],
                                    statusController.text = val[4],
                                    print(val),
                                    val = []
                                  })
                        }
                      else
                        {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: new Text("Error"),
                                  content:
                                      new Text("No se encontro la Habitación"),
                                  actions: <Widget>[
                                    // ignore: deprecated_member_use
                                    new FlatButton(
                                      child: new Text("Ok"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                );
                              })
                        }
                    })
              }
          });
    }
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0, size.height - 90); //Bottom - Left
    var controllPoint = Offset(50, size.height);
    var endPoint = Offset(size.width / 2, size.height);
    path.quadraticBezierTo(
        controllPoint.dx, controllPoint.dy, endPoint.dx, endPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
