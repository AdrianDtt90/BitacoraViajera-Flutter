import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'DetailScreen.dart'; //important fix
import 'package:sandbox_flutter/Components/MiLoading.dart';

class MyLoginGoogleFirebase extends StatefulWidget {
  final Function onLoggedInOk;
  MyLoginGoogleFirebase(this.onLoggedInOk);

  @override
  State<StatefulWidget> createState() {
    return new MyLoginGoogleFirebaseState();
  }
}

class MyLoginGoogleFirebaseState extends State<MyLoginGoogleFirebase> {
  bool userLogged = true;
  var token = null;
  final FirebaseAuth _fAuth = FirebaseAuth.instance;
  final GoogleSignIn _gSignIn = new GoogleSignIn();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();

    verifyUserLogged();
  }

  void verifyUserLogged() async {
    try {
      token = await _firebaseMessaging.getToken();
    } catch (e) {
      print(e);
    }
    
    getCurrentUser().then((userId) {
      if (userId != null) {
        entrar();
      } else {
        setState(() {
          userLogged = false;
        });
      }
    });
  }

  void entrar() {
    _signIn(context).then((Map<String, dynamic> user) {
      user['notificationToken'] = token;
      widget.onLoggedInOk(user);
    }).catchError((e) => print(e));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color.fromRGBO(0, 173, 255, 1),
        child: userLogged == true
            ? MiLoading()
            : Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(IconData(58730, fontFamily: 'MaterialIcons'),
                      size: 100, color: Color.fromRGBO(255, 255, 255, 1)),
                  Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: MaterialButton(
                        minWidth: 150.0,
                        onPressed: () => entrar(),
                        child: Text('Iniciar Sesión',
                            style: TextStyle(
                                color: Color.fromRGBO(255, 255, 255, 1))),
                        color: Colors.lightBlueAccent,
                      ))
                ],
              )));
  }

  Future<Map<String, dynamic>> _signIn(BuildContext context) async {
    GoogleSignInAccount googleSignInAccount = await _gSignIn.signIn();
    GoogleSignInAuthentication authentication =
        await googleSignInAccount.authentication;

    FirebaseUser user = await _fAuth.signInWithGoogle(
        idToken: authentication.idToken,
        accessToken: authentication.accessToken);

    UserInfoDetails userInfo = new UserInfoDetails(
        user.providerId, user.displayName, user.email, user.photoUrl, user.uid);

    return userInfo.toJson();
  }

  Future<String> getCurrentUser() async {
    try {
      FirebaseUser user = await _fAuth.currentUser();
      if (user != null) {
        return user.uid;
      }

      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }
}

class UserDetails {
  final String providerId;

  final String uid;

  final String displayName;

  final String photoUrl;

  final String email;

  final bool isAnonymous;

  final bool isEmailVerified;

  final List<UserInfoDetails> providerData;

  UserDetails(this.providerId, this.uid, this.displayName, this.photoUrl,
      this.email, this.isAnonymous, this.isEmailVerified, this.providerData);

  //Json configuration
  UserDetails.fromJson(Map<String, dynamic> json)
      : providerId = json['providerId'],
        uid = json['uid'],
        displayName = json['displayName'],
        photoUrl = json['photoUrl'],
        email = json['email'],
        isAnonymous = json['isAnonymous'],
        isEmailVerified = json['isEmailVerified'],
        providerData = json['providerData'];

  Map<String, dynamic> toJson() => {
        'providerId': providerId,
        'uid': uid,
        'displayName': displayName,
        'photoUrl': photoUrl,
        'email': email,
        'isAnonymous': isAnonymous,
        'isEmailVerified': isEmailVerified,
        'providerData': providerData,
      };
}

class UserInfoDetails {
  UserInfoDetails(
      this.providerId, this.displayName, this.email, this.photoUrl, this.uid);

  /// The provider identifier.
  final String providerId;

  /// The provider’s user ID for the user.
  final String uid;

  /// The name of the user.
  final String displayName;

  /// The URL of the user’s profile photo.
  final String photoUrl;

  /// The user’s email address.
  final String email;

  //Json configuration
  UserInfoDetails.fromJson(Map<String, dynamic> json)
      : providerId = json['providerId'],
        displayName = json['displayName'],
        email = json['email'],
        photoUrl = json['photoUrl'],
        uid = json['uid'];

  Map<String, dynamic> toJson() => {
        'providerId': providerId,
        'displayName': displayName,
        'email': email,
        'photoUrl': photoUrl,
        'uid': uid,
      };
}
