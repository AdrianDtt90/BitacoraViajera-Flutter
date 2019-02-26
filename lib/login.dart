import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sandbox_flutter/Redux/index.dart';

import 'Screens/home.dart';
import 'package:sandbox_flutter/MyFunctionalities/MyLoginFacebook/index.dart';
import 'package:sandbox_flutter/MyFunctionalities/MyLoginGoogleFirebase/index.dart';

import 'package:sandbox_flutter/Redux/index.dart';
import 'package:flutter_redux/flutter_redux.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  @override
  Widget build(BuildContext context) {
    return Container(
        child: new StoreConnector<Map<String,dynamic>, bool>(
      converter: (store) {
        return store.state['userLogin'];
      },
      builder: (context, userLogin) {
        return userLogin ? MyHomePage() : login();
      },
    ));
  }

  Widget login() {
    void _onLoggedInOk(loggedUser) {
      store.dispatch(Actions.UserLogin);
    }

    return new MyLoginGoogleFirebase(_onLoggedInOk);
  }
}
