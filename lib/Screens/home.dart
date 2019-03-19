import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:sandbox_flutter/Components/MiImage.dart';
import 'package:sandbox_flutter/Components/MiListPosts.dart';
import 'package:sandbox_flutter/Entities/Posts.dart';
import 'package:sandbox_flutter/Redux/index.dart';

import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';

import 'item1.dart';
import 'item2.dart';
import 'package:sandbox_flutter/MyFunctionalities/MyImagePicker.dart';

import 'package:sandbox_flutter/Components/MiCard.dart';
import 'package:sandbox_flutter/MyFunctionalities/MyMapPicker/MyGeolocation.dart';

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
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.grey,
              ),
              title: Text(
                'Home',
                style: TextStyle(color: Colors.grey),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.calendar_today,
                color: Colors.grey,
              ),
              title: Text(
                'Calendario',
                style: TextStyle(color: Colors.grey),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.map,
                color: Colors.grey,
              ),
              title: Text(
                'Mapa',
                style: TextStyle(color: Colors.grey),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.image,
                color: Colors.grey,
              ),
              title: Text(
                'Imagenes',
                style: TextStyle(color: Colors.grey),
              )),
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
      3: FourthScreen(value: key),
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

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        body: MiListPosts(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _navigateToCreatePost(context);
          },
          tooltip: 'Increment Counter',
          child: Icon(Icons.add),
          elevation: 0.0,
        ));
  }

  _navigateToCreatePost(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MiInputPost()),
    );
  }
}

class SecondScreen extends StatefulWidget {
  final int value;

  SecondScreen({Key key, this.value}) : super(key: key);

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {

  var _currentDate = DateTime.now();

  EventList<Widget> _markedDateMap = new EventList<Widget>(
    events: {
      new DateTime(2019, 3, 14): [
        Container()
      ],
    },
  );

  @override
  initState() {
    super.initState();

    Map<String,dynamic> filtros = {
      "monthYear": {
        "year": 2019,
        "month": 3
      }
    };
    Posts.allPostsFilters(filtros).then((values) {
      //Los del mes!!
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        child: CalendarCarousel<Widget>(
          thisMonthDayBorderColor: Colors.grey,
          selectedDateTime: _currentDate,
          daysHaveCircularBorder: true,
          daysTextStyle: TextStyle(color: Colors.blue),
          weekendTextStyle: TextStyle(color: Colors.blue, ),
          weekdayTextStyle: TextStyle(color: Colors.blue, ),
          selectedDayButtonColor: Colors.lightBlue,
          selectedDayBorderColor: Colors.blue,
          onDayPressed: (DateTime date, List<dynamic> list) {
            var a = 1;
          },
          onCalendarChanged: (DateTime date) {
            var a = 1;
          },
          locale: 'es',
          markedDatesMap: _markedDateMap,
          // headerText: Container(
          //   /// Example for rendering custom header
          //   child: Text('Custom Header'),
          // ),
        ));
  }

  void postDelMesAno() async {
    Map<String,dynamic> filtros = {
      "monthYear": {
        "year": 2019,
        "month": 3
      }
    };

    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MiListPosts(filters: filtros)),
    );
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

class FourthScreen extends StatelessWidget {
  final int value;

  FourthScreen({Key key, this.value}) : super(key: key);

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
