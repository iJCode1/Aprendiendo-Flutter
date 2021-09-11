import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:intl/intl.dart';
//import 'package:tareas/screens/home_screen.dart';

class PhotoUpload extends StatefulWidget{
  @override
  _PhotoUpload createState() => _PhotoUpload();
}

class _PhotoUpload extends State<PhotoUpload>{
  File? sampleImage;
  String _myValue="Descripción de la tarea";
  String? url;
  final formKey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: Text('Subir imagen'),
        centerTitle: true,
      ),
      body: Center(
        child: sampleImage == null ? Text("Seleccionar una imagen"):enableUpload(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
           getImage();
        },
        tooltip: "Agregar Imagen",
        child: Icon(Icons.add),
      ),
    );
  }

  Future getImage() async{
    //var tempImage= await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    setState((){
      sampleImage=new File(image!.path);
    });
  }

  Widget enableUpload(){
    return SingleChildScrollView(
      child: Container(
        child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              Image.file(
                sampleImage!,
                height: 150.0,
                width: 300.0,
              ),
              SizedBox(
                height: 15.0
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Descripción"),
                validator: (value){
                  if(value!.isEmpty){
                    return "Descripoción obligatoria!";
                  }
                },
                onSaved: (valor){
                  //_myValue=valor.toString();
                },
              ),
              SizedBox(
                height:15.0 ,
              ),
              ElevatedButton(
                child: Text("Agregar nueva tarea"),
                onPressed: subirImagen,
              )
            ],
          ),
        ),
        ),
      ),
    );
  }

  void subirImagen() async{
    if(validar()){
      Reference tareaImagenRef = 
      FirebaseStorage.instance.ref().child("Tareas Images");
      var timeKey = DateTime.now();
      final UploadTask uploadTask = 
        tareaImagenRef.child(timeKey.toString()+".jpg").putFile(sampleImage!);
      var imagenUrl = await (await uploadTask).ref.getDownloadURL();
      url= imagenUrl.toString();
      print ("URL de la imagen:  "+url!);
      saveToDatabase(url!);

      Navigator.pushNamed(context, '/');
      /*Navigator.pop(context);
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context){
          return HomeScreen();
        }
      ));*/
    }
  }

  void saveToDatabase(String url){
    var bdTimeKey =DateTime.now();
    var formatDate = DateFormat('MMM d, yyyy');
    var formatTime = DateFormat('EEEE, hh: mm aaa');

    String date = formatDate.format(bdTimeKey);
    String time = formatTime.format(bdTimeKey);
    
    DatabaseReference ref = FirebaseDatabase.instance.reference();

    var data ={
      "imagen": url,
      "descripcion": _myValue,
      "fecha": date,
      "hora": time
    };

    ref.child("Tareas").push().set(data);
  }

  bool validar(){
    final form = formKey.currentState;
    if(form!.validate()){
      return true;
    }
    else{
      return false;
    }
  }
}