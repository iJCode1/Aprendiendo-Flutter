import 'package:flutter/material.dart';
import 'package:flutter_evaluacion_practica1/screens/Authentication/login.dart';
import 'package:flutter_evaluacion_practica1/screens/Authentication/register.dart';

class Authentication extends StatefulWidget {
  Authentication({Key? key}) : super(key: key);

  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  bool isToggle = false;
  void toggleScreen(){
    setState(() {
      isToggle = !isToggle;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(isToggle){
      return Register(toggleScreen: toggleScreen);
    }else{
      return Login(toggleScreen: toggleScreen);
    }
  }
}