import 'package:sandbox_flutter/Firebase/Queries.dart';

class Persona {
  String idPersona;
  String nombre;
  String apellido;
  int edad;

  Persona(this.idPersona, this.nombre, this.apellido, this.edad);

  Future<Persona> update () {
    return updatePersona(this);
  }

  Future<Persona> delete () {
    return deletePersona(this);
  }

  //Statics
  static Future<Persona> create (String nombre, String apellido, int edad) {
    Persona nuevaPersona = new Persona('', nombre, apellido, edad); //idPersona lo setea Firebase
    return insertPersona(nuevaPersona);
  }

  static Future<dynamic> allPersonas () {
    return getPersonas();
  }

  //Json configuration
  Persona.fromJson(Map<String, dynamic> json)
      : idPersona = json['idPersona'],
        nombre = json['nombre'],
        apellido = json['apellido'],
        edad = json['edad'];

  Map<String, dynamic> toJson() =>
    {
      'idPersona': idPersona,
      'nombre': nombre,
      'apellido': apellido,
      'edad': edad,
    };
}