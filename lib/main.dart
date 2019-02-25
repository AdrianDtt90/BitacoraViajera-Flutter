import 'package:flutter/material.dart';
import 'package:sandbox_flutter/MyFunctionalities/MyNotifications.dart';
import 'package:sandbox_flutter/login.dart';

void main() {
  runApp(MaterialApp(
      title: 'Bitacora Viajera',
      // Start the app with the "/" named route. In our case, the app will start
      // on the FirstScreen Widget
      home: Stack(children: <Widget>[
        Notifications(), //Listener Notifications
        Login() //Login Facebok y Redirección
      ])));
}
