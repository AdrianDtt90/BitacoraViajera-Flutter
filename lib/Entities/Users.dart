import 'package:sandbox_flutter/Firebase/QueriesUsers.dart';

class Users {
  String displayName;
  String email;
  String photoUrl;
  String uid;
  String notificationToken;

  Users(this.uid, this.displayName, this.email, this.photoUrl, this.notificationToken);

  Future<Users> update () {
    return updateUsers(this);
  }

  Future<Users> delete () {
    return deleteUsers(this);
  }

  //Statics
  static Future<Users> create (Map<String,dynamic> user) {
    Users nuevoUsers = new Users(user['uid'], user['displayName'], user['email'], user['photoUrl'], user['notificationToken']);
    return insertUsers(nuevoUsers);
  }

  static Future<dynamic> allUsers () {
    return getUsers();
  }

  static Future<dynamic> getOther () {
    return getOtherUsers();
  }

  static Future<dynamic> getUser (String idUser) {
    return getUsersById(idUser);
  }

  //Json configuration
  Users.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        displayName = json['displayName'],
        email = json['email'],
        photoUrl = json['photoUrl'],
        notificationToken = json['notificationToken'];

  Map<String, dynamic> toJson() =>
    {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'photoUrl': photoUrl,
      'notificationToken': notificationToken,
    };
}