import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
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

import 'package:sandbox_flutter/Components/MiInputPost.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final GoogleSignIn _gSignIn = new GoogleSignIn();
  final FirebaseAuth _fAuth = FirebaseAuth.instance;

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
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: new StoreConnector<Map<String, dynamic>,
                  Map<String, dynamic>>(
                converter: (store) => store.state['loggedUser'],
                builder: (context, loggedUser) {
                  return Column(children: <Widget>[
                    Container(
                        width: 100.0,
                        height: 100.0,
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: new NetworkImage(
                                    "${loggedUser['photoUrl']}")))),
                    Container(
                        margin: const EdgeInsets.only(top: 10.0),
                        child: Text('Bienvenido ${loggedUser['displayName']}',
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
                _signOut();
              },
            )
          ],
        ),
      ),
    );
  }

  Future<void> _signOut() async {
    _gSignIn.signOut();
    return _fAuth.signOut();
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

class FirstScreen extends StatefulWidget {
  final int value;

  FirstScreen({Key key, this.value}) : super(key: key);

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  bool _openMiInputPost = false;

  static DateTime now = DateTime.now();
  static String formattedDate = DateFormat('kk:mm:ss  EEE d MMM').format(now);

  List<TimelineModel> items = [
    TimelineModel(
        MiPhotoSwiper(
            key: Key("1"),
            date: formattedDate,
            width: 200.0,
            height: 300.0,
            content: Text('LISTEN')),
        position: TimelineItemPosition.random,
        iconBackground: Colors.blue,
        icon: Icon(Icons.blur_circular, color: Colors.white)),
    TimelineModel(
        MiCard(
            key: Key("2"),
            date: formattedDate,
            width: 300.0,
            height: 200.0,
            content: Text('LISTEN')),
        position: TimelineItemPosition.random,
        iconBackground: Colors.blue,
        icon: Icon(Icons.blur_circular, color: Colors.white)),
    TimelineModel(
        MiCard(
            key: Key("3"),
            date: formattedDate,
            width: 200.0,
            height: 100.0,
            content: Text('LISTEN')),
        position: TimelineItemPosition.random,
        iconBackground: Colors.blue,
        icon: Icon(Icons.blur_circular, color: Colors.white)),
    TimelineModel(
        MiCard(
            key: Key("4"),
            date: formattedDate,
            width: 300.0,
            height: 300.0,
            content: Text('LISTEN')),
        position: TimelineItemPosition.random,
        iconBackground: Colors.blue,
        icon: Icon(Icons.blur_circular, color: Colors.white)),
    TimelineModel(
        MiCard(
            key: Key("5"),
            date: formattedDate,
            width: 200.0,
            height: 300.0,
            content: Text('LISTEN')),
        position: TimelineItemPosition.random,
        iconBackground: Colors.blue,
        icon: Icon(Icons.blur_circular, color: Colors.white)),
  ];

  void closeMiInputPost() {
    setState(() {
      _openMiInputPost = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
            appBar: null,
            body: Container(
              child: Timeline(children: items, position: TimelinePosition.Left),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                setState(() {
                  _openMiInputPost = !_openMiInputPost;
                });
              },
              tooltip: 'Increment Counter',
              child: Icon(Icons.add),
              elevation: 0.0,
            )),
        _openMiInputPost ? MiInputPost(closeMiInputPost: closeMiInputPost) : Container()
      ],
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
