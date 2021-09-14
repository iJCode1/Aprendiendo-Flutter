import 'package:firebase_database/firebase_database.dart' show DataSnapshot;

class Pastel{
  String? id;
  String? articulo;
  String? descripcion;
  String? precio;
  String? fecha;
  String? status;
  String? contacto;
  late double latitude;
  late double longitude;
  late String foto;

  Pastel (this.id, this.articulo, this.descripcion, this.precio, this.fecha, this.contacto, this.latitude, this.longitude, this.foto);

  Pastel.map(dynamic obj){
    this.articulo = obj['articulo'];
    this.descripcion = obj['descripcion'];
    this.precio = obj['precio'];
    this.fecha = obj['fecha'];
    this.status = obj['status'];
    this.contacto = obj['contacto'];
    this.latitude = obj['latitude'];
    this.longitude = obj['longitude'];
    this.foto = obj['foto'];
  }

  String? get getID => id;
  String? get getArticulo => articulo;
  String? get getDescripcion => descripcion;
  String? get getPrecio => precio;
  String? get getFecha => fecha;
  String? get getStatus => status;
  String? get getContacto => contacto;
  double? get getLatitude => latitude;
  double? get getLongitude => longitude;
  String? get getFoto => foto;

  Pastel.fromSnapshot(DataSnapshot snapshot){
    id = snapshot.key;
    articulo = snapshot.value['articulo'];
    descripcion = snapshot.value['descripcion'];
    precio = snapshot.value['precio'];
    fecha = snapshot.value['fecha'];
    status = snapshot.value['status'];
    contacto = snapshot.value['contacto'];
    latitude = snapshot.value['latitude'];
    longitude = snapshot.value['longitude'];
    foto = snapshot.value['foto'];
  }
}
