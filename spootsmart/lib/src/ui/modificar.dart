import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spootsmart/src/model/habitacion.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:spootsmart/src/ui/activos.dart';

class Modificar extends StatefulWidget {
  final Habitacion habitacion;
  Modificar(this.habitacion);

  @override
  _Modificar createState() => _Modificar();
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

class _Modificar extends State<Modificar> {
  late TextEditingController idController;
  late TextEditingController nombreController;
  late TextEditingController fechaController;
  late TextEditingController latitudController;
  late TextEditingController longitudController;
  late TextEditingController statusController;
  late TextEditingController imagenController;
  DateTime selectedDate = DateTime.now();
  late List<Habitacion> items;
  String? fecha;
  String? fileFoto;
  File? _foto;

  @override
  void initState() {
    idController = new TextEditingController(text: widget.habitacion.id);
    nombreController = new TextEditingController(text: '');
    fechaController = new TextEditingController(text: '');
    latitudController = new TextEditingController(text: '');
    longitudController = new TextEditingController(text: '');
    statusController = new TextEditingController(text: '');
    imagenController = new TextEditingController(text: '');
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
          title: Text('Modificación Producto'),
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
                  padding: EdgeInsets.only(left: 10, right: 10),

                  //TextField en donde ingresaremos el id del usuario
                  child: TextField(
                    controller: idController,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
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
                // ignore: deprecated_member_use
                RaisedButton(
                  onPressed: () => {_buscarProducto(idController.text)},
                  child: Text(
                    'Buscar',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  color: Colors.blue,
                ),
                Padding(padding: EdgeInsets.only(top: 8.0)),
                Divider(),

                //Fecha
                TextField(
                  enabled: false,
                  controller: fechaController,
                  onChanged: (text) => selectedDate.toLocal(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
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
                RaisedButton(
                  onPressed: () => _selectDate(context), // Refer step 3
                  child: Text(
                    'Selecciona Fecha',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  color: Colors.blue,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                ),
                Divider(),

                //Status
                TextField(
                  enabled: false,
                  controller: statusController,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
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
                        fontWeight: FontWeight.w500),
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
                TextField(
                  enabled: false,
                  controller: latitudController,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                  decoration: InputDecoration(
                    icon: Icon(Icons.description),
                    labelText: 'Latitud',
                  ),
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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                  decoration: InputDecoration(
                    icon: Icon(Icons.payment),
                    labelText: 'Longitud',
                  ),
                  autocorrect: true,
                  keyboardType: TextInputType.number,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                ),
                Divider(),

                //Imagen
                TextField(
                  enabled: false,
                  controller: imagenController,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                  decoration: InputDecoration(
                    icon: Icon(Icons.payment),
                    labelText: 'Imagen',
                  ),
                  autocorrect: true,
                  keyboardType: TextInputType.number,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                ),
                Divider(),

                //Imagen
                // ignore: deprecated_member_use
                FlatButton(
                  onPressed: getImage, // Refer step 3
                  child: Text(
                    'Toma una Foto',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  color: Colors.blue,
                ),
                Center(
                  // ignore: unnecessary_null_comparison
                  child: imagenController.text == null
                      ? Text('No image selected.')
                      : Image.network(
                          imagenController.text,
                          height: 200,
                          width: double.infinity,
                        ),
                ),

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
                            'imagen': imagenController.text,
                            'latitud': '',
                            'longitud': '',
                            'status': _chosenValue,
                          }).then((_) => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ListViewProduct()))
                              });
                        } else if (statusController.text == 'Inactiva') {
                          //Insertar en activo
                          print(idController.text);
                          productoRefActivo.child(idController.text).set({
                            'fecha': fechaController.text,
                            'imagen': imagenController.text,
                            'latitud': '',
                            'longitud': '',
                            'status': _chosenValue,
                          }).then((_) => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ListViewProduct()))
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
                                                ListViewProduct()));
                                  }));
                        }
                      } else if (_chosenValue == 'Inactiva') {
                        if (statusController.text == 'Inactiva') {
                          print(statusController);
                          productoRefInactivo.child(idController.text).set({
                            'fecha': fechaController.text,
                            'imagen': imagenController.text,
                            'latitud': '',
                            'longitud': '',
                            'status': _chosenValue,
                          }).then((_) => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ListViewProduct()))
                              });
                        } else if (statusController.text == 'Activa') {
                          //Insertar en Inactivo
                          print(statusController);
                          productoRefInactivo.child(idController.text).set({
                            'fecha': fechaController.text,
                            'imagen': imagenController.text,
                            'latitud': '',
                            'longitud': '',
                            'status': _chosenValue,
                          }).then((_) => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ListViewProduct()))
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
                                                ListViewProduct()));
                                  }));
                        }
                      }
                    }
                  },
                  child: Text('Actualizar'),
                  color: Colors.blue,
                )
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
                          latitudController.text = val[1],
                          longitudController.text = val[2],
                          imagenController.text = val[3],
                          statusController.text = val[4],
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
                                    latitudController.text = val[1],
                                    longitudController.text = val[2],
                                    imagenController.text = val[3],
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
                                      new Text("No se encontro el producto"),
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
        imagenController.text = fileFoto!;
        print(_foto);
      });
    }
  }
}
