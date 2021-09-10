import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_agenda/src/model/people.dart';
import 'package:flutter_agenda/src/ui/information_people.dart';
import 'package:flutter_agenda/src/ui/screen_people.dart';
import 'dart:async';

class ListViewPerson extends StatefulWidget{
  ListViewPerson({Key? key}) : super(key: key);
  _ListViewPersonState createState()=>_ListViewPersonState();
}
final personaRF = FirebaseDatabase.instance.reference().child('persona');

class _ListViewPersonState extends State<ListViewPerson>{
  late List<Persona> items;

  late StreamSubscription<Event> addPersonas;
  late StreamSubscription<Event> changePersonas;

  @override
  void initState(){
    super.initState();
    items = [];
    addPersonas = personaRF.onChildAdded.listen(_addPersona);
    changePersonas = personaRF.onChildChanged.listen(_updatePersona);
  }
@override
void dispose(){
  super.dispose();
  addPersonas.cancel();
  changePersonas.cancel();
}
 @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agenda',
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
        title: Text("Personas"),
        backgroundColor: Colors.deepPurpleAccent[100],
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
                          '${items[position].apellido}',
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
                          onTap: () => _infoPersona(context, items[position]),
                        ),
                      ),
                    
                    IconButton(
                      icon: Icon(Icons.delete_outlined,
                      color: Colors.purple[200]),
                      onPressed:  () => _borrarPersona(context, items[position], position),
                    ),

                    IconButton(
                      icon: Icon(Icons.remove_red_eye_outlined,
                      color: Colors.purple[200]),
                      onPressed:  () => _verPersona(context, items[position]),
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
          onPressed: () => agregarPersona(context),),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      ),
    );
  }

  void _addPersona(Event event){
    setState(() {
      items.add(new Persona.fromSnapshot(event.snapshot));
    });
  }

  void _updatePersona(Event event){
    var oldPersona = items.singleWhere((persona) => persona.id == event.snapshot.key);
    setState(() {
      items[items.indexOf(oldPersona)] =new Persona.fromSnapshot(event.snapshot);
    });
  }

  void _infoPersona(BuildContext context, Persona persona) async{
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScreenPersona(persona),)
    );
  }

  void _borrarPersona(BuildContext context, Persona persona, int position) async{
    await personaRF.child(persona.id.toString()).remove().then((_){
      setState(() {
        items.remove(position);
        setState(() {items.removeAt(position);});
        //Navigator.of(context).pop();
      });
    });
  }

  void _verPersona(BuildContext context, Persona persona) async{
    await Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => InfoPersona(persona),)
    );
  }

  void agregarPersona (BuildContext context) async{
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScreenPersona(Persona(null,'','','','','','')),)
    );
  }
}