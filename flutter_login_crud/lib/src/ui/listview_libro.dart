import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_login_crud/services/authentication_services/auth_services.dart';
import 'package:flutter_login_crud/src/model/libro.dart';
import 'package:flutter_login_crud/src/ui/information_libro.dart';
import 'package:flutter_login_crud/src/ui/screen_libro.dart';
import 'dart:async';

import 'package:provider/provider.dart';

class ListViewLibro extends StatefulWidget{
  ListViewLibro({Key? key}) : super(key: key);
  _ListViewLibroState createState()=>_ListViewLibroState();
}
final libroRF = FirebaseDatabase.instance.reference().child('libro');

class _ListViewLibroState extends State<ListViewLibro>{
  late List<Libro> items;

  late StreamSubscription<Event> addLibro;
  late StreamSubscription<Event> changeLibro;

  @override
  void initState(){
    super.initState();
    items = [];
    addLibro = libroRF.onChildAdded.listen(_addLibro);
    changeLibro = libroRF.onChildChanged.listen(_updateLibro);
  }
@override
void dispose(){
  super.dispose();
  addLibro.cancel();
  changeLibro.cancel();
}
 @override
  Widget build(BuildContext context){
    final loginProvider = Provider.of<AuthServices>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Libros',
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
        title: Text("Libros"),
        backgroundColor: Colors.deepPurpleAccent[100],
        actions: [
          IconButton(
            onPressed: ()async => await loginProvider.logout(),
            icon: Icon(Icons.exit_to_app)),
        ],
      ),
      body: Center(
        child: ListView.builder(
          itemCount: items.length,
          padding: EdgeInsets.only(top: 12.0),
          itemBuilder: (context, position){
            return Column(
              children: <Widget>[
                Divider(height: 7.0,),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ListTile(
                        title: Text(
                          '${items[position].nombre}',
                          style: TextStyle(color: Colors.greenAccent[400], fontSize: 21.0),
                        ),
                        subtitle: Text(
                          '${items[position].autor}',
                          style: TextStyle(color: Colors.blueAccent[400], fontSize: 21.0),
                        ),
                        leading: Column(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.deepPurpleAccent[200],
                              radius: 17.0,
                              child: Text(
                                '${position+1}',
                                style: TextStyle(color: Colors.white, fontSize: 21.0),
                                ),
                              ),
                            ],
                          ),
                          onTap: () => _infoLibro(context, items[position]),
                        ),
                      ),
                    
                    IconButton(
                      icon: Icon(Icons.delete_outlined,
                      color: Colors.purple[200]),
                      onPressed:  () => _borrarLibro(context, items[position], position),
                    ),

                    IconButton(
                      icon: Icon(Icons.remove_red_eye_outlined,
                      color: Colors.purple[200]),
                      onPressed:  () => _verLibro(context, items[position]),
                    ),

                  ],
                )
              ],
            );
          }
        ),
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,),
          backgroundColor: Colors.blueAccent[200],
          onPressed: () => agregarLibro(context),),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      ),
    );
  }

  void _addLibro(Event event){
    setState(() {
      items.add(new Libro.fromSnapshot(event.snapshot));
    });
  }

  void _updateLibro(Event event){
    var oldLibro = items.singleWhere((libro) => libro.id == event.snapshot.key);
    setState(() {
      items[items.indexOf(oldLibro)] =new Libro.fromSnapshot(event.snapshot);
    });
  }

  void _infoLibro(BuildContext context, Libro libro) async{
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScreenLibro(libro),)
    );
  }

  void _borrarLibro(BuildContext context, Libro libro, int position) async{
    await libroRF.child(libro.id.toString()).remove().then((_){
      setState(() {
        items.remove(position);
        setState(() {items.removeAt(position);});
        //Navigator.of(context).pop();
      });
    });
  }

  void _verLibro(BuildContext context, Libro libro) async{
    await Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => InfoLibro(libro),)
    );
  }

  void agregarLibro (BuildContext context) async{
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScreenLibro(Libro(null,'','','','','','')),)
    );
  }
}