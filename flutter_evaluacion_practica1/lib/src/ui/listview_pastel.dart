import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:flutter_evaluacion_practica1/services/auth_services.dart';
import 'package:flutter_evaluacion_practica1/src/model/pastel.dart';
import 'package:flutter_evaluacion_practica1/src/ui/information_pastel.dart';
import 'package:flutter_evaluacion_practica1/src/ui/screen_pastel.dart';
import 'dart:async';

import 'package:provider/provider.dart';

class ListViewPastel extends StatefulWidget{
  ListViewPastel({Key? key}) : super(key: key);
  _ListViewPastelState createState()=>_ListViewPastelState();
}
final pastelRF = FirebaseDatabase.instance.reference().child('pastel');

class _ListViewPastelState extends State<ListViewPastel>{
  late List<Pastel> items;

  late StreamSubscription<Event> addPastel;
  late StreamSubscription<Event> changePastel;

  @override
  void initState(){
    super.initState();
    items = [];
    addPastel = pastelRF.onChildAdded.listen(_addPastel);
    changePastel = pastelRF.onChildChanged.listen(_updatePastel);
  }
@override
void dispose(){
  super.dispose();
  addPastel.cancel();
  changePastel.cancel();
}
 @override
  Widget build(BuildContext context){
    final loginProvider = Provider.of<AuthServices>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Productos',
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.blueAccent[100]),
        title: Text("Productos"),
        backgroundColor: new Color.fromRGBO(48, 71, 94, 1),
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
                          '${items[position].articulo}',
                          style: TextStyle(color: Colors.greenAccent[400], fontSize: 21.0),
                        ),
                        subtitle: Text(
                          '${items[position].precio}',
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
                          onTap: () => _infoPastel(context, items[position]),
                        ),
                      ),
                    
                    IconButton(
                      icon: Icon(Icons.delete_outlined,
                      color: Colors.purple[200]),
                      onPressed:  () => _borrarPastel(context, items[position], position),
                    ),

                    IconButton(
                      icon: Icon(Icons.remove_red_eye_outlined,
                      color: Colors.purple[200]),
                      onPressed:  () => _verPastel(context, items[position]),
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
          backgroundColor: new Color.fromRGBO(80, 137, 198, 1),
          onPressed: () => agregarPastel(context),),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      ),
    );
  }

  void _addPastel(Event event){
    setState(() {
      items.add(new Pastel.fromSnapshot(event.snapshot));
    });
  }

  void _updatePastel(Event event){
    var oldPastel = items.singleWhere((pastel) => pastel.id == event.snapshot.key);
    setState(() {
      items[items.indexOf(oldPastel)] =new Pastel.fromSnapshot(event.snapshot);
    });
  }

  void _infoPastel(BuildContext context, Pastel pastel) async{
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScreenPastel(pastel),)
    );
  }

  void _borrarPastel(BuildContext context, Pastel pastel, int position) async{
    await pastelRF.child(pastel.id.toString()).remove().then((_){
      setState(() {
        items.remove(position);
        setState(() {items.removeAt(position);});
        //Navigator.of(context).pop();
      });
    });
  }

  void _verPastel(BuildContext context, Pastel pastel) async{
    await Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => InfoPastel(pastel),)
    );
  }

  void agregarPastel (BuildContext context) async{
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScreenPastel(Pastel(null,'','','','','','','','')),)
    );
  }
}