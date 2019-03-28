import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:http/http.dart' as http;
import 'package:sandbox_flutter/Entities/Users.dart';

class NotificationSender {
  final FirebaseMessaging firebaseMessaging = new FirebaseMessaging();

  static Future<http.Response> fetchNotification(String title, String body) {
    Map<String, String> userHeader = {
      'Authorization':
          'key=AAAArSM6NeE:APA91bFjlUNKt7peO2SXXKjF1rB4g-clSTS-dK2g2zdUZk61a8eyQd2xhHthABYWNnWeAv4ajjG94KI_NPixwQXIJQ6Gdd0cmYAla4MpD7sazXleVW-4kLpK98yN69kMko13RXG9vJ5M',
      'Content-Type': 'application/json'
    };

    var resultList = Users.getOther();

    return resultList.then((listUsers) {
      for (Users user in listUsers) {
        String data = json.encode({
          "to": user.notificationToken,
          "collapse_key": "type_a",
          "notification": {"body": body, "title": title}
        });

        http
            .post('https://fcm.googleapis.com/fcm/send',
                body: data, headers: userHeader)
            .then((response) {
          if (response.statusCode == 200) {
            print("Number of books about http lala.");
          } else {
            print("Request failed with status: ${response.statusCode}.");
          }
        });
      }
    });
  }
}

//Widget Listener
class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  String _tokenText = '';
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    firebaseCloudMessaging_Listeners();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  void firebaseCloudMessaging_Listeners() {
    if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((token) {
      print(token);
      setState(() {
        _tokenText = token;
      });
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
        //message.values.first['title']
        OverlayEntry notificacion;
        notificacion = OverlayEntry(builder: (BuildContext context) {
          return FunkyNotification(
            entry: notificacion,
            title: message.values.first['title'],
          );
        });

        Navigator.of(context)
            .overlay
            .insert(notificacion);

      
// VER COMO CARAJO CERRAR ESTO

        //overlay.remove();
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }
}

class FunkyNotification extends StatefulWidget {
  OverlayEntry entry;
  String title;

  FunkyNotification({Key key, this.entry, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() => FunkyNotificationState();
}

class FunkyNotificationState extends State<FunkyNotification>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<Offset> position;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 750));
    position = Tween<Offset>(begin: Offset(0.0, -4.0), end: Offset.zero)
        .animate(
            CurvedAnimation(parent: controller, curve: Curves.bounceInOut));

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: Colors.transparent,
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: 32.0),
            child: SlideTransition(
              position: position,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: ShapeDecoration(
                    color: Color.fromRGBO(72, 114, 155, 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0))),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Wrap(
                            children: <Widget>[
                              Text(
                                '¡Nueva Notificación!',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                widget.title,
                                style: TextStyle(
                                    color: Colors.white),
                              )
                            ],
                          )),
                    ),
                    IconButton(
                      color: Colors.white,
                      padding: EdgeInsets.all(0.0),
                      icon: new Icon(Icons.cancel),
                      onPressed: () {
                        //Navigator.of(context).pop();
                        widget.entry.remove();
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
