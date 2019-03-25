import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sandbox_flutter/Entities/Users.dart';
import 'package:sandbox_flutter/Redux/index.dart';

Future<dynamic> getUsers() async {
  return Firestore.instance.collection('users').getDocuments();

  //La forma de obtener el array de documentos:
  // getUsers().then((result) {
  //   --Recorremos los documentos
  //   result.documents.forEach((document) {
  //       document.data['apellido'];
  //   });
  // });
}

Future<dynamic> getOtherUsers() async {
  var result = Firestore.instance.collection('users').getDocuments();

  return result.then((result) async {
    List<Users> listUser = new List();

    for(var document in result.documents) {
        var idUser = store.state['loggedUser']['uid'];

        if(document.data['uid'] != idUser ) {
          Users user = await Users.create(document.data);
          listUser.add(user);
        }
    }

    return listUser;
  });
}

Future<Users> getUsersById(String idUsers) async {
  return Firestore.instance.collection('users').document(idUsers).get()
  .then((user) {
    return new Users.fromJson(user.data);
  });
}

Future<Users> insertUsers(Users user) {
  DocumentReference _skillsRef = Firestore.instance.collection('users').document(user.uid);

  return _skillsRef.setData(user.toJson()).then((result) {
    user.uid = _skillsRef.documentID;
    return user;
  });
}

Future<Users> updateUsers(Users user) async {
  return Firestore.instance
      .collection('users')
      .document(user.uid)
      .updateData(user.toJson())
      .then((result) {
        return user;
      });
}

Future<Users> deleteUsers(Users user) async {
  return Firestore.instance.collection('users').document(user.uid).delete()
  .then((result) {
    return user;
  });
}

// Future<Users> updateUserssByCondition(String idUsers) async {
//   return Firestore.instance
//       .collection('users')
//       .where('apellido', isEqualTo: 'dotta')
//       .getDocuments()
//       .then((result) {
//     result.documents.forEach((document) {
//       updateUsers(document.documentID);
//     });
//   });
// }
