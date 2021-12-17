import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spootsmart/src/services/authentication.dart';
import 'package:spootsmart/src/ui/home_admin.dart';
import 'package:spootsmart/src/ui/home_user.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: new Color.fromRGBO(119, 172, 241, 1),
          statusBarIconBrightness: Brightness.light,
        ),
        backgroundColor: new Color.fromRGBO(119, 172, 241, 1),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // IconButton(
                  //   onPressed: (){},
                  //   icon: Icon(
                  //     Icons.arrow_back_ios,
                  //     color: Theme.of(context).primaryColor,
                  //   ),
                  // ),
                  //SizedBox(height: 60,),
                  // Container(
                  //   padding: EdgeInsets.only(
                  //     left: 20.0,
                  //     right: 20.0,
                  //     bottom: 36 + 20.0,
                  //   ),
                  //   height: 200,
                  //   decoration: BoxDecoration(
                  //     color: new Color(0xFFFF7474),
                  //     borderRadius: BorderRadius.only(
                  //       bottomLeft: Radius.circular(36),
                  //       bottomRight: Radius.circular(36),
                  //     ),
                  //   ),
                  //   child: Row(
                  //     children: <Widget>[
                  //       Text(
                  //         'Hi Uishopy!',
                  //         style: Theme.of(context).textTheme.headline5!.copyWith(
                  //             color: Colors.white, fontWeight: FontWeight.bold),
                  //       ),
                  //       Spacer(),
                  //       // Image.asset("assets/images/logo.png", width: 100)
                  //     ],
                  //   ),
                  // ),
                  ClipPath(
                    clipper: MyClipper(),
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: new Color.fromRGBO(119, 172, 241, 1),
                        // borderRadius: BorderRadius.only(
                        //   bottomLeft: Radius.circular(36),
                        //   bottomRight: Radius.circular(36),
                        // ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Bienvenido!',
                              style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 38,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              // style: Theme.of(context)
                              //     .textTheme
                              //     .headline5
                              //     .copyWith(
                              //         fontSize: 38,
                              //         color: Colors.white,
                              //         fontFamily: 'Poppins',
                              //         fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Iniciar sesión",
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Lato',
                                color: new Color.fromRGBO(220, 220, 220, 1),
                              ),
                            ),
                          ],
                        ),
                        // Image.asset("assets/images/logo.png", width: 100)
                      ),
                    ),
                  ),
                  // Text(
                  //   "Bienvenido!",
                  //   style: TextStyle(
                  //     fontSize: 22,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  // SizedBox(height: 10,),
                  // Text(
                  //   "Iniciar sesión",
                  //   style: TextStyle(
                  //     fontSize: 14,
                  //     color: Colors.grey,
                  //   ),
                  // ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    child: Center(
                      child: Image(
                          width: 120,
                          // image: NetworkImage('https://firebasestorage.googleapis.com/v0/b/flutter-evaluacion-practica1.appspot.com/o/imagenes%2FpastelPNG.png?alt=media&token=0266e067-dfa4-4203-8b7b-18e419f929db'),
                          image: AssetImage("assets/logoHome.png")),
                    ),
                  ),
                  // ++++++++++++++++++++ Input de Correo electronico ++++++++++++++++++++
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 25, right: 25),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      style: TextStyle(fontFamily: 'Lato'),
                      validator: (val) => val!.isNotEmpty
                          ? null
                          : 'Ingresa un correo electronico',
                      decoration: InputDecoration(
                        hintText: "Correo Electronico",
                        prefixIcon: Icon(Icons.mail),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ), // ++++++++++++++++++++ Input de Contraseña ++++++++++++++++++++
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 25, right: 25),
                    child: TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      controller: _passwordController,
                      style: TextStyle(fontFamily: 'Lato'),
                      validator: (val) => val!.length < 6
                          ? 'Ingresa una contraseña de 6 o más caracteres'
                          : null,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Contraseña",
                        prefixIcon: Icon(Icons.vpn_key),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ), // ++++++++++++++++++++ Boton de Acceder ++++++++++++++++++++
                  SizedBox(
                    height: 30,
                  ),
                  // ignore: deprecated_member_use
                  FlatButton(
                    onPressed: () async {
                      var user = await Authentication().loginUser(
                          email: _emailController.text,
                          password: _passwordController.text);
                      if (_emailController.text == "administrador@gmail.com" &&
                          _passwordController.text == "administrador123") {
                        _verVentanaAdmin(context);
                      } else if (user != null) {
                        _verVentanaUsuario(context);
                      } else {
                        //Mensaje de error con un show dialog.
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: new Text("Error al Iniciar sesion"),
                                content:
                                    new Text("Ingrese un usuario y contrasena"),
                                actions: <Widget>[
                                  // ignore: deprecated_member_use
                                  new FlatButton(
                                    child: new Text("Cerrar"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              );
                            });
                      }
                    },
                    child: Center(
                      child: Container(
                        height: 60,
                        width: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: new Color.fromRGBO(119, 172, 241, 1),
                        ),
                        child: Center(
                            child: Text('Iniciar Sesión',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ))),
                      ),
                    ),
                    // color: new Color.fromRGBO(119, 172, 241, 1),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _verVentanaUsuario(BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeUser(),
        ));
    print("Entra a usuario");
  }

  void _verVentanaAdmin(BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeAdmin(),
        ));
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0, size.height - 90); //Bottom - Left
    var controllPoint = Offset(50, size.height);
    var endPoint = Offset(size.width / 2, size.height);
    path.quadraticBezierTo(
        controllPoint.dx, controllPoint.dy, endPoint.dx, endPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
