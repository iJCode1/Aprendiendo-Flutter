import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:spootsmart/src/model/habitacion.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:spootsmart/src/ui/activosUsuario.dart';

late double lat;
late double lng;

// ignore: must_be_immutable
class ModificarUsuario extends StatefulWidget {
  // ********************* Mapa
  late final Location location = Location();
  late Future<LocationData> locData;
  late final MapController controller = MapController();
  //UTE Occidental
  // late double lat = 19.256175898897993;
  // late double lng = -99.57963267652704;
  double lat = 19.256175898897993;
  double lng = -99.57963267652704;
  late double zoom = 17;
  // * Mapa **********************
  final Habitacion habitacion;
  ModificarUsuario(this.habitacion);

  @override
  _ModificarUsuario createState() => _ModificarUsuario();
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
String? _chosenValue;
late List<dynamic> valores;
late List<dynamic> valoresIn;
late List<dynamic> val;
DataSnapshot? snapshot;

class _ModificarUsuario extends State<ModificarUsuario> {
  late TextEditingController idController;
  late TextEditingController nombreController;
  late TextEditingController fechaController;
  late TextEditingController latitudController;
  late TextEditingController longitudController;
  late TextEditingController statusController;
  DateTime selectedDate = DateTime.now();
  late List<Habitacion> items;
  String? fecha;
  String? fileFoto;
  File? _foto;
  String? fotoController = "";

  late double latitudeController = 0.0;
  late double longitudeController = 0.0;

  @override
  void initState() {
    idController = new TextEditingController(text: widget.habitacion.id);
    nombreController =
        new TextEditingController(text: widget.habitacion.nombre);
    fechaController = new TextEditingController(text: widget.habitacion.fecha);
    latitudController =
        new TextEditingController(text: widget.habitacion.latitud);
    lat = double.parse(latitudController.text);
    longitudController =
        new TextEditingController(text: widget.habitacion.longitud);
    lng = double.parse(longitudController.text);
    statusController =
        new TextEditingController(text: widget.habitacion.status);
    fotoController = (widget.habitacion.foto)!;
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
          title: Text('Modificar Habitación'),
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
                  padding: EdgeInsets.only(left: 20, right: 20),
                  //TextField en donde ingresaremos el id del usuario
                  child: TextField(
                    controller: idController,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 18.0,
                      fontFamily: 'Poppins',
                    ),
                    decoration: InputDecoration(
                      icon: Icon(Icons.perm_identity),
                      labelText: 'Nombre Habitación',
                    ),
                    keyboardType: TextInputType.text,
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 8.0)),
                Divider(),

                //Botón para realizar la busqueda
                Container(
                  width: 206,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: new Color.fromRGBO(119, 172, 241, 1),
                  ),
                  // ignore: deprecated_member_use
                  child: FlatButton(
                    onPressed: () => {_buscarProducto(idController.text)},
                    child: Text(
                      'Buscar',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Lato',
                          fontSize: 18),
                    ),
                    // color: new Color.fromRGBO(119, 172, 241, 1),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 8.0)),
                Divider(),

                //Fecha
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: TextField(
                    enabled: false,
                    controller: fechaController,
                    onChanged: (text) => selectedDate.toLocal(),
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 18.0,
                      fontFamily: 'Poppins',
                    ),
                    decoration: InputDecoration(
                      icon: Icon(Icons.date_range),
                      labelText: 'Fecha',
                    ),
                    keyboardType: TextInputType.text,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0),
                ),
                // ignore: deprecated_member_use
                Container(
                  width: 250,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: new Color.fromRGBO(119, 172, 241, 1),
                  ),
                  // ignore: deprecated_member_use
                  child: FlatButton(
                    onPressed: () => _selectDate(context), // Refer step 3
                    child: Text(
                      'Seleccionar otra Fecha',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Poppins',
                          fontSize: 16),
                    ),
                    // color: new Color.fromRGBO(119, 172, 241, 1),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                ),
                Divider(),

                //Status
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: TextField(
                    enabled: false,
                    controller: statusController,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 18.0,
                      fontFamily: 'Poppins',
                    ),
                    decoration: InputDecoration(
                      icon: Icon(Icons.check),
                      labelText: 'Status',
                    ),
                    keyboardType: TextInputType.text,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                ),

                //Status
                DropdownButton<String>(
                  focusColor: Colors.white,
                  value: _chosenValue,
                  //elevation: 5,
                  style: TextStyle(color: Colors.white),
                  iconEnabledColor: Colors.black,
                  items: <String>[
                    'Activa',
                    'Inactiva',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                  hint: Text(
                    "Escoge el status",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.normal, fontFamily: "Poppins"),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _chosenValue = value;
                    });
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                ),
                Divider(),

                //Latitud
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: TextField(
                    enabled: false,
                    controller: latitudController,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 18.0,
                      fontFamily: 'Poppins',
                    ),
                    decoration: InputDecoration(
                      icon: Icon(Icons.description),
                      labelText: 'Latitud',
                    ),
                    keyboardType: TextInputType.text,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                ),
                Divider(),

                //Longitud
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: TextField(
                    enabled: false,
                    controller: longitudController,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 18.0,
                      fontFamily: 'Poppins',
                    ),
                    decoration: InputDecoration(
                      icon: Icon(Icons.payment),
                      labelText: 'Longitud',
                    ),
                    autocorrect: true,
                    keyboardType: TextInputType.number,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                ),
                Divider(),

                //Mapa
                Container(
                  //padding: EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    children: [
                      Container(
                        width: 300,
                        height: 300,
                        child: Center(
                          child: FlutterMap(
                            mapController: widget.controller,
                            options: MapOptions(
                              // center: LatLng( widget.lat, widget.lng),
                              center: latitudeController != 0
                                  ? LatLng(double.parse(latitudController.text),
                                      double.parse(longitudController.text))
                                  : LatLng(
                                      double.parse(widget.habitacion.latitud!),
                                      double.parse(
                                          widget.habitacion.longitud!)),
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
                                    point: latitudeController != 0
                                        ? LatLng(
                                            double.parse(
                                                latitudController.text),
                                            double.parse(
                                                longitudController.text))
                                        : LatLng(
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
                      ),
                      TextButton(
                        onPressed: () {
                          widget.locData = widget.getLocation();

                          widget.locData.then((value) {
                            widget.lat = value.latitude!;
                            widget.lng = value.longitude!;
                            widget.controller.move(
                                LatLng(widget.lat, widget.lng), widget.zoom);
                            print(widget.lat);
                            latitudeController = value.latitude!;
                            latitudController.text = value.latitude!.toString();
                            print(widget.lng);
                            longitudeController = value.longitude!;
                            longitudController.text =
                                value.longitude!.toString();
                            setState(() {
                              //Navigator.pop(context);
                            });
                          });
                        },
                        child: Text('Obtener Ubicación', style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.normal))
                      ),
                    ],
                  ),
                ),

                //Imagen
                // Container(
                //   padding: EdgeInsets.only(left: 20, right: 20),
                //   child: TextField(
                //     enabled: false,
                //     controller: imagenController,
                //     style: TextStyle(
                //       fontWeight: FontWeight.bold,
                //       fontSize: 18.0,
                //       fontFamily: 'Lato',
                //     ),
                //     decoration: InputDecoration(
                //       icon: Icon(Icons.payment),
                //       labelText: 'Imagen',
                //     ),
                //     autocorrect: true,
                //     keyboardType: TextInputType.number,
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                ),
                Divider(),

                //Imagen
                // ignore: deprecated_member_use
                new Text(
                  "Foto de la Habitación:",
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18.0, fontFamily: "Poppins"),
                  textAlign: TextAlign.center,
                ),
                Container(
                  // padding:
                  //     EdgeInsets.only(top: 15, left: 20, right: 20, bottom: 50),
                  padding: EdgeInsets.only(
                    top: 18,
                  ),
                  width: 200,
                  // child: fotoController!.length > 10
                  //     ? new Image.file(
                  //         new File(fotoController.toString()),
                  //         height: 200,
                  //         width: double.infinity,
                  //       )
                  //     : Text('No hay foto')
                  child: new Image.file(new File(fotoController!)),
                ),
                Container(
                  padding: EdgeInsets.only(top: 25, bottom: 20),
                  child: Center(
                    child: Container(
                      // padding: const EdgeInsets.only(top: 20.0),
                      width: 206,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: new Color.fromRGBO(119, 172, 241, 1),
                      ),
                      // padding: EdgeInsets.only(top: 40),
                      // ignore: deprecated_member_use
                      child: FlatButton(
                        onPressed: getImage, // Refer step 3
                        child: Text(
                          'Tomar otra Foto',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Poppins',
                              fontSize: 18),
                        ),
                        // color: new Color.fromRGBO(119, 172, 241, 1),
                      ),
                    ),
                  ),
                ),
                Divider(),
                // ignore: deprecated_member_use
                FlatButton(
                  onPressed: () {
                    if (idController.text == '') {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: new Text("Error"),
                              content: new Text(
                                  "No se llenaron los campos de forma adecuada"),
                            );
                          });
                      // ignore: unnecessary_null_comparison
                    } else if (idController.text != null) {
                      if (_chosenValue == 'Activa') {
                        if (statusController.text == 'Activa') {
                          print(statusController);
                          productoRefActivo.child(idController.text).set({
                            'fecha': fechaController.text,
                            'foto': fotoController,
                            'latitud': latitudController.text,
                            'longitud': longitudController.text,
                            'status': _chosenValue,
                          }).then((_) => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ListViewProductUser()))
                              });
                        } else if (statusController.text == 'Inactiva') {
                          //Insertar en activo
                          print(idController.text);
                          productoRefActivo.child(idController.text).set({
                            'fecha': fechaController.text,
                            'foto': fotoController,
                            'latitud': latitudController.text,
                            'longitud': longitudController.text,
                            'status': _chosenValue,
                          }).then((_) => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ListViewProductUser()))
                              });

                          //Eliminar de Inactivo
                          productoRefInactivo
                              .child(idController.text)
                              .remove()
                              .then((_) => setState(() {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ListViewProductUser()));
                                  }));
                        }
                      } else if (_chosenValue == 'Inactiva') {
                        if (statusController.text == 'Inactiva') {
                          print(statusController);
                          productoRefInactivo.child(idController.text).set({
                            'fecha': fechaController.text,
                            'foto': fotoController,
                            'latitud': latitudController.text,
                            'longitud': longitudController.text,
                            'status': _chosenValue,
                          }).then((_) => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ListViewProductUser()))
                              });
                        } else if (statusController.text == 'Activa') {
                          //Insertar en Inactivo
                          print(statusController);
                          productoRefInactivo.child(idController.text).set({
                            'fecha': fechaController.text,
                            'foto': fotoController,
                            'latitud': latitudController.text,
                            'longitud': longitudController.text,
                            'status': _chosenValue,
                          }).then((_) => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ListViewProductUser()))
                              });

                          //Eliminar de Activo
                          productoRefActivo
                              .child(idController.text)
                              .remove()
                              .then((_) => setState(() {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ListViewProductUser()));
                                  }));
                        }
                      }
                    }
                  },

                  child: Container(
                    width: 250,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: new Color.fromRGBO(119, 172, 241, 1),
                    ),
                    child: Center(
                      child: Text(
                        'Actualizar',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Poppins',
                            fontSize: 20),
                      ),
                    ),
                  ),
                  // color: new Color.fromRGBO(119, 172, 241, 1),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 30),
                ),
              ],
            )),
          ),
        ));
  }

  _buscarProducto(String nombre) async {
    if (nombre == '') {
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
                          print("Si encontreeeeee"),
                          print(fotoController!.length),
                          latitudeController =
                              double.parse(latitudController.text),
                          longitudeController =
                              double.parse(longitudController.text),
                          print(latitudeController.runtimeType),
                          print(longitudeController.runtimeType),
                          print(latitudeController),
                          print(longitudeController),
                          print(val),
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
                                    latitudController.text = val[2],
                                    longitudController.text = val[3],
                                    statusController.text = val[4],
                                    print(val),
                                    print("Inactivossssss"),
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
                                      new Text("No se encontro la habitación"),
                                );
                              })
                        }
                    })
              }
          });
    }
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        fechaController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
        //fechaController.text = selectedDate.toString();
      });
  }

  Future getImage() async {
    final _fireStorage = FirebaseStorage.instance;
    // ignore: deprecated_member_use
    final image = await ImagePicker().getImage(source: ImageSource.camera);
    if (image != null) {
      var file = File(image.path);
      // Getting File Path
      String fileName = file.uri.path.split('/').last;

      // Uploading Image to FirebaseStorage
      var filePath = await _fireStorage
          .ref()
          .child('demo/$fileName')
          .putFile(file)
          .then((value) {
        return value;
      });
      // Getting Uploaded Image Url
      String downloadUrl = await filePath.ref.getDownloadURL();
      fileFoto = downloadUrl;
      setState(() {
        _foto = File(image.path);
        fotoController = image.path;
        print(image.path);
        print("el foto controller");
        print(fotoController);
      });
    }
  }
}
