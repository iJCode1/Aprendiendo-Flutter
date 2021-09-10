import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_evaluacion_practica1/screens/Authentication/authentication.dart';
import 'package:flutter_evaluacion_practica1/src/app.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    if(user !=null){
      return MyApp();
    }else{
      return Authentication();
    }
  }
}