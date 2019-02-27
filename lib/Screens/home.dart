import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:sandbox_flutter/Redux/index.dart';

import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';

import 'item1.dart';
import 'item2.dart';
import 'package:sandbox_flutter/MyFunctionalities/MyImagePicker.dart';

import 'package:sandbox_flutter/Components/MiCard.dart';
import 'package:sandbox_flutter/Components/MiPhotoSwiper.dart';

import 'package:sandbox_flutter/MyFunctionalities/MyLoginGoogleFirebase/index.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  int _count = 0;
  
  final GoogleSignIn _gSignIn = new GoogleSignIn();

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
              child: new StoreConnector<Map<String, dynamic>,
                  Map<String, dynamic>>(
                converter: (store) => store.state['userLogin'],
                builder: (context, userLogin) {
                  return Column(children: <Widget>[
                    Container(
                        width: 100.0,
                        height: 100.0,
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: new NetworkImage(
                                    "${userLogin['photoUrl']}")))),
                    Container(
                        margin: const EdgeInsets.only(top: 10.0),
                        child: Text('Bienvenido ${userLogin['displayName']}',
                            style: TextStyle(
                                color: Color.fromRGBO(255, 255, 255, 1))))
                  ]);
                },
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Item1Screen()),
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
            ListTile(
              title: Text('Cerrar Sesión'),
              onTap: () {
                store.dispatch(new LogOutAction());
                _gSignIn.signOut();
              },
            )
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
    return MyImagePicker();
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
