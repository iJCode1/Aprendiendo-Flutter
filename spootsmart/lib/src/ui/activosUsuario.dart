import 'dart:async';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:spootsmart/src/model/habitacion.dart';
import 'package:spootsmart/src/ui/modificarUsuario.dart';
import 'package:spootsmart/src/ui/esp.dart';
import 'package:spootsmart/src/ui/home_user.dart';

class ListViewProductUser extends StatefulWidget {
  ListViewProductUser({Key? key}) : super(key: key);

  @override
  _ListViewProductUserState createState() => _ListViewProductUserState();
}

//referencia a la tabla de Firebase
final productRef =
    FirebaseDatabase.instance.reference().child('Habitacion').child('Activa');

class _ListViewProductUserState extends State<ListViewProductUser> {
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
          title: Text('Habitaciones Activas'),
          centerTitle: true,
          backgroundColor: new Color.fromRGBO(119, 172, 241, 1),
        ),
        body: Center(
          child: Container(
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
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          child: Image.file(
                                            new File(
                                                '${items[position].foto}'),
                                            height: 100,
                                            width: 200,
                                          ))),
                                ),
                                SizedBox(
                                  width: 24.0,
                                ),
                                Expanded(
                                  child: Container(
                                    height: 170,
                                    // color: Colors.indigo,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                            onTap: () => _webSocketLed(context),
                                          ),
                                        ),
                                        Container(
                                          //height: 10,
                                          child: Row(
                                            children: <Widget>[
                                              IconButton(
                                                  icon: Icon(
                                                      Icons.delete_outlined,
                                                      color: new Color.fromRGBO(
                                                          255, 136, 130, 1)),
                                                  // onPressed: () => _borrarPastel(
                                                  //     context,
                                                  //     items[position],
                                                  //     position
                                                  // ),
                                                  onPressed: () => {
                                                        showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: Column(
                                                                  children: [
                                                                    Text(
                                                                      'Confirmar Eliminación',
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              "Lato",
                                                                          fontSize:
                                                                              25,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                    Padding(
                                                                        padding: EdgeInsets.only(
                                                                            top:
                                                                                10,
                                                                            bottom:
                                                                                20)),
                                                                    Image
                                                                        .network(
                                                                      'https://firebasestorage.googleapis.com/v0/b/flutter-evaluacion-practica1.appspot.com/o/imagenes%2Ficon_error.png?alt=media&token=ca100e99-53db-417f-afa2-3b3ded8073c6',
                                                                      width: 50,
                                                                      height:
                                                                          50,
                                                                      fit: BoxFit
                                                                          .contain,
                                                                    ),
                                                                    Padding(
                                                                        padding:
                                                                            EdgeInsets.only(bottom: 20)),
                                                                    Text(
                                                                      'Datos:',
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'Poppins',
                                                                        fontSize:
                                                                            22,
                                                                        color: new Color.fromRGBO(
                                                                            62,
                                                                            44,
                                                                            65,
                                                                            1),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                        padding:
                                                                            EdgeInsets.only(bottom: 10)),
                                                                    Text(
                                                                      'Nombre: ${items[position].id}',
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'Lato',
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              18,
                                                                          color: new Color.fromRGBO(
                                                                              110,
                                                                              133,
                                                                              178,
                                                                              1)),
                                                                    ),
                                                                    Padding(
                                                                        padding:
                                                                            EdgeInsets.only(bottom: 10)),
                                                                    Text(
                                                                      'Status: \ ${items[position].status}',
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'Lato',
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              18,
                                                                          color: new Color.fromRGBO(
                                                                              110,
                                                                              133,
                                                                              178,
                                                                              1)),
                                                                    ),
                                                                    Padding(
                                                                        padding:
                                                                            EdgeInsets.only(bottom: 20)),
                                                                    Text(
                                                                      'Fecha: ${items[position].fecha}',
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'Lato',
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              18,
                                                                          color: new Color.fromRGBO(
                                                                              110,
                                                                              133,
                                                                              178,
                                                                              1)),
                                                                    ),
                                                                    Padding(
                                                                        padding:
                                                                            EdgeInsets.only(bottom: 20)),
                                                                  ],
                                                                ),
                                                                content:
                                                                    SingleChildScrollView(
                                                                  child:
                                                                      ListBody(
                                                                    children: [
                                                                      Center(
                                                                          child:
                                                                              Text(
                                                                        '¿Eliminar Producto?',
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                "Lato",
                                                                            fontWeight: FontWeight
                                                                                .w700,
                                                                            fontSize:
                                                                                20,
                                                                            color:
                                                                                Colors.red[300]),
                                                                      )),
                                                                    ],
                                                                  ),
                                                                ),
                                                                actions: [
                                                                  DialogButton(
                                                                    width: 300,
                                                                    child: Text(
                                                                      "Eliminar",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight: FontWeight
                                                                              .w700,
                                                                          fontFamily:
                                                                              'Lato'),
                                                                    ),
                                                                    onPressed:
                                                                        () => {
                                                                      // Navigator.pop(context),
                                                                      _borrarProducto(
                                                                          context,
                                                                          items[position]
                                                                              .id!),
                                                                      // Navigator.of(context).pop(),
                                                                    },
                                                                    gradient:
                                                                        LinearGradient(
                                                                            colors: [
                                                                          Color.fromRGBO(
                                                                              255,
                                                                              122,
                                                                              168,
                                                                              1.0),
                                                                          Color.fromRGBO(
                                                                              254,
                                                                              51,
                                                                              114,
                                                                              1.0)
                                                                        ]),
                                                                  ),
                                                                  DialogButton(
                                                                    child: Text(
                                                                      "Cancelar",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black54,
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight: FontWeight
                                                                              .w700,
                                                                          fontFamily:
                                                                              'Lato'),
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    gradient:
                                                                        LinearGradient(
                                                                            colors: [
                                                                          Color.fromRGBO(
                                                                              240,
                                                                              255,
                                                                              122,
                                                                              1.0),
                                                                          Color.fromRGBO(
                                                                              175,
                                                                              255,
                                                                              70,
                                                                              1.0)
                                                                        ]),
                                                                  )
                                                                ],
                                                              );
                                                            }),
                                                      }),
                                              IconButton(
                                                icon: Icon(Icons.edit,
                                                    color: new Color.fromRGBO(
                                                        140, 200, 155, 1)),
                                                onPressed: () => _verProducto(
                                                    context, items[position]),
                                              ),
                                              SizedBox(
                                                width: 2.0,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.arrow_back, color: Colors.white),
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

  /*void _infoProducto(BuildContext context, Habitacion habitacion) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InfoProducto(habitacion),
        ));
  }*/

  void _webSocketLed(BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WebSocketLed(),
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
                                builder: (context) => ListViewProductUser()));
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

  void _verProducto(BuildContext context, Habitacion habitacion) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ModificarUsuario(habitacion),
        ));
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0, size.height - 90); //Bottom - Left
    var controllPoint = Offset(50, size.height);
    var endPoint = Offset(size.width / 2, size.height);
    path.quadraticBezierTo(
        controllPoint.dx, controllPoint.dy, endPoint.dx, endPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
