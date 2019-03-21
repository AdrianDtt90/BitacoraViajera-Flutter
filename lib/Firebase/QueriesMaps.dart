import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sandbox_flutter/Entities/Maps.dart';

Future<List<Maps>> getMaps() async {
  var servicio = Firestore.instance.collection('maps').getDocuments();

  return servicio.then((result) async {
    List<Maps> markadores = new List();

    for (var document in result.documents) {
      Maps marcador = await Maps.create({
        "idMap": document.data['idMap'],
        "text": document.data['text'],
        "lat": document.data['lat'],
        "lon": document.data['lon']
      });
      markadores.add(marcador);
    }
    return markadores;
  });
}

Future<Maps> getMapsById(String idMap) async {
  return Firestore.instance
      .collection('maps')
      .document(idMap)
      .get()
      .then((map) {
    return new Maps.fromJson(map.data);
  });
}

Future<Maps> insertMaps(Maps map) {
  DocumentReference _skillsRef =
      Firestore.instance.collection('maps').document(map.idMap);

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
  return Firestore.instance
      .collection('maps')
      .document(map.idMap)
      .delete()
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
