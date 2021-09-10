import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_evaluacion_practica1/screens/uploadButton/button_widget.dart';
import 'package:flutter_evaluacion_practica1/services/firebase_api.dart';
import 'package:flutter_evaluacion_practica1/src/model/pastel.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';

class ScreenPastel extends StatefulWidget{
  final Pastel pastel;
  ScreenPastel(this.pastel);

  @override
  _ScreenPastelState createState() => _ScreenPastelState();
}

final pastelRF = FirebaseDatabase.instance.reference().child('pastel');

class _ScreenPastelState extends State<ScreenPastel>{
  late List<Pastel> items;

  late TextEditingController articuloController;
  late TextEditingController ingredientesController;
  late TextEditingController creadorController;
  late TextEditingController fechaController;
  late TextEditingController precioController;
  late String fotoController = "";
  DateTime?  _dateTime;
  final _formkey = GlobalKey<FormState>();
  UploadTask? task;
  File? file;

  @override
  void initState(){
    articuloController = new TextEditingController(text:widget.pastel.articulo);
    ingredientesController = new TextEditingController(text:widget.pastel.ingredientes);
    creadorController = new TextEditingController(text:widget.pastel.creador);
    fechaController = new TextEditingController(text:widget.pastel.fecha);
    precioController = new TextEditingController(text:widget.pastel.precio);
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
          });
        }
      }
    );
}

    return Scaffold(
      resizeToAvoidBottomInset:true,
      appBar: AppBar(
        title: Text("Articulos"),
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
                        fontSize:18.0),
                      decoration: InputDecoration(
                        icon: Icon(Icons.cake, color: new Color.fromRGBO(48, 71, 94, 1)),
                        labelText: 'Articulo'),
                        keyboardType: TextInputType.text,
                    ),
                  ),
                  Padding(padding:EdgeInsets.only(top:8.0)),
                  Divider(),
                  //Ingredientes
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: TextField(
                      controller: ingredientesController,
                      style: TextStyle(
                        fontWeight:FontWeight.bold,
                        fontSize:18.0),
                      decoration: InputDecoration(
                        icon: Icon(Icons.tonality_sharp, color: new Color.fromRGBO(48, 71, 94, 1)),
                        labelText: 'Ingredientes'),
                        keyboardType: TextInputType.text,
                    ),
                  ),
                  Padding(padding:EdgeInsets.only(top:8.0)),
                  Divider(),
                  //Creador
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: TextField(
                      controller: creadorController,
                      style: TextStyle(
                        fontWeight:FontWeight.bold,
                        fontSize:18.0),
                      decoration: InputDecoration(
                        icon: Icon(Icons.person, color: new Color.fromRGBO(48, 71, 94, 1),),
                        labelText: 'Creador(a)'),
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
                              Text( _dateTime == null ? 
                              "No se ha seleccionado una fecha" : DateFormat.yMEd().format(_dateTime!),
                                  style: TextStyle(
                                  fontWeight:FontWeight.bold,
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
                  //Precio
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: TextFormField(
                      controller: precioController,
                      validator: (val) => val!.isNotEmpty ? null : 'Ingresa un precio',
                      style: TextStyle(
                        fontWeight:FontWeight.bold,
                        fontSize:18.0),
                      decoration: InputDecoration(
                        icon: Icon(Icons.monetization_on, color: new Color.fromRGBO(48, 71, 94, 1)),
                        labelText: 'Precio'),
                        keyboardType: TextInputType.text,
                    ),
                  ),
                  Padding(padding:EdgeInsets.only(top:8.0)),
                  Divider(),
                  //Foto
                  fotoController.length < 10 ? Container() : new Image.file(new File(fotoController)),
                  Padding(padding:EdgeInsets.only(top:8.0)),
                  Divider(),
                  
                  ButtonWidget(
                    text: 'Seleccionar Foto',
                    icon: Icons.photo,
                    onClicked: selectFile,
                  ),
                  SizedBox(height: 20),
                  task != null ? buildUploadStatus(task!) : Container(),
                  SizedBox(height: 8),
                  Text(
                    fileName,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Padding(padding:EdgeInsets.only(top:8.0)),
                  Divider(),
                  TextButton(
                    onPressed: (){
                          if(widget.pastel.id!=null){
                          pastelRF.child(widget.pastel.id.toString()).set({
                            'articulo':articuloController.text,
                            'ingredientes':ingredientesController.text,
                            'creador':creadorController.text,
                            'fecha':fechaController.text,
                            'precio':precioController.text,
                            'foto': fotoController,
                          }).then((_)=>{Navigator.pop(context)});
                        }else{
                          pastelRF.push().set({
                            'articulo':articuloController.text,
                            'ingredientes':ingredientesController.text,
                            'creador':creadorController.text,
                            'fecha':fechaController.text,
                            'precio':precioController.text,
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
  //******************************* Obtener Imagenes *******************************
  // Future getImage() async {
  //   var tempImage = await FilePicker.pickImage(source: ImageSource.gallery);

  //   setState(() {
  //     sampleImage = tempImage;
  //    });
  // }
  //******************************* Subir Imagenes *******************************
  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path;
    print("Holaaaaa");
    print(path);
    fotoController = path.toString();

    setState(() => file = File(path!));
  }

  Future uploadFile() async {
    if (file == null) return;

    final fileName = basename(file!.path);
    final destination = 'files/$fileName';

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
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            );
          } else {
            return Container();
          }
        },
      );

}


