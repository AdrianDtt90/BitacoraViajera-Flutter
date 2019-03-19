import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sandbox_flutter/Entities/Posts.dart';
import 'package:sandbox_flutter/Entities/Users.dart';
import 'package:sandbox_flutter/MyFunctionalities/MyFunctions.dart';

Future<dynamic> getPosts([int pagina = 1, int lote = 5]) async {
  if (pagina <= 0 || lote <= 0) return null;

  var first = null;

  if (pagina - 1 == 0) {
    first = Firestore.instance
        .collection("posts")
        .orderBy("fecha")
        .limit(lote)
        .getDocuments();
  } else {
    first = Firestore.instance
        .collection("posts")
        .orderBy("fecha")
        .limit(lote * (pagina - 1))
        .getDocuments();
  }

  return first.then((documentSnapshots) {
    if (documentSnapshots.documents.length > lote || pagina > 1) {
      // Conseguimos los siguientes
      var lastVisible =
          documentSnapshots.documents[documentSnapshots.documents.length - 1];

      return Firestore.instance
          .collection("posts")
          .orderBy("fecha")
          .startAfter([lastVisible.data['fecha']])
          .limit(lote)
          .getDocuments()
          .then((documentSnapshots) {
            return addUserToResult(documentSnapshots);
          });
    } else {
      return addUserToResult(documentSnapshots);
    }
  });

  //La forma de obtener el array de documentos:
  // getPosts().then((result) {
  //   --Recorremos los documentos
  //   result.documents.forEach((document) {
  //       document.data['apellido'];
  //   });
  // });
}

Future<dynamic> getPostsFilters(Map<String, dynamic> filters) async {
  var first = null;

  first =
      Firestore.instance.collection("posts").orderBy("fecha").getDocuments();

  return first.then((documentSnapshots) {
    return addUserToResult(documentSnapshots, filters);
  });

  //La forma de obtener el array de documentos:
  // getPosts().then((result) {
  //   --Recorremos los documentos
  //   result.documents.forEach((document) {
  //       document.data['apellido'];
  //   });
  // });
}

Future<List<DocumentSnapshot>> addUserToResult(result,
    [Map<String, dynamic> filters]) async {
  List<DocumentSnapshot> listaPost = new List();
  //--Recorremos los documentos

  for (var document in result.documents) {
    if (filters != null) {
      if (filters['monthYear'] != null) {
        DateTime date1 = DateTime.utc(
            filters['monthYear']['year'], filters['monthYear']['month'], 1);
        DateTime date2 = DateTime.utc(
            filters['monthYear']['year'], filters['monthYear']['month'] + 1, 1);

        DateTime dateData = getDateFromString(document.data['fecha']);

        if (date1.millisecondsSinceEpoch > dateData.millisecondsSinceEpoch ||
            date2.millisecondsSinceEpoch <= dateData.millisecondsSinceEpoch)
          continue;
      }
    }
    //document.data['apellido'];
    if (document.data['uidUser'] != null) {
      var user = await Users.getUser(document.data['uidUser']);
      document.data['user'] = user;
    }
    listaPost.add(document);
  }

  return listaPost;
}

Stream<QuerySnapshot> getPostsListener() {
  return Firestore.instance.collection('posts').reference().snapshots();
}

Future<Posts> getPostsById(String idPosts) async {
  return Firestore.instance
      .collection('posts')
      .document(idPosts)
      .get()
      .then((post) {
    return new Posts.fromJson(post.data);
  });
}

Future<Posts> insertPosts(Posts post) {
  DocumentReference _skillsRef =
      Firestore.instance.collection('posts').document(post.idPost);

  return _skillsRef.setData(post.toJson()).then((result) {
    post.idPost = _skillsRef.documentID;
    return post;
  });
}

Future<Posts> updatePosts(Posts post) async {
  return Firestore.instance
      .collection('posts')
      .document(post.idPost)
      .updateData(post.toJson())
      .then((result) {
    return post;
  });
}

Future<Posts> deletePosts(Posts post) async {
  return Firestore.instance
      .collection('posts')
      .document(post.idPost)
      .delete()
      .then((result) {
    return post;
  });
}

// Future<Posts> updatePostsByCondition(String idPosts) async {
//   return Firestore.instance
//       .collection('posts')
//       .where('apellido', isEqualTo: 'dotta')
//       .getDocuments()
//       .then((result) {
//     result.documents.forEach((document) {
//       updatePosts(document.documentID);
//     });
//   });
// }
