import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_agenda/src/model/people.dart';

class ScreenPersona extends StatefulWidget{
  final Persona persona;
  ScreenPersona(this.persona);

  @override
  _ScreenPersonaState createState() => _ScreenPersonaState();
}

final personaRF = FirebaseDatabase.instance.reference().child('persona');

class _ScreenPersonaState extends State<ScreenPersona>{
  late List<Persona> items;

  late TextEditingController nombreController;
  late TextEditingController apellidoController;
  late TextEditingController edadController;
  late TextEditingController telController;
  late TextEditingController dirController;
  late TextEditingController mailController;

  @override
  void initState(){
    super.initState();
    nombreController = new TextEditingController(text:widget.persona.nombre);
    apellidoController = new TextEditingController(text:widget.persona.apellido);
    edadController = new TextEditingController(text:widget.persona.edad);
    telController = new TextEditingController(text:widget.persona.tel);
    dirController = new TextEditingController(text:widget.persona.dir);
    mailController = new TextEditingController(text:widget.persona.mail);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:true,
      appBar: AppBar(
        title: Text("Personas"),
        backgroundColor: Colors.deepPurpleAccent[100],
      ),
      body: SingleChildScrollView(
        padding:const EdgeInsets.all(20.0),
        child: Card(
          child: Center(
            child:Column(
              children: <Widget>[
                //Nombre
                TextField(
                  controller: nombreController,
                  style: TextStyle(
                    fontWeight:FontWeight.bold,
                    fontSize:18.0),
                  decoration: InputDecoration(
                    icon: Icon(Icons.person),
                    labelText: 'Nombre'),
                    keyboardType: TextInputType.text,
                ),
                Padding(padding:EdgeInsets.only(top:8.0)),
                Divider(),
                //Apellido
                TextField(
                  controller: apellidoController,
                  style: TextStyle(
                    fontWeight:FontWeight.bold,
                    fontSize:18.0),
                  decoration: InputDecoration(
                    icon: Icon(Icons.people),
                    labelText: 'Apellido'),
                    keyboardType: TextInputType.text,
                ),
                Padding(padding:EdgeInsets.only(top:8.0)),
                Divider(),
                //Edad
                TextField(
                  controller: edadController,
                  style: TextStyle(
                    fontWeight:FontWeight.bold,
                    fontSize:18.0),
                  decoration: InputDecoration(
                    icon: Icon(Icons.date_range),
                    labelText: 'Edad'),
                    keyboardType: TextInputType.number,
                ),
                Padding(padding:EdgeInsets.only(top:8.0)),
                Divider(),
                //Telefono
                TextField(
                  controller: telController,
                  style: TextStyle(
                    fontWeight:FontWeight.bold,
                    fontSize:18.0),
                  decoration: InputDecoration(
                    icon: Icon(Icons.phone),
                    labelText: 'Teléfono'),
                    keyboardType: TextInputType.text,
                ),
                Padding(padding:EdgeInsets.only(top:8.0)),
                Divider(),
                //Dirección
                TextField(
                  controller: dirController,
                  style: TextStyle(
                    fontWeight:FontWeight.bold,
                    fontSize:18.0),
                  decoration: InputDecoration(
                    icon: Icon(Icons.directions),
                    labelText: 'Dirección'),
                    keyboardType: TextInputType.text,
                ),
                Padding(padding:EdgeInsets.only(top:8.0)),
                Divider(),
                //Mail
                TextField(
                  controller: mailController,
                  style: TextStyle(
                    fontWeight:FontWeight.bold,
                    fontSize:18.0),
                  decoration: InputDecoration(
                    icon: Icon(Icons.mail),
                    labelText: 'Correo Electrónico'),
                    keyboardType: TextInputType.emailAddress,
                ),
                Padding(padding:EdgeInsets.only(top:8.0)),
                Divider(),

                TextButton(
                  onPressed: (){
                    if(widget.persona.id!=null){
                      personaRF.child(widget.persona.id.toString()).set({
                        'nombre':nombreController.text,
                        'apellido':apellidoController.text,
                        'edad':edadController.text,
                        'tel':telController.text,
                        'dir':dirController.text,
                        'mail':mailController.text
                      }).then((_)=>{Navigator.pop(context)});
                    }else{
                      personaRF.push().set({
                        'nombre':nombreController.text,
                        'apellido':apellidoController.text,
                        'edad':edadController.text,
                        'tel':telController.text,
                        'dir':dirController.text,
                        'mail':mailController.text
                      }).then((_)=>{Navigator.pop(context)});
                    }
                  },
                  child: (widget.persona.id!=null)?Text('Actualizar'):Text('Añadir'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}