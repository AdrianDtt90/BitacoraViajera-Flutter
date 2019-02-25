import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'Screens/home.dart';
import 'package:sandbox_flutter/MyFunctionalities/MyLoginFacebook/index.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return Container(
          child: isLoggedIn ? MyHomePage() : login(),
        );
  }

  Widget login () {
    void _onLoggedInOk() { 
      setState(() {
        isLoggedIn = true;
      });
    }
    
    return new LoginFacebook(_onLoggedInOk);
  }
}
