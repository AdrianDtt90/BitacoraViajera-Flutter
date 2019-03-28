import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sandbox_flutter/Entities/Sugerencias.dart';


Future<Sugerencias> insertSugerencia(Sugerencias sugerencia) {
  DocumentReference _skillsRef =
      Firestore.instance.collection('sugerencias').document(sugerencia.idSugerencia);

  return _skillsRef.setData(sugerencia.toJson()).then((result) {
    sugerencia.idSugerencia = _skillsRef.documentID;
    return sugerencia;
  });
}
