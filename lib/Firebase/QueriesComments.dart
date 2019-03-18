import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sandbox_flutter/Entities/Comments.dart';

Future<dynamic> getComments() async {
  return Firestore.instance.collection('comments').getDocuments();

  //La forma de obtener el array de documentos:
  // getComments().then((result) {
  //   --Recorremos los documentos
  //   result.documents.forEach((document) {
  //       document.data['apellido'];
  //   });
  // });
}

Stream<QuerySnapshot> getCommentsListener () {
  return Firestore.instance.collection('comments').reference().snapshots();
}

Future<Comments> getCommentsById(String idComments) async {
  return Firestore.instance
      .collection('comments')
      .document(idComments)
      .get()
      .then((comment) {
    return new Comments.fromJson(comment.data);
  });
}

Future<List<Comments>> getCommentsByIdPost(String idPost) async {
  return Firestore.instance
      .collection('comments')
      .where("idPost", isEqualTo: idPost)
      .getDocuments()
      .then((result) async {
    List<Comments> listaComments = new List();

    for (var document in result.documents) {
      var comment = await Comments.getComment(document.data['idComment']);
      listaComments.add(comment);
    }

    return listaComments;
  });
}

Future<Comments> insertComments(Comments comment) {
  DocumentReference _skillsRef =
      Firestore.instance.collection('comments').document(comment.idComment);

  return _skillsRef.setData(comment.toJson()).then((result) {
    comment.idComment = _skillsRef.documentID;
    return comment;
  });
}

Future<Comments> updateComments(Comments comment) async {
  return Firestore.instance
      .collection('comments')
      .document(comment.idComment)
      .updateData(comment.toJson())
      .then((result) {
    return comment;
  });
}

Future<Comments> deleteComments(Comments comment) async {
  return Firestore.instance
      .collection('comments')
      .document(comment.idComment)
      .delete()
      .then((result) {
    return comment;
  });
}

// Future<Comments> updateCommentssByCondition(String idComments) async {
//   return Firestore.instance
//       .collection('comments')
//       .where('apellido', isEqualTo: 'dotta')
//       .getDocuments()
//       .then((result) {
//     result.documents.forEach((document) {
//       updateComments(document.documentID);
//     });
//   });
// }
