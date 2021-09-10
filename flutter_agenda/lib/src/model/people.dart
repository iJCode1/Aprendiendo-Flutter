import 'package:firebase_database/firebase_database.dart' show DataSnapshot;

class Persona{
  String? id;
  String? nombre;
  String? apellido;
  String? edad;
  String? tel;
  String? dir;
  String? mail;

  Persona (this.id, this.nombre, this.apellido, this.edad, this.tel, this.dir, this.mail);

  Persona.map(dynamic obj){
    this.nombre = obj['nombre'];
    this.apellido = obj['apellido'];
    this.edad = obj['edad'];
    this.tel = obj['tel'];
    this.dir = obj['dir'];
    this.mail = obj['mail'];
  }

  String? get getID => id;
  String? get getNombre => nombre;
  String? get getApellido => apellido;
  String? get getEdad => edad;
  String? get getTel => tel;
  String? get getDireccion => dir;
  String? get getMail => mail;

  Persona.fromSnapshot(DataSnapshot snapshot){
    id = snapshot.key;
    nombre = snapshot.value['nombre'];
    apellido = snapshot.value['apellido'];
    edad = snapshot.value['edad'];
    tel = snapshot.value['tel'];
    dir = snapshot.value['dir'];
    mail = snapshot.value['mail'];
  }
}
