import 'package:firebase_auth/firebase_auth.dart' as auth;

class Authentication {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  Future<auth.UserCredential?> loginUser({String? email = "", String? password = ""}) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email!, password: password!);
    }
    catch (e) {
      print(e);
    }
    return null;
  }

  Future<String> createUserWithEmailAndPassword(
      String email, String password) async {
        auth.UserCredential user = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return user.user!.uid;
  }
}
