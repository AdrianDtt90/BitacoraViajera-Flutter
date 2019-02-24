import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:http/http.dart' as http;

class NotificationSender {

  static Future<http.Response> fetchNotification(String title, String body) {
    Map<String, String> userHeader = {'Authorization':
          'key=AAAArSM6NeE:APA91bFjlUNKt7peO2SXXKjF1rB4g-clSTS-dK2g2zdUZk61a8eyQd2xhHthABYWNnWeAv4ajjG94KI_NPixwQXIJQ6Gdd0cmYAla4MpD7sazXleVW-4kLpK98yN69kMko13RXG9vJ5M',
      'Content-Type': 'application/json'};

    String data = json.encode( {
      "to" : "dORNBLE8QDY:APA91bHMXBorfBlyxPH-L1F_PkvPvMykRSRZ-fL0wl1OoiwbICZaMDUVRhFp8QtD0VaxjO8fveSEi9x5t0zqHO3zVk6_M9rhKGCQSIX4P7wKZC6mMaK74XHArftSTgbWIrKhtHgV0BeU",
      "collapse_key" : "type_a",
      "notification" : {
          "body" : body,
          "title": title
      }
    });


    http.post('https://fcm.googleapis.com/fcm/send', body: data, headers: userHeader).then((response) {
      if (response.statusCode == 200) {
        print("Number of books about http lala.");
      } else {
        print("Request failed with status: ${response.statusCode}.");
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

