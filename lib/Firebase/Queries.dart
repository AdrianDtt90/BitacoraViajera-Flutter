import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sandbox_flutter/Entities/Persona.dart';

Future<dynamic> getPersonas() async {
  return Firestore.instance.collection('personas').getDocuments();

  //La forma de obtener el array de documentos:
  // getPersonas().then((result) {
  //   --Recorremos los documentos
  //   result.documents.forEach((document) {
  //       document.data['apellido'];
  //   });
  // });
}

Future<Persona> getPersonasById(String idPersona) async {
  return Firestore.instance.collection('personas').document(idPersona).get()
  .then((persona) {
    return new Persona.fromJson(persona.data);
  });
}

Future<Persona> insertPersona(Persona persona) {
  DocumentReference _skillsRef = Firestore.instance.collection('personas').document();

  return _skillsRef.setData(persona.toJson()).then((result) {
    persona.idPersona = _skillsRef.documentID;
    return persona;
  });
}

Future<Persona> updatePersona(Persona persona) async {
  return Firestore.instance
      .collection('personas')
      .document(persona.idPersona)
      .updateData(persona.toJson())
      .then((result) {
        return persona;
      });
}

Future<Persona> deletePersona(Persona persona) async {
  return Firestore.instance.collection('personas').document(persona.idPersona).delete()
  .then((result) {
    return persona;
  });
}

// Future<Persona> updatePersonasByCondition(String idPersona) async {
//   return Firestore.instance
//       .collection('personas')
//       .where('apellido', isEqualTo: 'dotta')
//       .getDocuments()
//       .then((result) {
//     result.documents.forEach((document) {
//       updatePersona(document.documentID);
//     });
//   });
// }
