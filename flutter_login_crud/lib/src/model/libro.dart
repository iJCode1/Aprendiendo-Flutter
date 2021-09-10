import 'package:firebase_database/firebase_database.dart' show DataSnapshot;

class Libro{
  String? id;
  String? nombre;
  String? autor;
  String? genero;
  String? editorial;
  String? paginas;
  late String foto;

  Libro (this.id, this.nombre, this.autor, this.genero, this.editorial, this.paginas, this.foto);

  Libro.map(dynamic obj){
    this.nombre = obj['nombre'];
    this.autor = obj['autor'];
    this.genero = obj['genero'];
    this.editorial = obj['editorial'];
    this.paginas = obj['paginas'];
    this.foto = obj['foto'];
  }

  String? get getID => id;
  String? get getNombre => nombre;
  String? get getAutor => autor;
  String? get getGenero => genero;
  String? get getEditorial => editorial;
  String? get getPaginas => paginas;
  String? get getFoto => foto;

  Libro.fromSnapshot(DataSnapshot snapshot){
    id = snapshot.key;
    nombre = snapshot.value['nombre'];
    autor = snapshot.value['autor'];
    genero = snapshot.value['genero'];
    editorial = snapshot.value['editorial'];
    paginas = snapshot.value['paginas'];
    foto = snapshot.value['foto'];
  }
}
