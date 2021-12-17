
import 'package:firebase_database/firebase_database.dart';

class Habitacion{
  String? id;
  String? nombre;
  String? fecha;
  // String? imagen;
  String? latitud;
  String? longitud;
  String? status;
  late String? foto;

  Habitacion(this.id, this.nombre, this.fecha, this.latitud, this.longitud, this.status, this.foto);
  //Mapeo para estructurar los datos
  Habitacion.map(dynamic obj){
    this.nombre = obj['nombre'];
    this.fecha = obj['fecha'];
    // this.imagen = obj['imagen'];
    this.latitud = obj['latitud'];
    this.longitud = obj['longitud'];
    this.status = obj['status'];
    this.foto = obj['foto'];
  }
  //Getters de las variables
  String? get getId => id;
  String? get getNombre => nombre;
  String? get getFecha => fecha;
  // String? get getImagen => imagen;
  String? get getLatitud => latitud;
  String? get getLongitud => longitud;
  String? get getStatus => status;
  String? get getFoto => foto;

  //crear tabla en firebase
  Habitacion.fromSnapShot(DataSnapshot snapshot){
    id = snapshot.key;
    nombre = snapshot.value['nombre'];
    fecha = snapshot.value['fecha'];
    // imagen = snapshot.value['imagen'];
    latitud = snapshot.value['latitud'];
    longitud = snapshot.value['longitud'];
    status = snapshot.value['status'];
    foto = snapshot.value['foto'];
  }
}