import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:sandbox_flutter/Screens/home.dart';

class LoginFacebook extends StatefulWidget {
  
  final Function onLoggedInOk;
  LoginFacebook(this.onLoggedInOk);
  
  @override
  _LoginFacebookState createState() => _LoginFacebookState();
}

class _LoginFacebookState extends State<LoginFacebook> {
  int loginState = 0; // 0 Have to log, 1 Logged in, 2, Error

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Facebook Login"),
        ),
        body: Container(
          child: Center(
            child: switchCase(loginState),
          ),
        ),
      ),
    );
  }

  dynamic switchCase(int caseNumber) {
    switch (caseNumber) {
      case 0: // 0 Have to log
        return RaisedButton(
          child: Text("Login with Facebook"),
          onPressed: () => initiateFacebookLogin(),
        );
        break;
      case 1: // 1 Logged in
        return Container();
        break;
      case 2: // 2 Error
        return Text("Ocurrió un error");
        break;
    }
  }

  void onLoggedIn() {
    setState(() {
      this.loginState = 1;

      widget.onLoggedInOk();
    });
  }

  void onLogError() {
    setState(() {
      this.loginState = 2;
    });
  }

  void initiateFacebookLogin() async {
    var facebookLogin = FacebookLogin();
    var facebookLoginResult =
        await facebookLogin.logInWithReadPermissions(['email']);
    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        print("Error");
        onLogError();
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("CancelledByUser");
        onLogError();
        break;
      case FacebookLoginStatus.loggedIn:
        print("LoggedIn");
        onLoggedIn();
        break;
    }
  }
}
