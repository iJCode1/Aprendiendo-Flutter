import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Creditos extends StatelessWidget {
  final urlImage =
      'https://firebasestorage.googleapis.com/v0/b/flutter-evaluacion-practica1.appspot.com/o/imagenes%2Ffoto.jpeg?alt=media&token=5bc9590e-f0fb-47b6-8905-8229e705f87b';

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backwardsCompatibility: false,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: new Color.fromRGBO(48, 71, 94, 1),
            statusBarIconBrightness: Brightness.light,
          ),
          title: Text('Créditos'),
          centerTitle: true,
          backgroundColor: new Color.fromRGBO(48, 71, 94, 1),
        ),
        body: SafeArea(
            child: Container(
          padding: EdgeInsets.only(top: 50),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(radius: 60, backgroundImage: NetworkImage(urlImage)),
              SizedBox(width: 20),
              Container(
                padding:
                    EdgeInsets.only(top: 10, left: 30, right: 30, bottom: 10),
                child: Text(
                  'Joel Dominguez Merino',
                  style: TextStyle(
                      fontSize: 30.0,
                      color: new Color.fromRGBO(48, 71, 94, 1),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Pacifico'),
                  textAlign: TextAlign.center,
                ),
              ),
              Text(
                'Estudiante 9º Semestre',
                style: TextStyle(
                    fontFamily: 'SourceSansPro',
                    color: Colors.teal.shade200,
                    fontSize: 18.0,
                    letterSpacing: 2.5,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30.0,
                width: 150.0,
                child: Divider(color: Colors.teal.shade200),
              ),
              Card(
                  margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: ListTile(
                      leading: Container(
                        margin: EdgeInsets.only(top: 22),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.school,
                              color: Colors.teal.shade900,
                            ),
                          ],
                        ),
                      ),
                      title: Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          'Materia \nProgramación Avanzada - Desarrollo de Aplicaciones para Dispositivos Moviles',
                          style: TextStyle(
                              color: Colors.teal.shade900,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Pacifico'),
                        ),
                      ))),
              Card(
                  margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: ListTile(
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person,
                          color: Colors.teal.shade900,
                        ),
                      ],
                    ),
                    title: Container(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        'Docente: \nRocio Elizabeth Pulido Alba',
                        style: TextStyle(
                            color: Colors.teal.shade900,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Pacifico'),
                      ),
                    ),
                  )),
              Card(
                  margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: ListTile(
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.info,
                          color: Colors.teal.shade900,
                        ),
                      ],
                    ),
                    title: Container(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        'Versión: 1.0',
                        style: TextStyle(
                            color: Colors.teal.shade900,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Pacifico'),
                      ),
                    ),
                  )),
            ],
          ),
        )),
      );
}
