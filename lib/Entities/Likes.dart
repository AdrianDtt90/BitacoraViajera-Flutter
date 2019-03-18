import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sandbox_flutter/Firebase/QueriesLikes.dart';

class Likes {
  String idLike;
  String uidUser;
  String displayName;
  String photoUrl;
  String idPost;


  Likes(this.idLike,
  this.uidUser,
  this.displayName,
  this.photoUrl,
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
    like['displayName'],
    like['photoUrl'],
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
        displayName = json['displayName'],
        photoUrl = json['photoUrl'],
        idPost = json['idPost'];

  Map<String, dynamic> toJson() =>
    {
      'idLike': idLike,
      'uidUser': uidUser,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'idPost': idPost,
    };
}