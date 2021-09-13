import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_evaluacion_practica1/src/model/pastel.dart';
import 'package:firebase_database/firebase_database.dart';

class Buscar extends StatefulWidget {
  final Pastel pastel;
  Buscar(this.pastel);

  @override
  _Buscar createState() => _Buscar();
}

//Referencia a la tabla firebase
final pastelRef = FirebaseDatabase.instance.reference().child('pastel');
final pastelRefActivo =
    FirebaseDatabase.instance.reference().child('pastel').child('paginas');
//final pastelRefInactivo = FirebaseDatabase.instance.reference().child('pastel').child('inactivo');
String? articulo = "";
String? descripcion;
String? fecha;
DataSnapshot? snapshot;
late List<dynamic> valores;

class _Buscar extends State<Buscar> {
  late TextEditingController articuloController;
  late List<Pastel> items;
    @override
  void initState(){
    articuloController = new TextEditingController(text:widget.pastel.articulo);
    // descripcionController = new TextEditingController(text:widget.pastel.descripcion);
    // precioController = new TextEditingController(text:widget.pastel.precio);
    // fechaController = (widget.pastel.fecha)!;
    // contactoController = new TextEditingController(text:widget.pastel.contacto);
    // latitudeController = (widget.pastel.latitude);
    // longitudeController = (widget.pastel.longitude);
    // fotoController = (widget.pastel.foto);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Información Pastel'),
          backgroundColor: new Color.fromRGBO(48, 71, 94, 1),
          backwardsCompatibility: false,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: new Color.fromRGBO(48, 71, 94, 1),
            statusBarIconBrightness: Brightness.light,
          ),
        ),
        body: SingleChildScrollView(
          //height: 400.0,
          padding: const EdgeInsets.all(20.0),
          child: Card(
            child: Center(
                child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: TextField(
                    controller: articuloController,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                    decoration: InputDecoration(
                        icon: Icon(Icons.cake,
                            color: new Color.fromRGBO(48, 71, 94, 1)),
                        labelText: 'Articulo'),
                    keyboardType: TextInputType.text,
                  ),
                ),
                new Text(
                    // "Nombre: ${widget.pastel.articulo}",
                    articulo!.length > 0 ? "Nombre: $articulo" : "",
                    // "Nombre: $articulo",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
                Padding(padding: EdgeInsets.only(top: 8.0)),
                Divider(),
                // ignore: deprecated_member_use
                RaisedButton(
                  //onPressed: () => _buscarPastel('-MjJFv9kKKQyLDKHfV_V'),
                  onPressed: () => _buscarPastel(articuloController.text),
                  child: Text(
                    'Traer datos',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  color: Colors.blue,
                )
              ],
            )),
          ),
        ));
  }

  _buscarPastel(String id) async {
    await pastelRef.child(id).once().then((DataSnapshot dataSnapshot) => {
          //print(dataSnapshot),
          //print(dataSnapshot.value),
          //print(dataSnapshot.value.values),
          valores = [...dataSnapshot.value.values],
          print(valores[0]),
          articulo = valores[0]
        });
  }
}

//print(dataSnapshot.value.entries.elementAt(0).value)
