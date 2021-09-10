import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_evaluacion_practica1/src/model/pastel.dart';

class InfoPastel extends StatefulWidget{
  final Pastel pastel;
  InfoPastel(this.pastel);
  @override
  _InfoPastelState createState() => _InfoPastelState();
}
final pastelRF = FirebaseDatabase.instance.reference().child('pastel');

class _InfoPastelState extends State<InfoPastel>{
  late List<Pastel> items;
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
                  "Nombre del Articulo: ${widget.pastel.articulo}",
                  style: TextStyle(fontWeight:FontWeight.bold, fontSize:18.0),
                ),
                Padding(padding:EdgeInsets.only(top:8.0)),
                Divider(),
                new Text(
                  "Autor: ${widget.pastel.ingredientes}",
                  style: TextStyle(fontWeight:FontWeight.bold, fontSize:18.0),
                ),
                Padding(padding:EdgeInsets.only(top:8.0)),
                Divider(),
                new Text(
                  "Género: ${widget.pastel.creador}",
                  style: TextStyle(fontWeight:FontWeight.bold, fontSize:18.0),
                ),
                Padding(padding:EdgeInsets.only(top:8.0)),
                Divider(),
                new Text(
                  "Editorial: ${widget.pastel.fecha}",
                  style: TextStyle(fontWeight:FontWeight.bold, fontSize:18.0),
                ),
                Padding(padding:EdgeInsets.only(top:8.0)),
                Divider(),
                new Text(
                  "Número de páginas: ${widget.pastel.precio}",
                  style: TextStyle(fontWeight:FontWeight.bold, fontSize:18.0),
                ),
                Padding(padding:EdgeInsets.only(top:8.0)),
                Divider(),
                // new Image.network("https://firebasestorage.googleapis.com/v0/b/flutterlogincrud.appspot.com/o/files%2FIMG-20210907-WA0001.jpg?alt=media&token=e58e7bc5-0080-4c00-9b7c-b4801ddb3815"),
                // new Image.asset(widget.pastel.photo),
                new Image.file(new File("${widget.pastel.foto}")),
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