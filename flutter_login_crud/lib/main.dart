import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_crud/screens/wrapper.dart';
import 'package:flutter_login_crud/services/authentication_services/auth_services.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _init = Firebase.initializeApp();
    return FutureBuilder(
      future: _init,
      builder: (context, snapshot){
        if(snapshot.hasError){
          return ErrorWidget();
        }else if(snapshot.hasData){
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthServices>.value(value: AuthServices()),
              StreamProvider<User?>.value(
                value: AuthServices().user,
                initialData: null,
              )
            ],
            child: MaterialApp(
              theme: ThemeData(
                primarySwatch: Colors.deepPurple,
              ),
              debugShowCheckedModeBanner: false,
              home: Wrapper(),
            ),
          );
        }else{
          return MaterialApp(home: Loading());
        }

      },
    );
  }
}


class ErrorWidget extends StatelessWidget {
  const ErrorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Column(
          children: [
            Icon(Icons.error),
            Text("Ha ocurrido un error!"),
          ],
        ),
      ),
    );
  }
}

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}