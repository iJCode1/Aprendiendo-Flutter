import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart' as lc;
import 'package:permission_handler/permission_handler.dart';
import 'package:spootsmart/src/model/habitacion.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class Altas extends StatefulWidget {
  // ********************* Mapa
  late final lc.Location location = lc.Location();
  late Future<lc.LocationData> locData;
  late final MapController controller = MapController();
  //UTE Occidental
  late double lat = 19.256175898897993;
  late double lng = -99.57963267652704;
  late double zoom = 17;
  // * Mapa **********************

  final Habitacion habitacion;
  Altas(this.habitacion);

  @override
  _AltasState createState() => _AltasState();

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

    _permissionGranted = (await location.hasPermission()) as PermissionStatus;
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted =
          (await location.requestPermission()) as PermissionStatus;
      if (_permissionGranted != PermissionStatus.granted) {
        return Future.error('Permisos de ubicación no otorgados!');
      }
    }

    await location.changeSettings(interval: 2000, distanceFilter: 2);
  }

  Future<lc.LocationData> getLocation() {
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

class _AltasState extends State<Altas> {
  late TextEditingController nombreController;
  late TextEditingController fechaController;
  late TextEditingController latitudController;
  late TextEditingController longitudController;
  late TextEditingController statusController;
  String? fileUrl;
  String? fileFoto;
  String? imagenController = "";
  String? _chosenValue;
  DateTime selectedDate = DateTime.now();
  String? fecha;
  File? _foto;
  late String fotoController = "";
  File? file;


  late double latitudeController = 0.0;
  late double longitudeController = 0.0;

  @override
  void initState() {
    super.initState();
    nombreController =
        new TextEditingController(text: widget.habitacion.nombre);
    fechaController = new TextEditingController(text: widget.habitacion.fecha);
    latitudController =
        new TextEditingController(text: widget.habitacion.latitud);
    longitudController =
        new TextEditingController(text: widget.habitacion.longitud);
    statusController =
        new TextEditingController(text: widget.habitacion.status);
    // imagenController = (widget.habitacion.imagen);
    fotoController = (widget.habitacion.foto)!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: new Color.fromRGBO(119, 172, 241, 1),
          statusBarIconBrightness: Brightness.light,
        ),
        title: Text(''),
        backgroundColor: new Color.fromRGBO(119, 172, 241, 1),
      ),
      body: SingleChildScrollView(
        //padding: const EdgeInsets.all(20.0),
        child: Container(
          child: Center(
            child: Form(
              child: Column(children: <Widget>[
                Center(
                  child: Container(
                    // padding: EdgeInsets.only(top: 45),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 2 - 270,
                    decoration: BoxDecoration(
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.black.withOpacity(0.7),
                        //     blurRadius: 20,
                        //     spreadRadius: 10,
                        //   )
                        // ],
                        color: new Color.fromRGBO(119, 172, 241, 1),
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                        )),
                    child: Column(
                      children: <Widget>[
                        Center(
                          child: Container(
                            padding: EdgeInsets.only(top: 24),
                            child: Center(
                                child: Text(
                              "Alta de\nHabitación",
                              style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'Lato'),
                              textAlign: TextAlign.center,
                            )),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
                //Foto
                // ignore: deprecated_member_use
                Padding(padding: EdgeInsets.only(top: 20)),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 10, bottom: 30),
                        child: Center(
                          child: _foto == null
                              ? Text('No se ha tomado una foto',
                                  style: TextStyle(fontFamily: 'Lato'))
                              : Image.file(
                                  _foto!,
                                  height: 200,
                                  width: double.infinity,
                                ),
                        ),
                      ),
                      Center(
                        child: Container(
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
                              'Toma una Foto',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Lato',
                                  fontSize: 18),
                            ),
                            // color: new Color.fromRGBO(119, 172, 241, 1),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 30.0),
                      ),
                      //Nombre
                      TextField(
                        controller: nombreController,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            fontFamily: 'Lato'),
                        decoration: InputDecoration(
                          icon: Icon(Icons.king_bed_outlined),
                          labelText: 'Nombre Habitación',
                        ),
                        keyboardType: TextInputType.text,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                      ),
                      Divider(),

                      //Fecha
                      TextField(
                        enabled: false,
                        controller: fechaController,
                        onChanged: (text) => selectedDate.toLocal(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            fontFamily: 'Lato'),
                        decoration: InputDecoration(
                          icon: Icon(Icons.date_range),
                          labelText: 'Fecha',
                        ),
                        keyboardType: TextInputType.text,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                      ),
                      Divider(),
                      // ignore: deprecated_member_use
                      Container(
                        width: 206,
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: new Color.fromRGBO(119, 172, 241, 1),
                        ),
                        // ignore: deprecated_member_use
                        child: RaisedButton(
                          onPressed: () => _selectDate(context), // Refer step 3
                          child: Text(
                            'Selecciona Fecha',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Lato',
                                fontSize: 18),
                          ),
                          color: new Color.fromRGBO(119, 172, 241, 1),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                      ),
                      Divider(),

                      //Status
                      TextField(
                        enabled: false,
                        controller: statusController,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            fontFamily: 'Lato'),
                        decoration: InputDecoration(
                          icon: Icon(Icons.check),
                          labelText: 'Status',
                        ),
                        keyboardType: TextInputType.text,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                      ),
                      Divider(),
                      //Status
                      DropdownButton<String>(
                        focusColor: Colors.white,
                        value: _chosenValue,
                        //elevation: 5,
                        style:
                            TextStyle(color: Colors.white, fontFamily: 'Lato'),
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
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Lato'),
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            _chosenValue = value;
                            statusController.text = _chosenValue!;
                          });
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                      ),
                      Divider(),

                      //Latitud
                      TextField(
                        enabled: false,
                        controller: latitudController,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            fontFamily: 'Lato'),
                        decoration: InputDecoration(
                            icon: Icon(Icons.description),
                            // labelText: 'Latitud',
                            labelText: 'Latitud'),
                        keyboardType: TextInputType.text,
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                      ),
                      Divider(),

                      //Longitud
                      TextField(
                        enabled: false,
                        controller: longitudController,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            fontFamily: 'Lato'),
                        decoration: InputDecoration(
                            icon: Icon(Icons.payment),
                            labelText: 'Longitud'),
                        autocorrect: true,
                        keyboardType: TextInputType.number,
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
                                        ? LatLng(latitudeController,
                                            longitudeController)
                                        : LatLng(widget.lat, widget.lng),
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
                                              ? LatLng(latitudeController,
                                                  longitudeController)
                                              : LatLng(widget.lat, widget.lng),
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
                                      LatLng(widget.lat, widget.lng),
                                      widget.zoom);
                                  print(widget.lat);
                                  latitudeController = value.latitude!;
                                  latitudController.text =
                                      value.latitude!.toString();
                                  print(widget.lng);
                                  longitudeController = value.longitude!;
                                  longitudController.text =
                                      value.longitude!.toString();
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

                      //Agregando Datos a Firebase
                      // ignore: deprecated_member_use
                      FlatButton(
                          onPressed: () {
                            if (fecha == null) {
                              fecha = selectedDate.toString();
                            }
                            if (fileFoto == '' ||
                                nombreController.text == '' ||
                                fecha == null ||
                                latitudController.text == '' ||
                                longitudController.text == '' ||
                                _chosenValue == '') {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: new Text("Error"),
                                      content: new Text(
                                          "No se llenaron los campos de forma adecuada"),
                                    );
                                  });
                            } else if (_chosenValue == 'Activa') {
                              print('Se inserta en Activas');
                              print(statusController.text);
                              productoRefActivo
                                  .child(nombreController.text)
                                  .set({
                                'fecha': fecha,
                                'latitud': latitudController.text,
                                'longitud': longitudController.text,
                                'status': statusController.text,
                                'foto': fotoController,
                              }).then((_) => {Navigator.pop(context)});
                            } else {
                              print(fecha);
                              productoRefInactivo
                                  .child(nombreController.text)
                                  .set({
                                'fecha': fecha,
                                'latitud': latitudController.text,
                                'longitud': longitudController.text,
                                'status': statusController.text,
                                'foto': fotoController,
                              }).then((_) => {Navigator.pop(context)});
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.only(top: 20),
                            child: Text(
                              'Añadir',
                              style: TextStyle(
                                  fontFamily: 'Lato',
                                  color: new Color.fromRGBO(119, 172, 241, 1),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          )),
                      Padding(padding: EdgeInsets.only(bottom: 20))
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
  //uploadImage

  Future<void> uploadImage() async {
    final _fireStorage = FirebaseStorage.instance;
    final image = ImagePicker();
    PickedFile? pickedFile;

    // Request Photos Permission
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;

    // Checking Permission
    if (permissionStatus.isGranted) {
      // ignore: deprecated_member_use
      pickedFile = await image.getImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        var file = File(pickedFile.path);
        // Getting File Path
        //  final ImagePicker _picker = ImagePicker();
        // final XFile? image = await _picker.pickImage(source: ImageSource.camera);
        // fotoController = image!.path.toString();
        // print("****************************************************************");
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
        fileUrl = downloadUrl;
        setState(() {});
      } else {
        print('No Image Selected');
      }
    } else {
      print('Provider Permission');
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
        fecha = fechaController.text =
            DateFormat('yyyy-MM-dd').format(selectedDate);
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
        print("esta foto");
        print(image.path);
        fotoController = image.path.toString();
      });
    }
  }


}
