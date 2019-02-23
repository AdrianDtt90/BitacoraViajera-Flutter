import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;

import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';

import 'item1.dart';
import 'item2.dart';
import '../camara.dart';
import '../Notifications.dart';

import 'package:sandbox_flutter/Components/MiCard.dart';
import 'package:sandbox_flutter/Components/MiPhotoSwiper.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bitacora Viajera'),
      ),
      body: ScreenRouter(value: _selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), title: Text('Calendario')),
          BottomNavigationBarItem(
              icon: Icon(Icons.image), title: Text('Imagenes')),
        ],
        currentIndex: _selectedIndex,
        fixedColor: Colors.blue,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() {
              _count++;
            }),
        tooltip: 'Increment Counter',
        child: Icon(Icons.add),
        elevation: 0.0,
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CameraApp()),
                );
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Item2Screen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

class ScreenRouter extends StatelessWidget {
  final int value;
  ScreenRouter({Key key, this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return getScreen(value)[value];
  }

  Map getScreen(key) {
    Map _list = <int, Widget>{
      0: FirstScreen(value: key),
      1: SecondScreen(value: key),
      2: ThirdScreen(value: key),
    };

    return _list;
  }
}

class FirstScreen extends StatelessWidget {
  final int value;

  FirstScreen({Key key, this.value}) : super(key: key);
  static DateTime now = DateTime.now();
  static String formattedDate = DateFormat('kk:mm:ss  EEE d MMM').format(now);

  List<TimelineModel> items = [
    TimelineModel(
        MiPhotoSwiper(
            date: formattedDate,
            width: 200.0,
            height: 300.0,
            content: Text('LISTEN')),
        position: TimelineItemPosition.random,
        iconBackground: Colors.blue,
        icon: Icon(Icons.blur_circular, color: Colors.white)),
    TimelineModel(
        MiCard(
            date: formattedDate,
            width: 300.0,
            height: 200.0,
            content: Text('LISTEN')),
        position: TimelineItemPosition.random,
        iconBackground: Colors.blue,
        icon: Icon(Icons.blur_circular, color: Colors.white)),
    TimelineModel(
        MiCard(
            date: formattedDate,
            width: 200.0,
            height: 100.0,
            content: Text('LISTEN')),
        position: TimelineItemPosition.random,
        iconBackground: Colors.blue,
        icon: Icon(Icons.blur_circular, color: Colors.white)),
    TimelineModel(
        MiCard(
            date: formattedDate,
            width: 300.0,
            height: 300.0,
            content: Text('LISTEN')),
        position: TimelineItemPosition.random,
        iconBackground: Colors.blue,
        icon: Icon(Icons.blur_circular, color: Colors.white)),
    TimelineModel(
        MiCard(
            date: formattedDate,
            width: 200.0,
            height: 300.0,
            content: Text('LISTEN')),
        position: TimelineItemPosition.random,
        iconBackground: Colors.blue,
        icon: Icon(Icons.blur_circular, color: Colors.white)),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Timeline(children: items, position: TimelinePosition.Left),
    );
  }
}

class SecondScreen extends StatelessWidget {
  final int value;

  SecondScreen({Key key, this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FirebaseBridge();
  }
}

class ThirdScreen extends StatelessWidget {
  final int value;

  ThirdScreen({Key key, this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: CustomScrollView(
      primary: false,
      slivers: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.all(20.0),
          sliver: SliverGrid.count(
            crossAxisSpacing: 10.0,
            crossAxisCount: 2,
            children: <Widget>[
              const Text('He\'d have you all unravel at the'),
              const Text('Heed not the rabble'),
              const Text('Sound of screams but the'),
              const Text('Who scream'),
              const Text('Revolution is coming...'),
              const Text('Revolution, they...'),
            ],
          ),
        ),
      ],
    ));
  }
}

class FirebaseBridge extends StatefulWidget {
  FirebaseBridge({Key key}) : super(key: key);

  @override
  _FirebaseBridgeState createState() => _FirebaseBridgeState();
}

class _FirebaseBridgeState extends State<FirebaseBridge> {
  File _image;

  @override
  void initState() {
    super.initState();
    //main();
  }

  @override
  Widget build(BuildContext context) {
    //main();

    return Container(
        child: Column(
      children: <Widget>[
        //Notifications()
        RaisedButton(
          child: const Text('Connect with Twitter'),
          color: Theme.of(context).accentColor,
          elevation: 4.0,
          splashColor: Colors.blueGrey,
          onPressed: () {
            fetchPost();
          },
        ),
        Center(
          child:
              _image == null ? Text('No image selected.') : Image.file(_image),
        )
      ],
    ));
  }

  Future<http.Response> fetchPost() {
    Map<String, String> userHeader = {'Authorization':
          'key=AAAArSM6NeE:APA91bFjlUNKt7peO2SXXKjF1rB4g-clSTS-dK2g2zdUZk61a8eyQd2xhHthABYWNnWeAv4ajjG94KI_NPixwQXIJQ6Gdd0cmYAla4MpD7sazXleVW-4kLpK98yN69kMko13RXG9vJ5M',
      'Content-Type': 'application/json'};
    
    String data = json.encode( {
      "to" : "dORNBLE8QDY:APA91bHMXBorfBlyxPH-L1F_PkvPvMykRSRZ-fL0wl1OoiwbICZaMDUVRhFp8QtD0VaxjO8fveSEi9x5t0zqHO3zVk6_M9rhKGCQSIX4P7wKZC6mMaK74XHArftSTgbWIrKhtHgV0BeU",
      "collapse_key" : "type_a",
      "notification" : {
          "body" : "lerolero!!",
          "title": "cacholero!"
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

  void takePhoto() async {
    //String nombreAdrian = await getAdrian();

    // Persona marce = await Persona.create('lele','lili',61);
    // marce.nombre = 'Marcela';
    // marce.apellido = 'Caminos';
    // marce.edad = 60;
    // marce.update();
  }

  Future<String> getAdrian() async {
    DocumentSnapshot querySnapshot = await Firestore.instance
        .collection('personas')
        .document('jsN1mcA5Ln6Zz2cyXhWc')
        .get();
    if (querySnapshot.exists) {
      // Create a new List<String> from List<dynamic>
      return querySnapshot.data['nombre'];
    }

    return '';
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    return Padding(
      key: ValueKey(data['nombre']),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
          child: Text(
              'Nombre: ${data['nombre']}, Apellido: ${data['apellido']}, Edad: ${data['edad']}')),
    );
  }
}
