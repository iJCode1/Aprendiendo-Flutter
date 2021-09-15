import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:flutter_evaluacion_practica1/screens/uploadButton/button_widget.dart';
import 'package:flutter_evaluacion_practica1/services/firebase_api.dart';
import 'package:flutter_evaluacion_practica1/src/model/pastel.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';

var cambiarEstado = false;
var statusActuall = "";
// ignore: must_be_immutable
class ScreenPastel extends StatefulWidget{

// ********************* Mapa 
  late final Location location = Location();
  late Future<LocationData> locData;
  late final MapController controller = MapController();
  //UTE Occidental
  late double lat = 19.256175898897993;
  late double lng = -99.57963267652704;
  late double zoom = 17;
// * Mapa **********************

  final Pastel pastel;
  final bool activar;
  final String statusActual;
  ScreenPastel(this.pastel, this.activar, this.statusActual){
    initLocation();
    locData = getLocation();
    print("El estado es.......");
    print(activar);
    print("El Status es.......");
    print(statusActual);

    if(activar == true){
      cambiarEstado = true;
      statusActuall = statusActual;
    }else{
      cambiarEstado = false;
    }
  }

  @override
  _ScreenPastelState createState() => _ScreenPastelState();


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

final pastelRF = FirebaseDatabase.instance.reference().child('pastel');

class _ScreenPastelState extends State<ScreenPastel>{
  late List<Pastel> items;

  late TextEditingController articuloController;
  late TextEditingController descripcionController;
  late TextEditingController precioController;
  late String fechaController = "";
  late String statusController = "";
  late TextEditingController contactoController;
  late double latitudeController;
  late double longitudeController;
  late String fotoController = "";
  DateTime?  _dateTime;
  final _formkey = GlobalKey<FormState>();
  UploadTask? task;
  File? file;

  String? statusElegido;
  List _status = ["Activo", "Inactivo"];

  late File sampleImage;

  // ignore: unused_element
  static bool get activar => activar;


  @override
  void initState(){
    articuloController = new TextEditingController(text:widget.pastel.articulo);
    descripcionController = new TextEditingController(text:widget.pastel.descripcion);
    precioController = new TextEditingController(text:widget.pastel.precio);
    fechaController = (widget.pastel.fecha)!;
    statusController = (widget.pastel.status)!;
    //print(statusController);
    contactoController = new TextEditingController(text:widget.pastel.contacto);
    latitudeController = (widget.pastel.latitude);
    longitudeController = (widget.pastel.longitude);
    fotoController = (widget.pastel.foto);
    super.initState();
  }

    @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    precioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file!.path) : 'No se ha seleccionado una foto';    

    void _datePresent(){
        showDatePicker(
          context: context, 
          initialDate: DateTime.now(), 
          firstDate: DateTime(2021), 
          lastDate: DateTime.now())
          .then((value){
            if(value == null){
              return;
            }else{
              setState(() {
                _dateTime = value;
                fechaController = DateFormat.yMEd().format(_dateTime!).toString();
              });
            }
          }
        );
    }

    return Scaffold(
      resizeToAvoidBottomInset:true,
      appBar: AppBar(
        title: Text("Articulos"),
        backwardsCompatibility: false,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: new Color.fromRGBO(48, 71, 94, 1),
              statusBarIconBrightness: Brightness.light,
            ),  
            backgroundColor: new Color.fromRGBO(48, 71, 94, 1),      
      ),
      body: SingleChildScrollView(
        padding:const EdgeInsets.all(20.0),
        child: Card(
          child: Center(
            child:Form(
              key: _formkey,
              child: Column(
                children: <Widget>[
                  //Articulo
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: TextField(
                      controller: articuloController,
                      style: TextStyle(
                        fontWeight:FontWeight.bold,
                        fontFamily: "Lato",
                        fontSize:18.0),
                      decoration: InputDecoration(
                        icon: Icon(Icons.cake, color: new Color.fromRGBO(48, 71, 94, 1)),
                        labelText: 'Articulo'),
                        keyboardType: TextInputType.text,
                    ),
                  ),
                  Padding(padding:EdgeInsets.only(top:8.0)),
                  Divider(),
                  //Descripcion
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: TextField(
                      controller: descripcionController,
                      style: TextStyle(
                        fontWeight:FontWeight.bold,
                        fontFamily: "Lato",
                        fontSize:18.0),
                      decoration: InputDecoration(
                        icon: Icon(Icons.description, color: new Color.fromRGBO(48, 71, 94, 1),),
                        labelText: 'Descripcion'),
                        keyboardType: TextInputType.text,
                    ),
                  ),
                  Padding(padding:EdgeInsets.only(top:8.0)),
                  Divider(),
                  //Precio
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: TextFormField(
                      controller: precioController,
                      validator: (val) => val!.isNotEmpty ? null : 'Ingresa un precio',
                      style: TextStyle(
                        fontWeight:FontWeight.bold,
                        fontFamily: "Lato",
                        fontSize:18.0),
                      decoration: InputDecoration(
                        icon: Icon(Icons.monetization_on, color: new Color.fromRGBO(48, 71, 94, 1)),
                        labelText: 'Precio'),
                        keyboardType: TextInputType.text,
                    ),
                  ),
                  Padding(padding:EdgeInsets.only(top:8.0)),
                  Divider(),
                  //Fecha
                  Container(
                    child: Row(
                      children: [
                        Container(
                          //padding: EdgeInsets.only(left: 10, right: 10),
                          child: IconButton(
                            icon: Icon(Icons.date_range_outlined),
                            color: new Color.fromRGBO(48, 71, 94, 1),
                            onPressed: _datePresent,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            children: <Widget>[
                              // ignore: unnecessary_null_comparison
                              Text( fechaController.length < 3 ? 
                              "No se ha seleccionado una fecha" : fechaController,
                                  style: TextStyle(
                                  fontWeight:FontWeight.bold,
                                  fontFamily: "Lato",
                                  fontSize:16.0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(padding:EdgeInsets.only(top:8.0)),
                  Divider(),
                  //DropDown Status
                  Container(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton<String>(
                              // fotoController.length < 10 ? Container() : new Image.file(new File(fotoController)),
                              value: statusController.isNotEmpty ? ( cambiarEstado ? (statusActuall == "Activo" ? "Inactivo" : "Activo") : statusController) : statusElegido,
                              // value: statusController.isNotEmpty ? statusController : statusElegido,
                              //value: statusElegido,
                              iconSize: 30,
                              //icon: (null),
                              style: TextStyle(
                                color: new Color.fromRGBO(48, 71, 94, 1),
                                fontSize: 16,
                                fontWeight:FontWeight.bold,
                                fontFamily: "Lato",
                              ),
                              hint: Text('Seleccionar el estatus del producto'),
                              onChanged: (newValue){
                                setState(() {
                                  statusController = newValue!;
                                  print(statusElegido);
                                });
                              },
                              items: _status.map((valueItem) {
                                return DropdownMenuItem(
                                  value: valueItem.toString(),
                                  child: Text(valueItem.toString()),
                                );
                              }
                              ).toList(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                  // Center(
                  //   child: DropdownButton(
                  //     value: statusElegido,
                  //     onChanged: (newValue){
                  //       setState(() {
                  //         statusElegido = newValue as String?;
                  //         print(statusElegido);
                  //       });
                  //     },
                  //     items: _status.map((valueItem){
                  //       return DropdownMenuItem(
                  //         value: valueItem,
                  //         child: Text(valueItem),
                  //       );
                  //     }).toList(),
                  //   ),
                  // ),
                  Padding(padding:EdgeInsets.only(top:8.0)),
                  Divider(),
                  //Contacto
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: TextField(
                      controller: contactoController,
                      style: TextStyle(
                        fontWeight:FontWeight.bold,
                        fontFamily: "Lato",
                        fontSize:18.0),
                      decoration: InputDecoration(
                        icon: Icon(Icons.phone, color: new Color.fromRGBO(48, 71, 94, 1)),
                        labelText: 'Contacto'),
                        keyboardType: TextInputType.number,
                    ),
                  ),
                  Padding(padding:EdgeInsets.only(top:8.0)),
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
                                ? LatLng(latitudeController, longitudeController)
                                : LatLng( widget.lat, widget.lng),
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
                                      ? LatLng(latitudeController, longitudeController)
                                      : LatLng( widget.lat, widget.lng),
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
                              latitudeController = value.latitude!;
                              print(widget.lng);
                              longitudeController = value.longitude!;
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
                  Padding(padding:EdgeInsets.only(top:8.0)),
                  Divider(),
                  //Latitud
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: TextFormField(
                      readOnly: true,
                      style: TextStyle(
                        fontWeight:FontWeight.bold,
                        fontFamily: "Lato",
                        fontSize:18.0),
                      decoration: InputDecoration(
                        icon: Icon(Icons.map_sharp, color: new Color.fromRGBO(48, 71, 94, 1)),
                        labelText: latitudeController != 0 ? latitudeController.toString() : 'Latitude'),
                        keyboardType: TextInputType.text,
                      
                    ),
                  ),
                  Padding(padding:EdgeInsets.only(top:8.0)),
                  Divider(),
                  //Longitude
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: TextFormField(
                      readOnly: true,
                      style: TextStyle(
                        fontWeight:FontWeight.bold,
                        fontFamily: "Lato",
                        fontSize:18.0),
                      decoration: InputDecoration(
                        icon: Icon(Icons.map_sharp, color: new Color.fromRGBO(48, 71, 94, 1)),
                        labelText: latitudeController != 0 ? longitudeController.toString() : 'Longitude'),
                        keyboardType: TextInputType.text,
                      
                    ),
                  ),
                  Padding(padding:EdgeInsets.only(top:8.0)),
                  Divider(),
                  fotoController.length < 10 ? Container() : new Image.file(new File(fotoController)),
                  Padding(padding:EdgeInsets.only(top:8.0)),
                  Divider(),
                  ButtonWidget(
                    text: 'Tomar Foto',
                    icon: Icons.camera_alt,
                    // onClicked: selectFile,
                    onClicked: getImage,
                  ),
                  SizedBox(height: 20),
                  task != null ? buildUploadStatus(task!) : Container(),
                  SizedBox(height: 8),
                  Container(
                    padding:EdgeInsets.only(left: 15, top:10, right: 15, bottom: 10),
                    child: Text(
                      fileName,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, fontFamily: "Lato",),
                    ),
                  ),
                  Padding(padding:EdgeInsets.only(top:8.0)),
                  Divider(),
                  TextButton(
                    onPressed: (){
                      //print(activar);
                          if(widget.pastel.id!=null){
                          pastelRF.child(widget.pastel.id.toString()).set({
                            'articulo':articuloController.text,
                            'descripcion':descripcionController.text,
                            'fecha':fechaController,
                            'status': ( cambiarEstado ? (statusActuall == "Activo" ? "Inactivo" : "Activo") : statusController),
                            'precio':precioController.text,
                            'contacto':contactoController.text,
                            'latitude': latitudeController,
                            'longitude': longitudeController,
                            'foto': fotoController,
                          }).then((_)=>{Navigator.pop(context)});
                        }else{
                          pastelRF.push().set({
                            'articulo':articuloController.text,
                            'descripcion':descripcionController.text,
                            'fecha':fechaController,
                            'status': ( cambiarEstado ? (statusActuall == "Activo" ? "Inactivo" : "Activo") : statusController),
                            'precio':precioController.text,
                            'contacto':contactoController.text,
                            'latitude': latitudeController,
                            'longitude': longitudeController,
                            'foto': fotoController,
                          }).then((_)=>{Navigator.pop(context)});
                        }
                        uploadFile();
                    },
                    child: (widget.pastel.id!=null)?Text('Actualizar'):Text('Añadir'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  //******************************* Subir Imagenes *******************************
  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path;
    print("Holaaaaaeeee");
    print(path.toString());
    fotoController = path.toString();

    setState(() => file = File(path!));
  }

  Future getImage() async{
    //var tempImage= await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    print("Imagennnnnnnnn");
    //final path = image.path.
    //print(image!.path.toString());
    fotoController = image!.path.toString();
    // setState((){
    //   sampleImage= new File(image.path);
    // });
    setState(() => file = File(image.path));
  }

  Future uploadFile() async {
    if (file == null) return;

    final fileName = basename(file!.path);
    final destination = 'pasteles/$fileName';

    task = FirebaseApi.uploadFile(destination, file!);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print(urlDownload);

    print('Download-Link: $urlDownload');
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);

            return Text(
              '$percentage %',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: "Lato",),
            );
          } else {
            return Container();
          }
        },
      );
}


