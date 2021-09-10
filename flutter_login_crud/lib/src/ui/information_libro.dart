import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_login_crud/src/model/libro.dart';

class InfoLibro extends StatefulWidget{
  final Libro libro;
  InfoLibro(this.libro);
  @override
  _InfoLibroState createState() => _InfoLibroState();
}
final libroRF = FirebaseDatabase.instance.reference().child('libro');

class _InfoLibroState extends State<InfoLibro>{
  late List<Libro> items;
  @override
  void initState(){
    super.initState();
  }

@override
Widget build(BuildContext context){
  return Scaffold(
    resizeToAvoidBottomInset: true,
    appBar: AppBar(
      title:Text("Información"),
      backgroundColor: Colors.deepPurpleAccent[100],
    ),
    body:Container(
      height: 800.0,
      padding: const EdgeInsets.all(20.0),
      child: Card(
        child:Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                new Text(
                  "Nombre del Libro: ${widget.libro.nombre}",
                  style: TextStyle(fontWeight:FontWeight.bold, fontSize:18.0),
                ),
                Padding(padding:EdgeInsets.only(top:8.0)),
                Divider(),
                new Text(
                  "Autor: ${widget.libro.autor}",
                  style: TextStyle(fontWeight:FontWeight.bold, fontSize:18.0),
                ),
                Padding(padding:EdgeInsets.only(top:8.0)),
                Divider(),
                new Text(
                  "Género: ${widget.libro.genero}",
                  style: TextStyle(fontWeight:FontWeight.bold, fontSize:18.0),
                ),
                Padding(padding:EdgeInsets.only(top:8.0)),
                Divider(),
                new Text(
                  "Editorial: ${widget.libro.editorial}",
                  style: TextStyle(fontWeight:FontWeight.bold, fontSize:18.0),
                ),
                Padding(padding:EdgeInsets.only(top:8.0)),
                Divider(),
                new Text(
                  "Número de páginas: ${widget.libro.paginas}",
                  style: TextStyle(fontWeight:FontWeight.bold, fontSize:18.0),
                ),
                Padding(padding:EdgeInsets.only(top:8.0)),
                Divider(),
                // new Image.network("https://firebasestorage.googleapis.com/v0/b/flutterlogincrud.appspot.com/o/files%2FIMG-20210907-WA0001.jpg?alt=media&token=e58e7bc5-0080-4c00-9b7c-b4801ddb3815"),
                // new Image.asset(widget.libro.photo),
                new Image.file(new File("${widget.libro.foto}")),
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