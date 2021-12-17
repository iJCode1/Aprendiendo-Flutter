import 'dart:async';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spootsmart/src/model/habitacion.dart';
import 'package:spootsmart/src/ui/informacion.dart';
import 'package:spootsmart/src/ui/home_user.dart';

class ListViewProductInUser extends StatefulWidget {
  ListViewProductInUser({Key? key}) : super(key: key);

  @override
  _ListViewProductInUserState createState() => _ListViewProductInUserState();
}

//referencia a la tabla de Firebase
final productRef =
    FirebaseDatabase.instance.reference().child('Habitacion').child('Inactiva');
final productoRefActivo =
    FirebaseDatabase.instance.reference().child('Habitacion').child('Activa');
final productoRefInactivo =
    FirebaseDatabase.instance.reference().child('Habitacion').child('Inactiva');

class _ListViewProductInUserState extends State<ListViewProductInUser> {
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
    return Scaffold(
        //resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backwardsCompatibility: false,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: new Color.fromRGBO(119, 172, 241, 1),
            statusBarIconBrightness: Brightness.light,
          ),
          title: Text('Habitaciones Inactivas'),
          centerTitle: true,
          backgroundColor: new Color.fromRGBO(119, 172, 241, 1),
        ),
        body: Center(
          child: ListView.builder(
            itemCount: items.length,
            padding: EdgeInsets.only(top: 12.0),
            itemBuilder: (context, position) {
              return Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: IntrinsicHeight(
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              width: 12.0,
                            ),
                            Hero(
                              tag: '${items[position].id}',
                              child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      child: Image.file(
                                        new File('${items[position].foto}'),
                                        height: 100,
                                        width: 200,
                                      ))),
                            ),
                            SizedBox(
                              width: 20.0,
                            ),
                            Expanded(
                              child: Container(
                                height: 170,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      child: ListTile(
                                        title: Text(
                                          '${items[position].id}',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 22,
                                            color: new Color.fromRGBO(
                                                62, 44, 65, 1),
                                          ),
                                        ),
                                        subtitle: Text(
                                          '\ ${items[position].status}',
                                          style: TextStyle(
                                              fontFamily: 'Lato',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: new Color.fromRGBO(
                                                  110, 133, 178, 1)),
                                        ),
                                        onTap: () => _infoProducto(
                                            context, items[position]),
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        children: <Widget>[
                                          IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.redAccent,
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
                                        ]
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          backgroundColor: new Color.fromRGBO(119, 172, 241, 1),
          onPressed: () => {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeUser()))
          },
        ));
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
                                builder: (context) => ListViewProductInUser()));
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
                      'foto': habitacion.foto,
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
                                    builder: (context) =>
                                        ListViewProductInUser(),
                                  ));
                            }));
                  } else if (habitacion.status == 'Inactiva') {
                    productoRefActivo.child(habitacion.id!).set({
                      'fecha': habitacion.fecha,
                      'foto': habitacion.foto,
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
                                          ListViewProductInUser()));
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
