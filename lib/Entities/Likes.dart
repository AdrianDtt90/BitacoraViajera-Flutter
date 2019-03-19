import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sandbox_flutter/Entities/Users.dart';
import 'package:sandbox_flutter/Firebase/QueriesLikes.dart';

class Likes {
  String idLike;
  String uidUser;
  Users user;
  String idPost;


  Likes(this.idLike,
  this.uidUser,
  this.user,
  this.idPost);

  Future<Likes> update () {
    return updateLikes(this);
  }

  Future<Likes> delete () {
    return deleteLikes(this);
  }

  //Statics
  static Future<Likes> create (Map<String,dynamic> like) {
    Likes nuevoLikes = new Likes(like['idLike'],
    like['uidUser'],
    like['user'],
    like['idPost']);
    return insertLikes(nuevoLikes);
  }

  static Future<Likes> getLike (String idLike) {
    return getLikesById(idLike);
  }

  static Future<List<Likes>> getPostLikes (String idPost) {
    return getLikesByIdPost(idPost);
  }

  static Future<bool> deleteLike (String idPost, String uidUser) {
    return deleteLikeById(idPost, uidUser);
  }

  static Future<dynamic> allLikess () {
    return getLikes();
  }

  static Stream<QuerySnapshot> onFireStoreChange () {
    return getLikesListener();
  }

  //Json configuration
  Likes.fromJson(Map<String, dynamic> json)
      : idLike = json['idLike'],
        uidUser = json['uidUser'],
        user = json['user'],
        idPost = json['idPost'];

  Map<String, dynamic> toJson() =>
    {
      'idLike': idLike,
      'uidUser': uidUser,
      'user': user,
      'idPost': idPost,
    };
}