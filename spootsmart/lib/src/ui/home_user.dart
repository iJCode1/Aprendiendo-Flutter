import 'package:flutter/services.dart';
import 'package:spootsmart/src/model/habitacion.dart';
import 'package:flutter/material.dart';
import 'package:spootsmart/src/ui/altas.dart';
import 'package:spootsmart/src/ui/buscar.dart';
import 'package:spootsmart/src/ui/activosUsuario.dart';
import 'package:spootsmart/src/ui/inactivosUsuario.dart';
import 'package:spootsmart/src/ui/creditos.dart';
import 'package:spootsmart/src/ui/login_screen.dart';
import 'package:spootsmart/src/ui/realidad.dart';
import 'dart:async';
import 'package:video_player/video_player.dart';

//ignore: must_be_immutable
class HomeUser extends StatefulWidget {
  late Habitacion habitacion;

  @override
  _HomeUserState createState() => _HomeUserState();
}
//Referencia a la tabla firebase

class _HomeUserState extends State<HomeUser> {
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
          statusBarColor: new Color.fromRGBO(119, 172, 241, 1),
          statusBarIconBrightness: Brightness.light,
        ),
        title: Text('Inicio'),
        backgroundColor: new Color.fromRGBO(119, 172, 241, 1),
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
                              color: new Color.fromRGBO(119, 172, 241, 1),
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
        backgroundColor: new Color.fromRGBO(119, 172, 241, 1),
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
        color: new Color.fromRGBO(139, 189, 255, 1),
        child: new ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("SpootSmart", style: TextStyle(fontSize: 24)),
              // accountEmail: Text("usuario@gmail.com"),
              currentAccountPicture: Container(
                child: Container(
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/logoPequeno.png"),
                    backgroundColor: new Color.fromRGBO(119, 172, 241, 1),
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: new Color.fromRGBO(139, 189, 255, 1),
              ),
              accountEmail: null,
            ),
            ListTile(
                title: Text('Inicio', style: TextStyle(color: Colors.white)),
                leading: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                onTap: () => home(context)),
            Divider(color: Colors.white),
            ListTile(
                title: Text('Alta de Habitación',
                    style: TextStyle(color: Colors.white)),
                leading: Icon(
                  Icons.king_bed_outlined,
                  color: Colors.white,
                ),
                onTap: () => agregarHabitacion(context)),
            ListTile(
                title: Text('Buscar', style: TextStyle(color: Colors.white)),
                leading: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onTap: () => buscarHabitacion(context)),
            Divider(color: Colors.white),
            ListTile(
                title: Text('Habitaciones Activas',
                    style: TextStyle(color: Colors.white)),
                leading: Icon(
                  Icons.check,
                  color: Colors.white,
                ),
                onTap: () => activosHabitacion(context)),
            ListTile(
                title: Text('Habitaciones Inactivas',
                    style: TextStyle(color: Colors.white)),
                leading: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onTap: () => inactivosHabitacion(context)),
            Divider(color: Colors.white),
            ListTile(
                title: Text('Créditos', style: TextStyle(color: Colors.white)),
                leading: Icon(
                  Icons.info_outline,
                  color: Colors.white,
                ),
                onTap: () => creditos(context)),
            Divider(color: Colors.white),
            ListTile(
                title: Text('Realidad Aumentada',
                    style: TextStyle(color: Colors.white)),
                leading: Icon(
                  Icons.check,
                  color: Colors.white,
                ),
                onTap: () => realidadAumentada(context)),
            Divider(color: Colors.white),
            ListTile(
                title: Text('Cerrar Sesión',
                    style: TextStyle(color: Colors.white)),
                leading: Icon(
                  Icons.subdirectory_arrow_left_outlined,
                  color: Colors.white,
                ),
                onTap: () => loginScreen(context)),
          ],
        ),
      )),
    );
  }

  void home(BuildContext context) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomeUser()));
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
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ListViewProductUser()));
  }

  void inactivosHabitacion(BuildContext context) async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ListViewProductInUser()));
  }

  void creditos(BuildContext context) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => Creditos()));
  }

  void realidadAumentada(BuildContext context) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => Realidad()));
  }

  void loginScreen(BuildContext context) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
