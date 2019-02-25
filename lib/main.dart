import 'package:flutter/material.dart';
import 'package:sandbox_flutter/login.dart';

import 'package:flutter_redux/flutter_redux.dart';

import 'package:sandbox_flutter/Redux/index.dart';
import 'package:sandbox_flutter/MyFunctionalities/MyNotifications.dart';

void main() {

  runApp(new StoreProvider<Map<String,dynamic>>(
      // Pass the store to the StoreProvider. Any ancestor `StoreConnector`
      // Widgets will find and use this value as the `Store`.
      store: store,
      child: MaterialApp(
      title: 'Bitacora Viajera',
      // Start the app with the "/" named route. In our case, the app will start
      // on the FirstScreen Widget
      home: Stack(children: <Widget>[
        Notifications(), //Listener Notifications
        Login() //Login Facebok and HomePage
      ])))
  );
}
