import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sandbox_flutter/Firebase/QueriesSugerencias.dart';

class Sugerencias {
  String idSugerencia;
  String uidUser;
  String nombreUsuario;
  String emailUsuario;
  String sugerencia;
  String fecha;


  Sugerencias(this.idSugerencia,
  this.uidUser,
  this.nombreUsuario,
  this.emailUsuario,
  this.sugerencia,
  this.fecha);

  //Statics
  static Future<Sugerencias> create (Map<String,dynamic> sugerencia) {
    Sugerencias nuevaSugerencia = new Sugerencias(sugerencia['idSugerencia'],
    sugerencia['uidUser'],
    sugerencia['nombreUsuario'],
    sugerencia['emailUsuario'],
    sugerencia['sugerencia'],
    sugerencia['fecha']);
    return insertSugerencia(nuevaSugerencia);
  }
 
  //Json configuration
  Sugerencias.fromJson(Map<String, dynamic> json)
      : idSugerencia = json['idSugerencia'],
        uidUser = json['uidUser'],
        nombreUsuario = json['nombreUsuario'],
        emailUsuario = json['emailUsuario'],
        sugerencia = json['sugerencia'],
        fecha = json['fecha'];

  Map<String, dynamic> toJson() =>
    {
      'idSugerencia': idSugerencia,
      'uidUser': uidUser,
      'nombreUsuario': nombreUsuario,
      'emailUsuario': emailUsuario,
      'sugerencia': sugerencia,
      'fecha': fecha,
    };
}