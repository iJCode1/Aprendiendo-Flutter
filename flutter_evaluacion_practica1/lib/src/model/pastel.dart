import 'package:firebase_database/firebase_database.dart' show DataSnapshot;

class Pastel{
  String? id;
  String? articulo;
  String? ingredientes;
  String? creador;
  String? fecha;
  String? precio;
  late String foto;

  Pastel (this.id, this.articulo, this.ingredientes, this.creador, this.fecha, this.precio, this.foto);

  Pastel.map(dynamic obj){
    this.articulo = obj['articulo'];
    this.ingredientes = obj['ingredientes'];
    this.creador = obj['creador'];
    this.fecha = obj['fecha'];
    this.precio = obj['precio'];
    this.foto = obj['foto'];
  }

  String? get getID => id;
  String? get getArticulo => articulo;
  String? get getIngredientes => ingredientes;
  String? get getCreador => creador;
  String? get getFecha => fecha;
  String? get getPrecio => precio;
  String? get getFoto => foto;

  Pastel.fromSnapshot(DataSnapshot snapshot){
    id = snapshot.key;
    articulo = snapshot.value['articulo'];
    ingredientes = snapshot.value['ingredientes'];
    creador = snapshot.value['creador'];
    fecha = snapshot.value['fecha'];
    precio = snapshot.value['precio'];
    foto = snapshot.value['foto'];
  }
}
