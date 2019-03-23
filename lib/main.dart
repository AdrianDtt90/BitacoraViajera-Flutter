import 'package:flutter/material.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:sandbox_flutter/Entities/Users.dart';

import 'package:sandbox_flutter/Redux/index.dart';
import 'package:sandbox_flutter/MyFunctionalities/MyNotifications.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sandbox_flutter/Redux/index.dart';

import 'Screens/home.dart';
import 'package:sandbox_flutter/MyFunctionalities/MyLoginFacebook/index.dart';
import 'package:sandbox_flutter/MyFunctionalities/MyLoginGoogleFirebase/index.dart';

import 'package:sandbox_flutter/Redux/index.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:connectivity/connectivity.dart';

void main() {
  checkConectivity().then((conectivity) {
    runApp(new StoreProvider<Map<String, dynamic>>(
        // Pass the store to the StoreProvider. Any ancestor `StoreConnector`
        // Widgets will find and use this value as the `Store`.
        store: store,
        child: MaterialApp(
            title: 'Bitacora Viajera',
            // Start the app with the "/" named route. In our case, the app will start
            // on the FirstScreen Widget
            home: Stack(children: <Widget>[
              Notifications(), //Listener Notifications
              Main(conectivity: conectivity) //Login Facebok and HomePage
            ]))));
  });
}

Future<bool> checkConectivity() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    return true;
  } else {
    return false;
  }
}

class Main extends StatefulWidget {
  final bool conectivity;

  Main({Key key, this.conectivity}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: new StoreConnector<Map<String, dynamic>, Map<String, dynamic>>(
      converter: (store) {
        return store.state['loggedUser'];
      },
      builder: (context, loggedUser) {
        
        if (!widget.conectivity) {
          return sinInternet();
        }

        return (loggedUser != null && loggedUser.isNotEmpty == true)
            ? MyHomePage()
            : login();
      },
    ));
  }

  Widget login() {
    void _onLoggedInOk(loggedUser) {
      //Agregamos usuario en Firebase
      Users.create(loggedUser).then((user) {
        store.dispatch(new LogInAction(loggedUser));
      });
    }

    return new MyLoginGoogleFirebase(_onLoggedInOk);
  }

  Widget sinInternet() {
    return Container(
      decoration: BoxDecoration(color: Colors.lightBlue[800]),
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.sentiment_dissatisfied,
              size: 100, color: Color.fromRGBO(255, 255, 255, 1)),
          MaterialButton(
                minWidth: 150.0,
                child: Text('Sin Internet',
                    style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1))),
                color: Colors.lightBlue[800],
              )
        ],
      )),
    );
  }

}
