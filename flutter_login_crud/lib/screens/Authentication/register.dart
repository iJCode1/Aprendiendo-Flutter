import 'package:flutter/material.dart';
import 'package:flutter_login_crud/services/authentication_services/auth_services.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {

  final Function toggleScreen;

  Register({Key? key, required this.toggleScreen}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  //Agregue modificado late
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
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
    final loginProvider = Provider.of<AuthServices>(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formkey,
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
                  // SizedBox(height: 60,),
                  SizedBox(height: 90,),
                  Text(
                    "Bienvenido!",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text(
                    "Crear una cuenta",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  // ++++++++++++++++++++ Input de Correo electronico ++++++++++++++++++++
                  SizedBox(height: 30,),
                  TextFormField(
                    controller: _emailController,
                    validator: (val) => val!.isNotEmpty ? null : 'Ingresa un correo electronico',
                    decoration: InputDecoration(
                      hintText: "Correo Electronico",
                      prefixIcon: Icon(Icons.mail),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),// ++++++++++++++++++++ Input de Contraseña ++++++++++++++++++++
                  SizedBox(height: 30,),
                  TextFormField(
                    controller: _passwordController,
                    validator: (val) => val!.length < 6 ? 'Ingresa una contraseña de 6 o más caracteres' : null,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Contraseña",
                      prefixIcon: Icon(Icons.vpn_key),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),// ++++++++++++++++++++ Input de Correo electronico ++++++++++++++++++++
                  SizedBox(height: 30,),
                  MaterialButton(
                    onPressed: () async{
                      if( _formkey.currentState!.validate()){
                        print("Correo: ${_emailController.text}");
                        print("Contraseña: ${_passwordController.text}");
                        await loginProvider.register(
                          _emailController.text.trim(), 
                          _passwordController.text.trim(),
                        );
                      }
                    },
                    height: 70,
                    minWidth: loginProvider.isLoading ? null : double.infinity,
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: loginProvider.isLoading 
                      ? CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                      ) 
                      : Text(
                          "Registrarse",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Ya tienes una cuenta ?"),
                      SizedBox(width: 5),
                      TextButton(
                        onPressed: ()=> widget.toggleScreen(), 
                        child: Text("Acceder"),
                      )
                    ],
                  ),
                  SizedBox(height: 20,),
                  if(loginProvider.errorMessage != null)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    color: Colors.amberAccent,
                    child: ListTile(
                      title: Text(loginProvider.errorMessage.toString()),
                      leading: Icon(Icons.error),
                      trailing: IconButton(
                        onPressed: ()=> loginProvider.setMessage(null),
                        icon: Icon(Icons.close)
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}