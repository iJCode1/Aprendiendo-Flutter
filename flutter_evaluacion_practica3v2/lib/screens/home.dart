import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_evaluacion_practica3v2/screens/navigation_drawer.dart';

import 'dart:async';
import 'package:video_player/video_player.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  VideoPlayerController? _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    _controller = VideoPlayerController.network(
      'https://firebasestorage.googleapis.com/v0/b/flutter-evaluacion-practica1.appspot.com/o/imagenes%2FAppEvaluacion1.mp4?alt=media&token=581cf59a-07e9-4e8e-92df-bfcf484e3375',
    );

    // Inicializa el controlador y almacena el Future para utilizarlo luego
    _initializeVideoPlayerFuture = _controller!.initialize();

    // Usa el controlador para hacer un bucle en el vídeo
    _controller!.setLooping(true);

    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inicio',
      home: Scaffold(
        drawer: NavigationDrawerWidget(),
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backwardsCompatibility: false,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.orange,
            statusBarIconBrightness: Brightness.light,
          ),
          title: Text("Inicio"),
          backgroundColor: Colors.orange,
          actions: [
            // IconButton(
            //     onPressed: () async => await loginProvider.logout(),
            //     icon: Icon(Icons.exit_to_app)),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Center(
                  child: Container(
                    padding: EdgeInsets.only(top: 30, bottom: 15),
                    child: Center(
                      child: Text(
                        'Evaluación Práctica 3 - BOB_RA',
                        style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 80, left: 20, right: 20),
                  child: FutureBuilder(
                    future: _initializeVideoPlayerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        // Si el VideoPlayerController ha finalizado la inicialización, usa
                        // los datos que proporciona para limitar la relación de aspecto del VideoPlayer
                        return AspectRatio(
                          aspectRatio: _controller!.value.aspectRatio,
                          // Usa el Widget VideoPlayer para mostrar el vídeo
                          child: VideoPlayer(_controller!),
                        );
                      } else {
                        // Si el VideoPlayerController todavía se está inicializando, muestra un
                        // spinner de carga
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.orange,
          onPressed: () {
            // Envuelve la reproducción o pausa en una llamada a `setState`. Esto asegura
            // que se muestra el icono correcto
            setState(() {
              // Si el vídeo se está reproduciendo, pausalo.
              if (_controller!.value.isPlaying) {
                _controller!.pause();
              } else {
                // Si el vídeo está pausado, reprodúcelo
                _controller!.play();
              }
            });
          },
          // Muestra el icono correcto dependiendo del estado del vídeo.
          child: Icon(
            _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ), // Esta coma final hace que el formateo automático sea mejor para los métodos de compilación.
      ),
    );
  }
}
