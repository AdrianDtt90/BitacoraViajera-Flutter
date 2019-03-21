import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sandbox_flutter/Entities/Posts.dart';
import 'package:sandbox_flutter/Entities/Users.dart';
import 'package:sandbox_flutter/MyFunctionalities/MyFunctions.dart';

Future<dynamic> getPosts([int pagina = 1, int lote = 5, Map<String, dynamic> filters]) async {
  if (pagina <= 0 || lote <= 0) return null;

  var first = null;
  var service = Firestore.instance
        .collection("posts");

  //Filtros
  if (filters != null) {
    if (filters['monthYear'] != null) {
      int year1 = DateTime.now().year;
      int month1 = 1;
      int day1 = 1;

      int year2 = DateTime.now().year + 1;
      int month2 = 1;
      int day2 = 1;

      if(filters['monthYear']['year'] != null) {
        year1 = filters['monthYear']['year'];
        year2 = filters['monthYear']['month'] != null ? filters['monthYear']['year'] : filters['monthYear']['year'] + 1;
      }
      if(filters['monthYear']['month'] != null) {
        month1 = filters['monthYear']['month'];
        month2 = filters['monthYear']['day'] != null ? filters['monthYear']['month'] : filters['monthYear']['month'] + 1;
      }
      if(filters['monthYear']['day'] != null) {
        day1 = filters['monthYear']['day'];
        day2 = filters['monthYear']['day'] + 1;
      }

      DateTime date1 = DateTime.utc(
          year1, month1, day1);
      DateTime date2 = DateTime.utc(
          year2, month2, day2);

      first = service
      .where("timestamp", isGreaterThanOrEqualTo: date1.millisecondsSinceEpoch)
      .where("timestamp", isLessThan: date2.millisecondsSinceEpoch);
    }

    if (filters['markador'] != null) {
      first = service
      .where("latitud", isEqualTo: filters['markador']['lat'])
      .where("longitud", isEqualTo: filters['markador']['lon']);
      
      // var service = Firestore.instance
      //   .collection("posts")
      //   .where("latitud", isEqualTo: -33.865143)
      //   .getDocuments();
    }
  } else {
    first = service.orderBy("timestamp", descending: true);
  }


  return first
        .limit(pagina - 1 == 0 ? lote : lote * (pagina - 1))
        .getDocuments().then((documentSnapshots) {
    if (documentSnapshots.documents.length > lote || pagina > 1) {
      // Conseguimos los siguientes
      var lastVisible =
          documentSnapshots.documents[documentSnapshots.documents.length - 1];

      return first
          .startAfter([lastVisible.data['timestamp']])
          .limit(lote)
          .getDocuments()
          .then((documentSnapshots2) {
            return addUserToResult(documentSnapshots2);
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

Future<List<DocumentSnapshot>> addUserToResult(result) async {
  List<DocumentSnapshot> listaPost = new List();
  //--Recorremos los documentos

  for (var document in result.documents) {
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
