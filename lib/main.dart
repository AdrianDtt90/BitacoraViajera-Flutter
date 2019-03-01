import 'package:flutter/material.dart';

import 'package:flutter_redux/flutter_redux.dart';

import 'package:sandbox_flutter/Redux/index.dart';
import 'package:sandbox_flutter/MyFunctionalities/MyNotifications.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sandbox_flutter/Redux/index.dart';

import 'Screens/home.dart';
import 'package:sandbox_flutter/MyFunctionalities/MyLoginFacebook/index.dart';
import 'package:sandbox_flutter/MyFunctionalities/MyLoginGoogleFirebase/index.dart';

import 'package:sandbox_flutter/MyFunctionalities/MyGeolocation.dart';

import 'package:sandbox_flutter/Redux/index.dart';
import 'package:flutter_redux/flutter_redux.dart';

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
        Main() //Login Facebok and HomePage
      ])))
  );
}


class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {

  @override
  Widget build(BuildContext context) {
    return Container(
        child: new StoreConnector<Map<String,dynamic>, Map<String, dynamic>>(
      converter: (store) {
        return store.state['loggedUser'];
      },
      builder: (context, loggedUser) {
        return (loggedUser != null && loggedUser.isNotEmpty == true) ? MyHomePage() : login();
      },
    ));
  }

  Widget login() {
    void _onLoggedInOk(loggedUser) {
      store.dispatch(new LogInAction(loggedUser));
    }

    return new MyLoginGoogleFirebase(_onLoggedInOk);
  }
}