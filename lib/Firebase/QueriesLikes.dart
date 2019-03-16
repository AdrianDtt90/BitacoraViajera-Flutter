import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sandbox_flutter/Entities/Likes.dart';

Future<dynamic> getLikes() async {
  return Firestore.instance.collection('likes').getDocuments();

  //La forma de obtener el array de documentos:
  // getLikes().then((result) {
  //   --Recorremos los documentos
  //   result.documents.forEach((document) {
  //       document.data['apellido'];
  //   });
  // });
}

Future<Likes> getLikesById(String idLikes) async {
  return Firestore.instance
      .collection('likes')
      .document(idLikes)
      .get()
      .then((like) {
    return new Likes.fromJson(like.data);
  });
}

Future<List<Likes>> getLikesByIdPost(String idPost) async {
  return Firestore.instance
      .collection('likes')
      .where("idPost", isEqualTo: idPost)
      .getDocuments()
      .then((result) async {
    List<Likes> listaLikes = new List();

    for (var document in result.documents) {
      var like = await Likes.getLike(document.data['idLike']);
      listaLikes.add(like);
    }

    return listaLikes;
  }).catchError((e) {
    return null;
  });
}

Future<Likes> insertLikes(Likes like) {
  DocumentReference _skillsRef =
      Firestore.instance.collection('likes').document(like.idLike);

  return _skillsRef.setData(like.toJson()).then((result) {
    like.idLike = _skillsRef.documentID;
    return like;
  });
}

Future<Likes> updateLikes(Likes like) async {
  return Firestore.instance
      .collection('likes')
      .document(like.idLike)
      .updateData(like.toJson())
      .then((result) {
    return like;
  });
}

Future<Likes> deleteLikes(Likes like) async {
  return Firestore.instance
      .collection('likes')
      .document(like.idLike)
      .delete()
      .then((result) {
    return like;
  });
}

Future<bool> deleteLikeById(String idPost, String uidUser) async {
  return Firestore.instance
      .collection('likes')
      .where("idPost", isEqualTo: idPost)
      .where("uidUser", isEqualTo: uidUser)
      .getDocuments()
      .then((result) {
    for (DocumentSnapshot ds in result.documents) {
      ds.reference.delete();
    }
    return true;
  }).catchError((e) {
    return false;
  });
}

// Future<Likes> updateLikessByCondition(String idLikes) async {
//   return Firestore.instance
//       .collection('likes')
//       .where('apellido', isEqualTo: 'dotta')
//       .getDocuments()
//       .then((result) {
//     result.documents.forEach((document) {
//       updateLikes(document.documentID);
//     });
//   });
// }
