import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_evaluacion_practica1/screens/widget/navigation_drawer_widget.dart';
import 'package:flutter_evaluacion_practica1/services/auth_services.dart';

import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<AuthServices>(context);

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Inicio',
        home: Scaffold(
          drawer: NavigationDrawerWidget(),
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            backwardsCompatibility: false,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: new Color.fromRGBO(48, 71, 94, 1),
              statusBarIconBrightness: Brightness.light,
            ),
            title: Text("Inicio"),
            backgroundColor: new Color.fromRGBO(48, 71, 94, 1),
            actions: [
              IconButton(
                  onPressed: () async => await loginProvider.logout(),
                  icon: Icon(Icons.exit_to_app)),
            ],
          ),
          body: SingleChildScrollView(
            child: Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 30),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 2 - 150,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.7),
                            blurRadius: 20,
                            spreadRadius: 10,
                          )
                        ],
                        color: new Color.fromRGBO(48, 71, 94, 1),
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                        )),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                              color: Colors.indigo[500],
                              borderRadius: BorderRadius.circular(75),
                              boxShadow: [
                                BoxShadow(
                                  color: new Color.fromRGBO(48, 91, 94, 1),
                                  spreadRadius: 2,
                                )
                              ]),
                          child: Center(
                            child: CircleAvatar(
                              radius: 150,
                              backgroundImage: AssetImage('assets/pastelPNG.png'),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 35),
                          child: Text(
                            'Pastelerias',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
