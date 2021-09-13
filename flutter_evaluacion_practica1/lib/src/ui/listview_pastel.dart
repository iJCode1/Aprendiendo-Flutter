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
                                              onPressed: () => _borrarPastel(
                                                  context,
                                                  items[position],
                                                  position),
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
