import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthServices with ChangeNotifier {
  late bool _isLoading = false;
  String? _errorMessage;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future register(String email, String password) async {
    setLoading(true);
    try {
      UserCredential authResult = await firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
      late User? user = authResult.user;
      setLoading(false);
      return user;
    } on SocketException{
      setLoading(false);
      setMessage("Revise su conexión a intenet");
    }on FirebaseAuthException catch (e) {
      if(e.code == 'email-already-in-use'){
        setMessage("El correo ya se ha registrado previamente");
      }

      if(e.code == 'invalid-email'){
        setMessage("El formato del correo es incorrecto");
      }
      print(e.code);
      setLoading(false);
    }
    notifyListeners();
  }

  Future login(String email, String password) async {
    setLoading(true);
    try {
      UserCredential authResult = await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
      User? user = authResult.user;
      setLoading(false);
      return user;
    } on SocketException{
      setLoading(false);
      setMessage("Revise su conexión a intenet");
    }on FirebaseAuthException catch (e) {
      if(e.code == 'user-not-found'){
        setMessage("El correo no se encuentra en la BD");
      }
      if(e.code == 'wrong-password'){
        setMessage("La contraseña es incorrecta");
      }
      if(e.code == 'too-many-requests'){
        setMessage("Se han hecho muchas solicitudes de acceso");
      }
      setLoading(false);
      print(e.code);
    }
    notifyListeners();
  }

  Future logout() async{
    await firebaseAuth.signOut();
  }

  void setLoading(val) {
    _isLoading = val;
    notifyListeners();
  }

  void setMessage(message) {
    _errorMessage = message;
    notifyListeners();
  }

  Stream<User?> get user => firebaseAuth.authStateChanges().map((event) => event);
}
