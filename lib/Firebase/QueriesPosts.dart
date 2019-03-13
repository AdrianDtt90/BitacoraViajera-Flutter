import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sandbox_flutter/Entities/Posts.dart';
import 'package:sandbox_flutter/Entities/Users.dart';

Future<dynamic> getPosts() async {
  return Firestore.instance.collection('posts').getDocuments().then((result) async {
    
    List<DocumentSnapshot> listaPost = new List();
    //--Recorremos los documentos

    for (var document in result.documents) {
      //document.data['apellido'];
        if(document.data['uidUser'] != null) {
          var user = await Users.getUser(document.data['uidUser']);
          document.data['user'] = user;  
        }
        listaPost.add(document);
    }
        

    return listaPost;
  });

  //La forma de obtener el array de documentos:
  // getPosts().then((result) {
  //   --Recorremos los documentos
  //   result.documents.forEach((document) {
  //       document.data['apellido'];
  //   });
  // });
}

Future<Posts> getPostsById(String idPosts) async {
  return Firestore.instance.collection('posts').document(idPosts).get()
  .then((post) {
    return new Posts.fromJson(post.data);
  });
}

Future<Posts> insertPosts(Posts post) {
  DocumentReference _skillsRef = Firestore.instance.collection('posts').document(post.idPost);

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
  return Firestore.instance.collection('posts').document(post.idPost).delete()
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
