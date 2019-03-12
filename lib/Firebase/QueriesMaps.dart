import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sandbox_flutter/Entities/Maps.dart';

Future<dynamic> getMaps() async {
  return Firestore.instance.collection('maps').getDocuments();

  //La forma de obtener el array de documentos:
  // getMaps().then((result) {
  //   --Recorremos los documentos
  //   result.documents.forEach((document) {
  //       document.data['apellido'];
  //   });
  // });
}

Future<Maps> getMapsById(String idMap) async {
  return Firestore.instance.collection('maps').document(idMap).get()
  .then((map) {
    return new Maps.fromJson(map.data);
  });
}

Future<Maps> insertMaps(Maps map) {
  DocumentReference _skillsRef = Firestore.instance.collection('maps').document(map.idMap);

  return _skillsRef.setData(map.toJson()).then((result) {
    map.idMap = _skillsRef.documentID;
    return map;
  });
}

Future<Maps> updateMaps(Maps map) async {
  return Firestore.instance
      .collection('maps')
      .document(map.idMap)
      .updateData(map.toJson())
      .then((result) {
        return map;
      });
}

Future<Maps> deleteMaps(Maps map) async {
  return Firestore.instance.collection('maps').document(map.idMap).delete()
  .then((result) {
    return map;
  });
}

// Future<Maps> updateMapsByCondition(String idMap) async {
//   return Firestore.instance
//       .collection('maps')
//       .where('apellido', isEqualTo: 'dotta')
//       .getDocuments()
//       .then((result) {
//     result.documents.forEach((document) {
//       updateMaps(document.documentID);
//     });
//   });
// }
