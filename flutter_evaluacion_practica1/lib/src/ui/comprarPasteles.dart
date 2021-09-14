import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:flutter_evaluacion_practica1/screens/widget/navigation_drawer_widget.dart';
import 'package:flutter_evaluacion_practica1/services/auth_services.dart';
import 'package:flutter_evaluacion_practica1/src/model/pastel.dart';
import 'package:flutter_evaluacion_practica1/src/ui/screen_pastel.dart';
import 'dart:async';

import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ComprarPastel extends StatefulWidget {
  ComprarPastel({Key? key}) : super(key: key);
  _ComprarPastelState createState() => _ComprarPastelState();
}

final pastelRF = FirebaseDatabase.instance.reference().child('pastel').orderByChild("status").equalTo("Activo");

class _ComprarPastelState extends State<ComprarPastel> {
  late List<Pastel> items;
  //bool statusComprado = false;


  late StreamSubscription<Event> addPastel;
  late StreamSubscription<Event> changePastel;

  @override
  void initState() {
    super.initState();
    items = [];
    //statusComprado = false;
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
      title: 'Comprar un Pastel',
      home: Scaffold(
        drawer: NavigationDrawerWidget(),
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backwardsCompatibility: false,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: new Color.fromRGBO(48, 71, 94, 1),
            statusBarIconBrightness: Brightness.light,
          ),
          title: Text("Comprar un Pastel"),
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
                                                fontFamily: 'Lato',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: new Color.fromRGBO(
                                                    110, 133, 178, 1)),
                                          ),
                                          onTap: () => _infoPastel(
                                              context, items[position], ''),
                                        ),
                                      ),
                                      Container(
                                        //height: 10,
                                        child: Row(
                                          children: <Widget>[
                                            // ignore: deprecated_member_use
                                            RaisedButton(
                                              onPressed: () => {
                                                showDialog(
                                                  context: context, 
                                                  builder: (BuildContext context){
                                                    return AlertDialog(
                                                      title: Column(
                                                        children: [
                                                          Text('Confirmar Compra', style: TextStyle(fontFamily: "Lato", fontSize: 25, color: Colors.black),),
                                                          Padding(padding: EdgeInsets.only(top: 10, bottom: 20)),
                                                          Image.network('https://firebasestorage.googleapis.com/v0/b/flutter-evaluacion-practica1.appspot.com/o/imagenes%2Ficon_warning.png?alt=media&token=3d6db5bb-0c6c-44ea-9df5-bd94a74bdd6a',
                                                          width: 50, height: 50, fit: BoxFit.contain,),
                                                          Padding(padding: EdgeInsets.only(bottom: 20)),
                                                          Text(
                                                            'Datos:',
                                                            style: TextStyle(
                                                              fontFamily: 'Poppins',
                                                              fontSize: 22,
                                                              color: new Color.fromRGBO(
                                                                  62, 44, 65, 1),
                                                            ),
                                                          ),
                                                          Padding(padding: EdgeInsets.only(bottom: 10)),
                                                          Text(
                                                            'Articulo: ${items[position].articulo}',
                                                            style: TextStyle(
                                                            fontFamily: 'Lato',
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 18,
                                                            color: new Color.fromRGBO(
                                                                110, 133, 178, 1)),
                                                          ),
                                                          Padding(padding: EdgeInsets.only(bottom: 10)),
                                                          Text(
                                                            'Precio: \$ ${items[position].precio}',
                                                            style: TextStyle(
                                                            fontFamily: 'Lato',
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 18,
                                                            color: new Color.fromRGBO(
                                                                110, 133, 178, 1)),
                                                          ),
                                                          Padding(padding: EdgeInsets.only(bottom: 10)),
                                                          Text(
                                                            'Fecha: ${items[position].fecha}',
                                                            style: TextStyle(
                                                            fontFamily: 'Lato',
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 18,
                                                            color: new Color.fromRGBO(
                                                                110, 133, 178, 1)),
                                                          ),
                                                          Padding(padding: EdgeInsets.only(bottom: 20)),
                                                        ],
                                                      ), 
                                                      content: SingleChildScrollView(
                                                        child: ListBody(
                                                          children: [
                                                            Center(child: Text('¿Comprar Pastel?', style: TextStyle(fontFamily: "Lato", fontWeight: FontWeight.w700, fontSize: 20, color: Colors.green[300]),)),
                                                          ],
                                                        ),
                                                      ),
                                                      actions: [
                                                        DialogButton(
                                                          child: Text(
                                                            "Comprar",
                                                            style: TextStyle(color: Colors.black45, fontSize: 18, fontWeight: FontWeight.w700, fontFamily: 'Lato'),
                                                          ),
                                                          onPressed: () => {
                                                            _infoPastel(
                                                              context, items[position], '${items[position].status}'),
                                                            // statusComprado = true,
                                                            // print(statusComprado),
                                                            // print("Comprado"),
                                                            // Navigator.of(context).pop(),
                                                          },
                                                          gradient: LinearGradient(colors: [
                                                            Color.fromRGBO(145, 255, 243, 1.0),
                                                            Color.fromRGBO(168, 235, 18, 1.0)
                                                          ]),
                                                        ),
                                                        DialogButton(
                                                          child: Text(
                                                            "Cancelar",
                                                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700, fontFamily: 'Lato'),
                                                          ),
                                                          onPressed: (){
                                                            print("Cancelar");
                                                            Navigator.of(context).pop();
                                                          },
                                                          gradient: LinearGradient(colors: [
                                                            Color.fromRGBO(116, 116, 191, 1.0),
                                                            Color.fromRGBO(52, 138, 199, 1.0)
                                                          ]),
                                                        )
                                                      ],
                                                    );
                                                  }
                                                ),
                                                print("Bóton Comprar Azul"),
                                                //Navigator.of(context).pop(),
                                              },
                                              child: Container(
                                                width: 200,
                                                padding: EdgeInsets.only(
                                                      bottom: 10, top: 10, left: 15, right: 15),
                                                child: Center(
                                                  child: Text( "Comprar",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 18,
                                                      fontFamily: 'Lato',
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              
                                              
                                              color: new Color.fromRGBO(48, 71, 94, 1),
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
              }
          ),
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

  void _infoPastel(BuildContext context, Pastel pastel, statusActual) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScreenPastel(pastel, true, statusActual),
        ));
  }

  void agregarPastel(BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ScreenPastel(Pastel(null, '', '', '', '', '','', 0, 0,''), false, ""),
        ));
  }
}
