import 'package:flutter/material.dart';
import 'package:flutter_login_crud/services/authentication_services/auth_services.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<AuthServices>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Inicio"),
        actions: [
          IconButton(
            onPressed: ()async => await loginProvider.logout(),
            icon: Icon(Icons.exit_to_app)),
        ],
      ),
    );
  }
}