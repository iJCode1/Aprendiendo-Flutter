import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spootsmart/src/services/authentication.dart';
import 'package:spootsmart/src/ui/home_admin.dart';

class AltaUsuario extends StatefulWidget {
  @override
  _AltaUsuarioState createState() => _AltaUsuarioState();
}

class _AltaUsuarioState extends State<AltaUsuario> {
  String? _email;
  String? _password;
  String? user;
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

  Widget _buildEmailTF() {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15),
      child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          controller: _emailController,
          style: TextStyle(fontFamily: 'Lato'),
          validator: (val) =>
              val!.isNotEmpty ? null : 'Ingresa un correo electronico',
          decoration: InputDecoration(
            hintText: "Correo Electronico",
            prefixIcon: Icon(Icons.mail),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onChanged: (value) {
            _email = value;
          }),
    );
  }

  Widget _buildPasswordTF() {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15),
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
          onChanged: (value) {
            _password = value;
          }),
    );
  }

  Widget _buildCreateUserBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 15),
      width: double.infinity,
      // ignore: deprecated_member_use
      child: RaisedButton(
        elevation: 5.0,
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: new Color.fromRGBO(255, 116, 116, 1),
        child: Text(
          'Registrar',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
        onPressed: () async {
          user = await Authentication()
              .createUserWithEmailAndPassword(_email!, _password!);
          if (user != null) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: new Text("Registrado"),
                    content: new Text("El usuario ha sido registrado"),
                    actions: <Widget>[
                      // ignore: deprecated_member_use
                      new FlatButton(
                        child: new Text("Ok"),
                        onPressed: () {
                          Navigator.of(context).pop();
                          _verVentanaAdmin(context);
                        },
                      )
                    ],
                  );
                });
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: new Text("Error al registrar"),
                    content: new Text("Intentelo de nuevo"),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: new Color.fromRGBO(255, 116, 116, 1),
          statusBarIconBrightness: Brightness.light,
        ),
        title: Text('Alta Usuario'),
        backgroundColor: Color.fromRGBO(255, 116, 116, 1),
      ),
      body: SingleChildScrollView(
        // padding: const EdgeInsets.all(20.0),
        child: Form(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ClipPath(
                  clipper: MyClipper(),
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: new Color.fromRGBO(255, 116, 116, 1),
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
                          ),
                          Text(
                            "Crear Usuarios",
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
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.only(top: 40, bottom: 30),
                  child: Center(
                    child: Image(
                        width: 120,
                        // image: NetworkImage('https://firebasestorage.googleapis.com/v0/b/flutter-evaluacion-practica1.appspot.com/o/imagenes%2FpastelPNG.png?alt=media&token=0266e067-dfa4-4203-8b7b-18e419f929db'),
                        image: AssetImage("assets/logoHome.png")),
                  ),
                ),
                SizedBox(height: 0.0),
                Container(
                  padding: EdgeInsets.only(left: 30, right: 30),
                  child: Column(
                    children: [
                      _buildEmailTF(),
                      SizedBox(
                        height: 30,
                      ),
                      _buildPasswordTF(),
                      _buildCreateUserBtn(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
