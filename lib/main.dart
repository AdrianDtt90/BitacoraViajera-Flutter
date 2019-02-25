import 'package:flutter/material.dart';
import 'Screens/home.dart';
import 'package:sandbox_flutter/MyFunctionalities/MyNotifications.dart';

import 'package:sandbox_flutter/MyFunctionalities/MyLoginFacebook/index.dart';

void main() {
  runApp(MaterialApp(
      title: 'Bitacora Viajera',
      // Start the app with the "/" named route. In our case, the app will start
      // on the FirstScreen Widget
      home: Stack(children: <Widget>[
        Notifications(), //Listener Notifications
        LoginFacebook() //Login Facebok y Redirección
      ])));
}
