import 'package:sandbox_flutter/Firebase/QueriesImages.dart';

class Images {
  String idImage;
  String uidUser;
  String src;

  Images(this.idImage,
  this.uidUser,
  this.src);

  Future<Images> update () {
    return updateImages(this);
  }

  Future<Images> delete () {
    return deleteImages(this);
  }

  //Statics
  static Future<Images> create (Map<String,dynamic> user) {
    Images nuevoImages = new Images(user['idImage'],
    user['uidUser'],
    user['src']);
    return insertImages(nuevoImages);
  }

  static Future<dynamic> allImagess () {
    return getImages();
  }

  //Json configuration
  Images.fromJson(Map<String, dynamic> json)
      : idImage = json['idImage'],
        uidUser = json['uidUser'],
        src = json['src'];

  Map<String, dynamic> toJson() =>
    {
      'idImage': idImage,
      'uidUser': uidUser,
      'src': src,
    };
}