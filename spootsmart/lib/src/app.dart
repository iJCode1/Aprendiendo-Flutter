import 'package:flutter/material.dart';
import 'package:spootsmart/src/ui/login_screen.dart';
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Center(child: LoginScreen(),
      ),
    );
  }
}