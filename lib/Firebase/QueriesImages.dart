import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sandbox_flutter/Entities/Images.dart';

Future<dynamic> getImages() async {
  return Firestore.instance.collection('images').getDocuments();

  //La forma de obtener el array de documentos:
  // getImages().then((result) {
  //   --Recorremos los documentos
  //   result.documents.forEach((document) {
  //       document.data['apellido'];
  //   });
  // });
}

Future<Images> getImagesById(String idImage) async {
  return Firestore.instance.collection('images').document(idImage).get()
  .then((image) {
    return new Images.fromJson(image.data);
  });
}

Future<Images> insertImages(Images image) {
  DocumentReference _skillsRef = Firestore.instance.collection('images').document(image.idImage);

  return _skillsRef.setData(image.toJson()).then((result) {
    image.idImage = _skillsRef.documentID;
    return image;
  });
}

Future<Images> updateImages(Images image) async {
  return Firestore.instance
      .collection('images')
      .document(image.idImage)
      .updateData(image.toJson())
      .then((result) {
        return image;
      });
}

Future<Images> deleteImages(Images image) async {
  return Firestore.instance.collection('images').document(image.idImage).delete()
  .then((result) {
    return image;
  });
}

// Future<Images> updateImagesByCondition(String idImage) async {
//   return Firestore.instance
//       .collection('images')
//       .where('apellido', isEqualTo: 'dotta')
//       .getDocuments()
//       .then((result) {
//     result.documents.forEach((document) {
//       updateImages(document.documentID);
//     });
//   });
// }
