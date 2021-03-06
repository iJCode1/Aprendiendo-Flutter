import 'package:flutter/material.dart';
import 'package:flutter_evaluacion_practica1/screens/pages/buscar.dart';
import 'package:flutter_evaluacion_practica1/screens/pages/creditos.dart';
import 'package:flutter_evaluacion_practica1/screens/pages/user_page.dart';
import 'package:flutter_evaluacion_practica1/src/model/pastel.dart';
import 'package:flutter_evaluacion_practica1/src/ui/comprarPasteles.dart';
import 'package:flutter_evaluacion_practica1/src/ui/home.dart';
import 'package:flutter_evaluacion_practica1/src/ui/listview_activos.dart';
import 'package:flutter_evaluacion_practica1/src/ui/listview_inactivos.dart';
import 'package:flutter_evaluacion_practica1/src/ui/listview_pastel.dart';
import 'package:flutter_evaluacion_practica1/src/ui/screen_pastel.dart';

class NavigationDrawerWidget extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 20);
  @override
  Widget build(BuildContext context) {
    final name = 'Joel Dominguez';
    final email = 'Creador';
    final urlImage =
        'https://firebasestorage.googleapis.com/v0/b/flutter-evaluacion-practica1.appspot.com/o/imagenes%2Ffoto.jpeg?alt=media&token=5bc9590e-f0fb-47b6-8905-8229e705f87b';

    return Drawer(
      child: Material(
        color: new Color.fromRGBO(48, 71, 94, 1),
        child: ListView(
          children: <Widget>[
            buildHeader(
              urlImage: urlImage,
              name: name,
              email: email,
              onClicked: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => UserPage(
                  name: name,
                  urlImage: urlImage,
                ),
              )),
            ),
            Container(
              padding: padding,
              child: Column(
                children: [
                  // const SizedBox(height: 12),
                  //buildSearchField(),
                  const SizedBox(height: 10),
                  buildMenuItem(
                    text: 'Inicio',
                    icon: Icons.home,
                    onClicked: () => selectedItem(context, 0),
                  ),
                  Divider(color: Colors.white70),
                  const SizedBox(height: 10),
                  buildMenuItem(
                    text: "Altas (Vendedor)",
                    icon: Icons.cake,
                    onClicked: () => selectedItem(context, 1),
                  ),
                  const SizedBox(height: 10),
                  buildMenuItem(
                    text: "Administraci??n de Pasteles (Vendedor)",
                    icon: Icons.cake_outlined,
                    onClicked: () => selectedItem(context, 2),
                  ),
                  const SizedBox(height: 10),
                  Divider(color: Colors.white70),
                  const SizedBox(height: 10),
                  buildMenuItem(
                    text: "Comprar (Cliente)",
                    icon: Icons.shopping_cart,
                    onClicked: () => selectedItem(context, 3),
                  ),
                  const SizedBox(height: 10),
                  buildMenuItem(
                    text: 'Buscar',
                    icon: Icons.search,
                    onClicked: () => selectedItem(context, 4),
                  ),
                  Divider(color: Colors.white70),
                  const SizedBox(height: 10),
                  buildMenuItem(
                    text: 'Pasteles Activos',
                    icon: Icons.check,
                    onClicked: () => selectedItem(context, 5),
                  ),
                  const SizedBox(height: 10),
                  buildMenuItem(
                    text: 'Pasteles Inactivos',
                    icon: Icons.close,
                    onClicked: () => selectedItem(context, 6),
                  ),
                  const SizedBox(height: 10),
                  Divider(color: Colors.white70),
                  const SizedBox(height: 10),
                  buildMenuItem(
                    text: 'Cr??ditos',
                    icon: Icons.person,
                    onClicked: () => selectedItem(context, 7),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader({
    required String urlImage,
    required String name,
    required String email,
    required VoidCallback onClicked,
  }) =>
      InkWell(
        onTap: onClicked,
        child: Container(
          padding: padding.add(EdgeInsets.symmetric(vertical: 40)),
          child: Row(
            children: [
              CircleAvatar(radius: 30, backgroundImage: NetworkImage(urlImage)),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  // Widget buildSearchField() {
  //   final color = Colors.white;

  //   return TextField(
  //     style: TextStyle(color: color),
  //     decoration: InputDecoration(
  //       contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
  //       hintText: 'Search',
  //       hintStyle: TextStyle(color: color),
  //       prefixIcon: Icon(Icons.search, color: color),
  //       filled: true,
  //       fillColor: Colors.white12,
  //       enabledBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(5),
  //         borderSide: BorderSide(color: color.withOpacity(0.7)),
  //       ),
  //       focusedBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(5),
  //         borderSide: BorderSide(color: color.withOpacity(0.7)),
  //       ),
  //     ),
  //   );
  // }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.white;
    final hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();

    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Home(),
        ));
        break;
      case 1:
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) =>
                  ScreenPastel(Pastel(null, '', '', '', '', '', '', 0, 0, ''), false, "")),
        );
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ListViewPastel(),
        ));
        break;
      case 3:
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ComprarPastel(),
      ));
      break;
      case 4:
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Buscar(Pastel(null, '', '', '', '', '', '',0, 0, '')),
      ));
      break;
      case 5:
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ListViewActivos(),
      ));
      break;
      case 6:
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ListViewInactivos(),
      ));
      break;
      case 7:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => Creditos()),
        );
        break;
    }
  }
}
