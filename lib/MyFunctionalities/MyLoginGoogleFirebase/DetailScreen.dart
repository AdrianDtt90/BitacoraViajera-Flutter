import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'index.dart'; //important fix
// {
//   "_data": {
//     "providerId": "string",
// 	"uid": "string",
//     "displayName": "string",
//     "photoUrl": "string",
//     "email": "string",
//     "isAnonymous": "string",
//     "isEmailVerified": "string",
//     "providerData": {
//       "isEmailVerified": "string",
//       "isEmailVerified": "string"
//     }
//   }
// }

class DetailScreen extends StatelessWidget {
  final UserDetails detailsUser;

  // DetailScreen({
  //   Key key,
  //   this.name}) : super(key: key);

  DetailScreen({Key key, @required this.detailsUser}) : super(key: key);  

  @override
  Widget build(BuildContext context) {
    final myInhWidget = MyInhWidget.of(context);

    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Google Sign In Details'),
          automaticallyImplyLeading: false,
        ),
        body: new Container(          
          padding: const EdgeInsets.all(10.0),
          child: new Column(
            children: <Widget>[
              new Text(
                "Name : " + detailsUser.displayName,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                textScaleFactor: 1.2,
                style: new TextStyle(fontWeight: FontWeight.bold, color: Colors.brown),
              ),
              new Padding(padding: new EdgeInsets.all(5.0),),
              new Text(
                "Email : " + detailsUser.email,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                textScaleFactor: 1.2,
                style: new TextStyle(fontWeight: FontWeight.bold, color: Colors.brown),
              ),
              new Padding(padding: new EdgeInsets.all(5.0),),
              new Text(
                "isAnonymous : " + detailsUser.isAnonymous.toString(),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                textScaleFactor: 1.2,
                style: new TextStyle(fontWeight: FontWeight.bold, color: Colors.brown),
              ),
              new Padding(padding: new EdgeInsets.all(5.0),),
              new Text(
                "isEmailVerified : " + detailsUser.isEmailVerified.toString(),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                textScaleFactor: 1.2,
                style: new TextStyle(fontWeight: FontWeight.bold, color: Colors.brown),
              ),
              new Padding(padding: new EdgeInsets.all(5.0),),
              new Text(
                "Photo URL : " + detailsUser.photoUrl,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                textScaleFactor: 1.2,
                style: new TextStyle(fontWeight: FontWeight.bold, color: Colors.brown),
              ),
              new Padding(padding: new EdgeInsets.all(5.0),),
              new Text(
                "Provider ID : " + detailsUser.providerId,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                textScaleFactor: 1.2,
                style: new TextStyle(fontWeight: FontWeight.bold, color: Colors.brown),
              ),
              new Padding(padding: new EdgeInsets.all(5.0),),
              new Text(
                "UiD : " + detailsUser.uid,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                textScaleFactor: 1.2,
                style: new TextStyle(fontWeight: FontWeight.bold, color: Colors.brown),
              ),
              new Padding(padding: new EdgeInsets.all(5.0),),
              new Text(
                "UiD : " + detailsUser.providerData.toString(),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                textScaleFactor: 1.2,
                style: new TextStyle(fontWeight: FontWeight.bold, color: Colors.brown),
              ),
            ],
          ),
        ));
  }
}
// class DetailScreenMode extends State<DetailScreen> {
//   @override
//   Widget build(BuildContext context) {

//     final myInhWidget = MyInhWidget.of(context);

//     return new Scaffold(
//         appBar: new AppBar(
//       title: new Text(myInhWidget.userName),
//       automaticallyImplyLeading: false,
//     ));
//   }
// }
