import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_login_crud/screens/uploadButton/button_widget.dart';
import 'package:flutter_login_crud/services/api/firebase_api.dart';
import 'package:flutter_login_crud/src/model/libro.dart';
import 'package:path/path.dart';

class ScreenLibro extends StatefulWidget{
  final Libro libro;
  ScreenLibro(this.libro);

  @override
  _ScreenLibroState createState() => _ScreenLibroState();
}

final libroRF = FirebaseDatabase.instance.reference().child('libro');

class _ScreenLibroState extends State<ScreenLibro>{
  late List<Libro> items;

  late TextEditingController nombreController;
  late TextEditingController autorController;
  late TextEditingController generoController;
  late TextEditingController editorialController;
  late TextEditingController paginasController;
  late String fotoController = "";
  UploadTask? task;
  File? file;

  @override
  void initState(){
    super.initState();
    nombreController = new TextEditingController(text:widget.libro.nombre);
    autorController = new TextEditingController(text:widget.libro.autor);
    generoController = new TextEditingController(text:widget.libro.genero);
    editorialController = new TextEditingController(text:widget.libro.editorial);
    paginasController = new TextEditingController(text:widget.libro.paginas);
    fotoController = (widget.libro.foto);
  }

  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file!.path) : 'No se ha seleccionado una foto';
    
    return Scaffold(
      resizeToAvoidBottomInset:true,
      appBar: AppBar(
        title: Text("Libros"),
        backgroundColor: Colors.deepPurpleAccent[100],
      ),
      body: SingleChildScrollView(
        padding:const EdgeInsets.all(20.0),
        child: Card(
          child: Center(
            child:Column(
              children: <Widget>[
                //Nombre
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: TextField(
                    controller: nombreController,
                    style: TextStyle(
                      fontWeight:FontWeight.bold,
                      fontSize:18.0),
                    decoration: InputDecoration(
                      icon: Icon(Icons.crop_square),
                      labelText: 'Nombre'),
                      keyboardType: TextInputType.text,
                  ),
                ),
                Padding(padding:EdgeInsets.only(top:8.0)),
                Divider(),
                //Autor
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: TextField(
                    controller: autorController,
                    style: TextStyle(
                      fontWeight:FontWeight.bold,
                      fontSize:18.0),
                    decoration: InputDecoration(
                      icon: Icon(Icons.tonality_sharp),
                      labelText: 'Autor'),
                      keyboardType: TextInputType.text,
                  ),
                ),
                Padding(padding:EdgeInsets.only(top:8.0)),
                Divider(),
                //Genero
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: TextField(
                    controller: generoController,
                    style: TextStyle(
                      fontWeight:FontWeight.bold,
                      fontSize:18.0),
                    decoration: InputDecoration(
                      icon: Icon(Icons.color_lens),
                      labelText: 'Género'),
                      keyboardType: TextInputType.text,
                  ),
                ),
                Padding(padding:EdgeInsets.only(top:8.0)),
                Divider(),
                //Editorial
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: TextField(
                    controller: editorialController,
                    style: TextStyle(
                      fontWeight:FontWeight.bold,
                      fontSize:18.0),
                    decoration: InputDecoration(
                      icon: Icon(Icons.confirmation_number),
                      labelText: 'Editorial'),
                      keyboardType: TextInputType.text,
                  ),
                ),
                Padding(padding:EdgeInsets.only(top:8.0)),
                Divider(),
                //Paginas
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: TextField(
                    controller: paginasController,
                    style: TextStyle(
                      fontWeight:FontWeight.bold,
                      fontSize:18.0),
                    decoration: InputDecoration(
                      icon: Icon(Icons.format_list_numbered),
                      labelText: 'Número de Paginas'),
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
                        if(widget.libro.id!=null){
                        libroRF.child(widget.libro.id.toString()).set({
                          'nombre':nombreController.text,
                          'autor':autorController.text,
                          'genero':generoController.text,
                          'editorial':editorialController.text,
                          'paginas':paginasController.text,
                          'foto': fotoController,
                        }).then((_)=>{Navigator.pop(context)});
                      }else{
                        libroRF.push().set({
                          'nombre':nombreController.text,
                          'autor':autorController.text,
                          'genero':generoController.text,
                          'editorial':editorialController.text,
                          'paginas':paginasController.text,
                          'foto': fotoController,
                        }).then((_)=>{Navigator.pop(context)});
                      }
                      uploadFile();
                  },
                  child: (widget.libro.id!=null)?Text('Actualizar'):Text('Añadir'),
                ),
              ],
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


