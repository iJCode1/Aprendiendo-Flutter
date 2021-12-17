import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spootsmart/src/model/habitacion.dart';
import 'package:spootsmart/src/ui/informacion.dart';
import 'package:spootsmart/src/ui/home_admin.dart';

class ListViewProductIn extends StatefulWidget {
  ListViewProductIn({Key? key}) : super(key: key);

  @override
  _ListViewProductInState createState() => _ListViewProductInState();
}

//referencia a la tabla de Firebase
final productRef =
    FirebaseDatabase.instance.reference().child('Habitacion').child('Inactiva');
final productoRefActivo =
    FirebaseDatabase.instance.reference().child('Habitacion').child('Activa');
final productoRefInactivo =
    FirebaseDatabase.instance.reference().child('Habitacion').child('Inactiva');

class _ListViewProductInState extends State<ListViewProductIn> {
  //lista de las personas
  late List<Habitacion> items;

  late StreamSubscription<Event> addProducto;
  late StreamSubscription<Event> changeProducto;

  @override
  void initState() {
    super.initState();
    items = [];
    addProducto = productRef.onChildAdded.listen(_addProducto);
    changeProducto = productRef.onChildChanged.listen(_updateProducto);
  }

  @override
  void dispose() {
    super.dispose();
    addProducto.cancel();
    changeProducto.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habitaciones',
      home: Scaffold(
          //resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            backwardsCompatibility: false,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: new Color.fromRGBO(119, 172, 241, 1),
              statusBarIconBrightness: Brightness.light,
            ),
            title: Text('Habitaciones'),
            centerTitle: true,
            backgroundColor: new Color.fromRGBO(119, 172, 241, 1),
          ),
          body: Center(
            child: ListView.builder(
              itemCount: items.length,
              padding: EdgeInsets.only(top: 12.0),
              itemBuilder: (context, position) {
                return Column(
                  children: [
                    Divider(
                      height: 7.0,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            title: Text(
                              '${items[position].id}',
                              style: TextStyle(
                                  color: Colors.black, fontSize: 21.0),
                            ),
                            subtitle: Text(
                              '${items[position].status}',
                              style: TextStyle(
                                  color: Colors.black, fontSize: 21.0),
                            ),
                            leading: Column(children: [
                              CircleAvatar(
                                backgroundColor: Colors.redAccent,
                                radius: 17.0,
                                child: Text(
                                  '${position + 1}',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 21.0),
                                ),
                              ),
                            ]),
                            onTap: () =>
                                _infoProducto(context, items[position]),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.orangeAccent,
                          ),
                          onPressed: () =>
                              _borrarProducto(context, items[position].id!),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.update,
                            color: Colors.orangeAccent,
                          ),
                          onPressed: () =>
                              _cambiarStatus(context, items[position]),
                        )
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(
              Icons.arrow_back,
              color: Colors.red[300],
            ),
            backgroundColor: Colors.redAccent,
            onPressed: () => {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomeAdmin()))
            },
          )),
    );
  }

  void _addProducto(Event event) {
    setState(() {
      items.add(new Habitacion.fromSnapShot(event.snapshot));
    });
  }

  void _updateProducto(Event event) {
    var oldProducto =
        items.singleWhere((persona) => persona.id == event.snapshot.key);
    setState(() {
      items[items.indexOf(oldProducto)] =
          new Habitacion.fromSnapShot(event.snapshot);
    });
  }

  void _infoProducto(BuildContext context, Habitacion habitacion) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InfoProducto(habitacion),
        ));
  }

  void _borrarProducto(BuildContext context, String id) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Eliminar"),
            content:
                new Text("¿Desea eliminar de forma definitiva el registro?"),
            actions: <Widget>[
              // ignore: deprecated_member_use
              new FlatButton(
                child: new Text("Si"),
                onPressed: () {
                  productRef.child(id).remove().then((_) => setState(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListViewProductIn()));
                      }));
                },
              ),
              // ignore: deprecated_member_use
              new FlatButton(
                child: new Text("No"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void _cambiarStatus(BuildContext context, Habitacion habitacion) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Cambiar Status"),
            content: new Text("¿Desea cambiar el status del registro?"),
            actions: <Widget>[
              // ignore: deprecated_member_use
              new FlatButton(
                child: new Text("Si"),
                onPressed: () {
                  if (habitacion.status == 'Activa') {
                    productoRefInactivo.child(habitacion.id!).set({
                      'fecha': habitacion.fecha,
                      'imagen': habitacion.foto,
                      'latitud': habitacion.latitud,
                      'longitud': habitacion.longitud,
                      'status': 'Inactiva',
                    }).then((_) => {Navigator.pop(context)});
                    productoRefActivo
                        .child(habitacion.id!)
                        .remove()
                        .then((_) => setState(() {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ListViewProductIn(),
                                  ));
                            }));
                  } else if (habitacion.status == 'Inactiva') {
                    productoRefActivo.child(habitacion.id!).set({
                      'fecha': habitacion.fecha,
                      'imagen': habitacion.foto,
                      'latitud': habitacion.latitud,
                      'longitud': habitacion.longitud,
                      'status': 'Activa',
                    }).then((_) => {Navigator.pop(context)});
                    productoRefInactivo
                        .child(habitacion.id!)
                        .remove()
                        .then((_) => setState(() {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ListViewProductIn()));
                            }));
                  }
                },
              ),
              // ignore: deprecated_member_use
              new FlatButton(
                child: new Text("No"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
