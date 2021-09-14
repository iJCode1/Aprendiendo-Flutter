import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:flutter_evaluacion_practica1/screens/widget/navigation_drawer_widget.dart';
import 'package:flutter_evaluacion_practica1/services/auth_services.dart';
import 'package:flutter_evaluacion_practica1/src/model/pastel.dart';
import 'package:flutter_evaluacion_practica1/src/ui/information_pastel.dart';
import 'package:flutter_evaluacion_practica1/src/ui/screen_pastel.dart';
import 'dart:async';

import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ListViewPastel extends StatefulWidget {
  ListViewPastel({Key? key}) : super(key: key);
  _ListViewPastelState createState() => _ListViewPastelState();
}

final pastelRF = FirebaseDatabase.instance.reference().child('pastel');

class _ListViewPastelState extends State<ListViewPastel> {
  late List<Pastel> items;

  late StreamSubscription<Event> addPastel;
  late StreamSubscription<Event> changePastel;

  @override
  void initState() {
    super.initState();
    items = [];
    addPastel = pastelRF.onChildAdded.listen(_addPastel);
    changePastel = pastelRF.onChildChanged.listen(_updatePastel);
  }

  @override
  void dispose() {
    super.dispose();
    addPastel.cancel();
    changePastel.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<AuthServices>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Productos',
      home: Scaffold(
        drawer: NavigationDrawerWidget(),
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backwardsCompatibility: false,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: new Color.fromRGBO(48, 71, 94, 1),
            statusBarIconBrightness: Brightness.light,
          ),
          title: Text("Productos"),
          backgroundColor: new Color.fromRGBO(48, 71, 94, 1),
          actions: [
            IconButton(
                onPressed: () async => await loginProvider.logout(),
                icon: Icon(Icons.exit_to_app)),
          ],
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        child: Image.file(
                                          new File('${items[position].foto}'),
                                          height: 100,
                                          width: 200,
                                        ))),
                              ),
                              SizedBox(
                                width: 24.0,
                              ),
                              Expanded(
                                child: Container(
                                  height: 160,
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
                                            '${items[position].articulo}',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 22,
                                              color: new Color.fromRGBO(
                                                  62, 44, 65, 1),
                                            ),
                                          ),
                                          subtitle: Text(
                                            '\$ ${items[position].precio}',
                                            style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 18,
                                                color: new Color.fromRGBO(
                                                    110, 133, 178, 1)),
                                          ),
                                          onTap: () => _infoPastel(
                                              context, items[position]),
                                        ),
                                      ),
                                      Container(
                                        //height: 10,
                                        child: Row(
                                          children: <Widget>[
                                            IconButton(
                                              icon: Icon(Icons.delete_outlined,
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
                                                  builder: (BuildContext context){
                                                    return AlertDialog(
                                                      title: Column(
                                                        children: [
                                                          Text('Confirmar Eliminación', style: TextStyle(fontFamily: "Lato", fontSize: 25, color: Colors.black),),
                                                          Padding(padding: EdgeInsets.only(top: 10, bottom: 20)),
                                                          Image.network('https://firebasestorage.googleapis.com/v0/b/flutter-evaluacion-practica1.appspot.com/o/imagenes%2Ficon_error.png?alt=media&token=ca100e99-53db-417f-afa2-3b3ded8073c6',
                                                          width: 50, height: 50, fit: BoxFit.contain,),
                                                        ],
                                                      ), 
                                                      content: SingleChildScrollView(
                                                        child: ListBody(
                                                          children: [
                                                            Text('¿Eliminar Producto?', style: TextStyle(fontFamily: "Lato", fontWeight: FontWeight.w700, fontSize: 20, color: Colors.red[300]),),
                                                          ],
                                                        ),
                                                      ),
                                                      actions: [
                                                        DialogButton(
                                                          width: 300,
                                                          child: Text(
                                                            "Baja Física (Definitiva)",
                                                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700, fontFamily: 'Lato'),
                                                          ),
                                                          onPressed: () => {
                                                            // Navigator.pop(context),
                                                            _borrarPastel(
                                                                context,
                                                                items[position],
                                                                position
                                                            ),
                                                            Navigator.of(context).pop(),
                                                          // Navigator.of(context).pop(),
                                                          },
                                                          gradient: LinearGradient(colors: [
                                                            Color.fromRGBO(255, 122, 168, 1.0),
                                                            Color.fromRGBO(254, 51, 114, 1.0)
                                                          ]),
                                                        ),
                                                        DialogButton(
                                                          child: Text(
                                                            "Baja Lógica (Status)",
                                                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700, fontFamily: 'Lato'),
                                                          ),
                                                          onPressed: () => {
                                                            // Navigator.pop(context),
                                                          },
                                                          gradient: LinearGradient(colors: [
                                                            Color.fromRGBO(116, 116, 191, 1.0),
                                                            Color.fromRGBO(52, 138, 199, 1.0)
                                                          ]),
                                                        ),
                                                        DialogButton(
                                                          child: Text(
                                                            "Cancelar",
                                                            style: TextStyle(color: Colors.black54, fontSize: 18, fontWeight: FontWeight.w700, fontFamily: 'Lato'),
                                                          ),
                                                          onPressed: (){
                                                            
                                                            Navigator.of(context).pop();
                                                          },
                                                          gradient: LinearGradient(colors: [
                                                            Color.fromRGBO(240, 255, 122, 1.0),
                                                            Color.fromRGBO(175, 255, 70, 1.0)
                                                          ]),
                                                        )
                                                      ],
                                                    );
                                                  }
                                                ),
                                              }
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                  Icons.remove_red_eye_outlined,
                                                  color: new Color.fromRGBO(
                                                      140, 200, 155, 1)),
                                              onPressed: () => _verPastel(
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
    );
  }

  void _addPastel(Event event) {
    setState(() {
      items.add(new Pastel.fromSnapshot(event.snapshot));
    });
  }

  void _updatePastel(Event event) {
    var oldPastel =
        items.singleWhere((pastel) => pastel.id == event.snapshot.key);
    setState(() {
      items[items.indexOf(oldPastel)] = new Pastel.fromSnapshot(event.snapshot);
    });
  }

  void _infoPastel(BuildContext context, Pastel pastel) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScreenPastel(pastel),
        ));
  }

  void _borrarPastel(BuildContext context, Pastel pastel, int position) async {
    await pastelRF.child(pastel.id.toString()).remove().then((_) {
      setState(() {
        items.remove(position);
        setState(() {
          items.removeAt(position);
        });
        //Navigator.of(context).pop();
      });
    });
  }

  void _verPastel(BuildContext context, Pastel pastel) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InfoPastel(pastel),
        ));
  }

  void agregarPastel(BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ScreenPastel(Pastel(null, '', '', '', '', '', 0, 0, '')),
        ));
  }
}
