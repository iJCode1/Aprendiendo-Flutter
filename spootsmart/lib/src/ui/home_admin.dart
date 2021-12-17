import 'package:flutter/services.dart';
import 'package:spootsmart/src/model/habitacion.dart';
import 'package:spootsmart/src/ui/creditos.dart';
import 'package:flutter/material.dart';
import 'package:spootsmart/src/ui/altas.dart';
import 'package:spootsmart/src/ui/buscar.dart';
import 'package:spootsmart/src/ui/activos.dart';
import 'package:spootsmart/src/ui/inactivos.dart';
import 'package:spootsmart/src/ui/login_screen.dart';
import 'package:spootsmart/src/ui/altaUsuario.dart';
import 'dart:async';
import 'package:video_player/video_player.dart';

//ignore: must_be_immutable
class HomeAdmin extends StatefulWidget {
  late Habitacion habitacion;

  @override
  _HomeAdminState createState() => _HomeAdminState();
}
//Referencia a la tabla firebase

class _HomeAdminState extends State<HomeAdmin> {
  late VideoPlayerController _videoCtrl;
  late Future<void> _initializerVideoPlayerFuture;

  @override
  void initState() {
    _videoCtrl = VideoPlayerController.asset('assets/video.mp4');
    _initializerVideoPlayerFuture = _videoCtrl.initialize();
    super.initState();
  }

  @override
  void dispose() {
    _videoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: new Color.fromRGBO(255, 116, 116, 1),
          statusBarIconBrightness: Brightness.light,
        ),
        title: Text('Home Administrador'),
        backgroundColor: new Color.fromRGBO(255, 116, 116, 1),
      ),
      body: FutureBuilder(
        future: _initializerVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SingleChildScrollView(
              child: Center(
                child: Container(
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          padding: EdgeInsets.only(top: 45),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 2 - 170,
                          decoration: BoxDecoration(
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: Colors.black.withOpacity(0.7),
                              //     blurRadius: 20,
                              //     spreadRadius: 10,
                              //   )
                              // ],
                              color: new Color.fromRGBO(255, 116, 116, 1),
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(30),
                                bottomLeft: Radius.circular(30),
                              )),
                          child: Column(
                            children: <Widget>[
                              Center(
                                child: Container(
                                  height: 160,
                                  width: 160,
                                  child: Center(
                                    child: Image(
                                        width: 120,
                                        image: AssetImage(
                                            "assets/images/logoFoco_blanco.png")),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      AspectRatio(
                        aspectRatio: _videoCtrl.value.aspectRatio,
                        child: VideoPlayer(_videoCtrl),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: new Color.fromRGBO(255, 116, 116, 1),
        child: Icon(
          _videoCtrl.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
        onPressed: () {
          setState(() {
            if (_videoCtrl.value.isPlaying) {
              _videoCtrl.pause();
            } else {
              _videoCtrl.play();
            }
          });
        },
      ),
      drawer: Drawer(
          child: Material(
        // color: new Color.fromRGBO(255, 120, 120, 1),
        child: new ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("SpootSmart", style: TextStyle(fontSize: 24)),
              // accountEmail: Text("vendedor@gmail.com"),
              currentAccountPicture: Container(
                child: Container(
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/logoPequenoRojo.png"),
                    backgroundColor: new Color.fromRGBO(255, 116, 116, 1),
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: new Color.fromRGBO(255, 116, 116, 1),
              ),
              accountEmail: null,
            ),
            ListTile(
                title: Text('Inicio'),
                leading: Icon(Icons.home),
                onTap: () => home(context)),
            ListTile(
                title: Text('Alta de Usuario'),
                leading: Icon(Icons.person),
                onTap: () => agregarUsuario(context)),
            // ListTile(
            //     title: Text('Alta de Habitación'),
            //     leading: Icon(Icons.king_bed_outlined),
            //     onTap: () => agregarHabitacion(context)),
            // ListTile(
            //     title: Text('Buscar'),
            //     leading: Icon(Icons.search),
            //     onTap: () => buscarHabitacion(context)),
            // ListTile(
            //     title: Text('Habitaciones Activas'),
            //     leading: Icon(Icons.check),
            //     onTap: () => activosHabitacion(context)),
            // ListTile(
            //     title: Text('Habitaciones Inactivas'),
            //     leading: Icon(Icons.list_alt_outlined),
            //     onTap: () => inactivosHabitacion(context)),
            // ListTile(
            //     title: Text('Créditos'),
            //     leading: Icon(Icons.info_outline),
            //     onTap: () => creditos(context)),
            ListTile(
                title: Text('Cerrar Sesión'),
                leading: Icon(Icons.subdirectory_arrow_left_outlined),
                onTap: () => loginScreen(context)),
          ],
        ),
      )),
    );
  }

  void home(BuildContext context) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomeAdmin()));
  }

  void agregarUsuario(BuildContext context) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => AltaUsuario()));
  }

  void agregarHabitacion(BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                Altas(Habitacion(null, '', '', '', '', '', ''))));
  }

  void buscarHabitacion(BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                Buscar(Habitacion(null, '', '', '', '', '', ''))));
  }

  void activosHabitacion(BuildContext context) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => ListViewProduct()));
  }

  void inactivosHabitacion(BuildContext context) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => ListViewProductIn()));
  }

  void creditos(BuildContext context) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => Creditos()));
  }

  void loginScreen(BuildContext context) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
