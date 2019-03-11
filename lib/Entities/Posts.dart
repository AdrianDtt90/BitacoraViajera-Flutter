import 'dart:math';

import 'package:sandbox_flutter/Firebase/QueriesPosts.dart';
import 'package:sandbox_flutter/Entities/Images.dart';

class Posts {
  String titulo;
  String descripcion;
  String fecha;
  String idPost;
  String uidUser;
  String nombreMapa;
  double latitud;
  double longitud;
  List<String> adjuntos;

  Posts(this.idPost, this.titulo, this.descripcion, this.fecha, this.uidUser,
      this.nombreMapa, this.latitud, this.longitud, this.adjuntos);

  Future<Posts> update() {
    return updatePosts(this);
  }

  Future<Posts> delete() {
    return deletePosts(this);
  }

  //Statics
  static Future<Posts> create(Map<String, dynamic> user) {
    Posts nuevoPosts = new Posts(
        user['idPost'],
        user['titulo'],
        user['descripcion'],
        user['fecha'],
        user['uidUser'],
        user['nombreMapa'],
        user['latitud'],
        user['longitud'],
        user['adjuntos']);

    if (user['adjuntos'] != null && user['adjuntos'].length > 0) {
      user['adjuntos'].forEach((urlImg) async {
        Random rnd = new Random();

        try {
          await Images.create({
            "idImage": "idImage_${rnd.nextInt(100000000)}",
            "uidUser": user['uidUser'],
            "src": urlImg
          });
        } catch (e) {}
      });
    }

    return insertPosts(nuevoPosts);
  }

  static Future<dynamic> allPostss() {
    return getPosts();
  }

  //Json configuration
  Posts.fromJson(Map<String, dynamic> json)
      : idPost = json['idPost'],
        titulo = json['titulo'],
        descripcion = json['descripcion'],
        fecha = json['fecha'],
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
        'uidUser': uidUser,
        'nombreMapa': nombreMapa,
        'latitud': latitud,
        'longitud': longitud,
        'adjuntos': adjuntos,
      };
}
