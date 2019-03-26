import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sandbox_flutter/Firebase/QueriesPosts.dart';
import 'package:sandbox_flutter/Entities/Images.dart';
import 'package:sandbox_flutter/Entities/Maps.dart';

class Posts {
  String titulo;
  String descripcion;
  String fecha;
  int timestamp;
  String idPost;
  String uidUser;
  String nombreMapa;
  double latitud;
  double longitud;
  List<String> adjuntos;

  Posts(this.idPost, this.titulo, this.descripcion, this.fecha, this.timestamp, this.uidUser,
      this.nombreMapa, this.latitud, this.longitud, this.adjuntos);

  Future<Posts> update() {
    return updatePosts(this);
  }

  //Statics
  static Future<Posts> create(Map<String, dynamic> user) {
    Posts nuevoPosts = new Posts(
        user['idPost'],
        user['titulo'],
        user['descripcion'],
        user['fecha'],
        user['timestamp'],
        user['uidUser'],
        user['nombreMapa'],
        user['latitud'],
        user['longitud'],
        user['adjuntos']);

    //Guardamos adjuntos
    if (user['adjuntos'] != null && user['adjuntos'].length > 0) {
      user['adjuntos'].forEach((urlImg) async {

        try {
          await Images.create({
            "idImage": "idImage_${new DateTime.now().millisecondsSinceEpoch}",
            "uidUser": user['uidUser'],
            "src": urlImg
          });
        } catch (e) {}
      });
    }

    //Guardamos mapas
    if (user['nombreMapa'] != null &&
        user['latitud'] != null &&
        user['longitud'] != null) {
      
      () async {
        try {
          await Maps.create({
            "idMap": "idMap_${new DateTime.now().millisecondsSinceEpoch}",
            "uidUser": user['uidUser'],
            "text": user['nombreMapa'],
            "lat": user['latitud'],
            "lon": user['longitud']
          });
        } catch (e) {}
      }();
    }

    return insertPosts(nuevoPosts);
  }

  static Future<bool> deletePost(String idPost) {
    return deletePosts(idPost);
  }

  static Future<dynamic> allPosts([int pagina = 1, int lote = 5, Map<String, dynamic> filters]) {
      return getPosts(pagina, lote, filters);
  }

  static Stream<QuerySnapshot> onFireStoreChange () {
    return getPostsListener();
  }

  //Json configuration
  Posts.fromJson(Map<String, dynamic> json)
      : idPost = json['idPost'],
        titulo = json['titulo'],
        descripcion = json['descripcion'],
        fecha = json['fecha'],
        timestamp = json['timestamp'],
        uidUser = json['uidUser'],
        nombreMapa = json['nombreMapa'],
        latitud = json['latitud'],
        longitud = json['longitud'],
        adjuntos = json['adjuntos'];

  Map<String, dynamic> toJson() => {
        'idPost': idPost,
        'titulo': titulo,
        'descripcion': descripcion,
        'fecha': fecha,
        'timestamp': timestamp,
        'uidUser': uidUser,
        'nombreMapa': nombreMapa,
        'latitud': latitud,
        'longitud': longitud,
        'adjuntos': adjuntos,
      };
}
