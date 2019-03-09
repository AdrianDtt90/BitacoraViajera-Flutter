import 'package:sandbox_flutter/Firebase/QueriesPosts.dart';

class Posts {
  String titulo;
  String descripcion;
  String fecha;
  String idPost;
  String uidUser;
  bool tieneMapa;
  double latitud;
  double longitud;
  List<String> adjuntos;

  Posts(this.idPost,
  this.titulo,
  this.descripcion,
  this.fecha,
  this.uidUser,
  this.tieneMapa,
  this.latitud,
  this.longitud,
  this.adjuntos);

  Future<Posts> update () {
    return updatePosts(this);
  }

  Future<Posts> delete () {
    return deletePosts(this);
  }

  //Statics
  static Future<Posts> create (Map<String,dynamic> user) {
    Posts nuevoPosts = new Posts(user['idPost'],
    user['titulo'],
    user['descripcion'],
    user['fecha'],
    user['uidUser'],
    user['tieneMapa'],
    user['latitud'],
    user['longitud'],
    user['adjuntos']);
    return insertPosts(nuevoPosts);
  }

  static Future<dynamic> allPostss () {
    return getPosts();
  }

  //Json configuration
  Posts.fromJson(Map<String, dynamic> json)
      : idPost = json['idPost'],
        titulo = json['titulo'],
        descripcion = json['descripcion'],
        fecha = json['fecha'],
        uidUser = json['uidUser'],
        tieneMapa = json['tieneMapa'],
        latitud = json['latitud'],
        longitud = json['longitud'],
        adjuntos = json['adjuntos'];

  Map<String, dynamic> toJson() =>
    {
      'idPost': idPost,
      'titulo': titulo,
      'descripcion': descripcion,
      'fecha': fecha,
      'uidUser': uidUser,
      'tieneMapa': tieneMapa,
      'latitud': latitud,
      'longitud': longitud,
      'adjuntos': adjuntos,
    };
}