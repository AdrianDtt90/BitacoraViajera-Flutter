import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sandbox_flutter/Entities/Users.dart';
import 'package:sandbox_flutter/Firebase/QueriesComments.dart';

class Comments {
  String idComment;
  String uidUser;
  Users user;
  String idPost;
  String comment;
  String fecha;


  Comments(this.idComment,
  this.uidUser,
  this.user,
  this.idPost,
  this.comment,
  this.fecha);

  Future<Comments> update () {
    return updateComments(this);
  }

  Future<Comments> delete () {
    return deleteComments(this);
  }

  //Statics
  static Future<Comments> create (Map<String,dynamic> user) {
    Comments nuevoComments = new Comments(user['idComment'],
    user['uidUser'],
    user['user'],
    user['idPost'],
    user['comment'],
    user['fecha']);
    return insertComments(nuevoComments);
  }

  static Future<Comments> getComment (String idComment) {
    return getCommentsById(idComment);
  }
  
  static Future<List<Comments>> getPostComments (String idPost) {
    return getCommentsByIdPost(idPost);
  }

  static Future<dynamic> allCommentss () {
    return getComments();
  }

  static Stream<QuerySnapshot> onFireStoreChange () {
    return getCommentsListener();
  }

  //Json configuration
  Comments.fromJson(Map<String, dynamic> json)
      : idComment = json['idComment'],
        uidUser = json['uidUser'],
        user = json['user'],
        idPost = json['idPost'],
        comment = json['comment'],
        fecha = json['fecha'];

  Map<String, dynamic> toJson() =>
    {
      'idComment': idComment,
      'uidUser': uidUser,
      'user': user,
      'idPost': idPost,
      'comment': comment,
      'fecha': fecha,
    };
}