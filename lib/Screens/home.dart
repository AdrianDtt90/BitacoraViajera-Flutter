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
import 'package:photo_view/photo_view_gallery.dart';
import 'package:sandbox_flutter/Components/MapMarkers.dart';
import 'package:sandbox_flutter/Components/MiImage.dart';
import 'package:sandbox_flutter/Components/MiListPosts.dart';
import 'package:sandbox_flutter/Entities/Images.dart';
import 'package:sandbox_flutter/Entities/Posts.dart';
import 'package:sandbox_flutter/Entities/Sugerencias.dart';
import 'package:sandbox_flutter/MyFunctionalities/MyFunctions.dart';
import 'package:sandbox_flutter/Redux/index.dart';
import 'package:sandbox_flutter/Screens/listPosts.dart';

import 'item1.dart';
import 'item2.dart';

import 'package:sandbox_flutter/Components/MiInputPost.dart';

GlobalKey<ScaffoldState> scaffoldState = new GlobalKey();

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
      key: scaffoldState,
      appBar: AppBar(
        title: Text('Bitacora Viajera'),
        backgroundColor: Color.fromRGBO(67, 170, 139, 1),
      ),
      body: ScreenRouter(value: _selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              activeIcon:
                  Icon(Icons.home, color: Color.fromRGBO(67, 170, 139, 1)),
              icon: Icon(
                Icons.home,
                color: Colors.grey,
              ),
              title: Text(
                'Home',
                style: TextStyle(color: Colors.grey),
              )),
          BottomNavigationBarItem(
              activeIcon: Icon(Icons.calendar_today,
                  color: Color.fromRGBO(67, 170, 139, 1)),
              icon: Icon(
                Icons.calendar_today,
                color: Colors.grey,
              ),
              title: Text(
                'Calendario',
                style: TextStyle(color: Colors.grey),
              )),
          BottomNavigationBarItem(
              activeIcon:
                  Icon(Icons.map, color: Color.fromRGBO(67, 170, 139, 1)),
              icon: Icon(
                Icons.map,
                color: Colors.grey,
              ),
              title: Text(
                'Mapa',
                style: TextStyle(color: Colors.grey),
              )),
          BottomNavigationBarItem(
              activeIcon:
                  Icon(Icons.image, color: Color.fromRGBO(67, 170, 139, 1)),
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
        fixedColor: Color.fromRGBO(67, 170, 139, 1),
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
                            border: new Border.all(color: Colors.white, width: 2.0),
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: new NetworkImage(
                                    "${loggedUser['photoUrl']}")))),
                    Container(
                        margin: const EdgeInsets.only(top: 10.0),
                        child: Text('${loggedUser['displayName']}',
                            style: TextStyle(
                                color: Color.fromRGBO(255, 255, 255, 1))))
                  ]);
                },
              ),
              decoration: BoxDecoration(
                gradient: new LinearGradient(
                  colors: [
                    Color.fromRGBO(67, 170, 139, 1),
                    Color.fromRGBO(72, 114, 155, 1),
                  ],
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                ),
                color: Color.fromRGBO(67, 170, 139, 1),
              ),
            ),
            // ListTile(
            //   title: Text('Item 1'),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => Item1Screen()),
            //     );
            //   },
            // ),
            // ListTile(
            //   title: Text('Item 2'),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => Item2Screen()),
            //     );
            //   },
            // ),
            ListTile(
              title: Text('Enviar Sugerencia'),
              onTap: () {
                _enviarSugerencia();
              },
            ),
            ListTile(
              title: Text('Cerrar Sesión'),
              onTap: () {
                store.dispatch(new LogOutAction());
                _signOut();
              },
            ),
            Container(
              child: Image.asset("assets/cartel.png"),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _signOut() async {
    scaffoldState = null;
    _gSignIn.signOut();
    return _fAuth.signOut();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _enviarSugerencia() async {
    final TextEditingController _sugerenciaController =
        new TextEditingController();

    var result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Sugerencia"),
          content: new Wrap(
            children: <Widget>[
              new Text("Te invitamos a que nos envíes tu sugerenecia para mejorar nuestra app."),
              new TextField(
                autofocus: true,
                decoration: new InputDecoration(
                    hintText: "Escriba algo...", icon: Icon(Icons.comment)),
                controller: _sugerenciaController,
              ),
            ],
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Cerrar"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            new FlatButton(
              child: new Text("Enviar"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (result) {
      if (_sugerenciaController.text != '') {
        Sugerencias.create({
          "idSugerencia":
              "idSugerencia_${new DateTime.now().millisecondsSinceEpoch}",
          "uidUser": store.state['loggedUser']['uid'],
          "nombreUsuario": store.state['loggedUser']['displayName'],
          "emailUsuario": store.state['loggedUser']['email'],
          "sugerencia": _sugerenciaController.text,
          "fecha": new DateTime.now().toString()
        }).then((value) {
          _gracias();
        }).catchError((e) {});
      } else {
        _gracias();
      }
    }
  }

  void _gracias() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("¡Graacias!"),
          content: new Text("¡Muchas gracias por tu sugerencia!"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Cerrar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
  String _user = store.state['loggedUser']['uid'];

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        body: MiListPosts(),
        floatingActionButton: (_user == 'rRPOde1RJGRFfmfbr9C1td35r3S2' ||
                _user == '9gw2PpIP6hVyOenRhk34g1m7GE03')
            ? FloatingActionButton(
                backgroundColor: Color.fromRGBO(72, 114, 155, 1),
                onPressed: () {
                  _navigateToCreatePost(context);
                },
                tooltip: 'Increment Counter',
                child: Icon(Icons.add_to_photos),
                elevation: 0.0,
              )
            : Container());
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
  bool _cargando = true;
  EventList<Widget> _markedDateMap = new EventList<Widget>(
    events: {
      // NADA
    },
  );

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            child: CalendarCarousel<Widget>(
              thisMonthDayBorderColor: Colors.grey,
              selectedDateTime: _currentDate,
              daysHaveCircularBorder: true,
              daysTextStyle: TextStyle(color: Color.fromRGBO(67, 170, 139, 1)),
              weekendTextStyle: TextStyle(
                color: Color.fromRGBO(67, 170, 139, 1),
              ),
              weekdayTextStyle: TextStyle(
                color: Color.fromRGBO(67, 170, 139, 1),
              ),
              selectedDayButtonColor: Color.fromRGBO(67, 170, 139, 1),
              selectedDayBorderColor: Color.fromRGBO(67, 170, 139, 1),
              onDayPressed: (DateTime date, List<dynamic> list) {
                postDelMesAno(date);
              },
              onCalendarChanged: (DateTime date) {
                setState(() {
                  _cargando = true;
                });
                actualizarMarkadores(date);
              },
              locale: 'es',
              markedDatesMap: _markedDateMap,
              // headerText: Container(
              //   /// Example for rendering custom header
              //   child: Text('Custom Header'),
              // ),
            )),
        _cargando != false
            ? Container(
                decoration:
                    BoxDecoration(color: Color.fromRGBO(232, 232, 232, 0.6)),
                child: Center(
                    child: SizedBox(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(
                        Color.fromRGBO(67, 170, 139, 1)),
                  ),
                  height: 50.0,
                  width: 50.0,
                )))
            : Container()
      ],
    );
  }

  void actualizarMarkadores(DateTime date) async {
    Map<String, dynamic> filtros = {
      "monthYear": {"year": date.year, "month": date.month}
    };
    var service = Posts.allPosts(1, 5, filtros);
    service.then((result) {
      //Los del mes!!
      Map<DateTime, List<Widget>> events = {};
      result.forEach((post) {
        DateTime date =
            new DateTime.fromMillisecondsSinceEpoch(post.data['timestamp']);
        // events[]
        events[date] = [Container()];
      });

      EventList<Widget> markedDateMap = new EventList<Widget>(
        events: events,
      );

      setState(() {
        _markedDateMap = markedDateMap;
        _cargando = false;
      });
    });
  }

  void postDelMesAno(DateTime date) async {
    Map<String, dynamic> filtros = {
      "monthYear": {"year": date.year, "month": date.month, "day": date.day}
    };

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ListPosts(
              filters: filtros,
              title: '${date.day} de ' +
                  getMonthById(date.month) +
                  ' de ${date.year}')),
    );
  }
}

class ThirdScreen extends StatelessWidget {
  final int value;

  ThirdScreen({Key key, this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MapMarkers();
  }
}

class FourthScreen extends StatefulWidget {
  final int value;

  FourthScreen({Key key, this.value}) : super(key: key);
  @override
  _FourthScreenState createState() => _FourthScreenState();
}

class _FourthScreenState extends State<FourthScreen> {
  Widget _listaImages = Container();
  bool _cargando = true;

  @override
  initState() {
    super.initState();

    var service = Images.allImages();
    service.then((images) {
      getImagesViewer(images);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando == true) {
      return Container(
          decoration: BoxDecoration(color: Color.fromRGBO(232, 232, 232, 0.6)),
          child: Center(
              child: SizedBox(
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(
                  Color.fromRGBO(67, 170, 139, 1)),
            ),
            height: 50.0,
            width: 50.0,
          )));
    }
    return ListView(children: <Widget>[_listaImages]);
  }

  dynamic getImagesViewer(List<Images> list) {
    //Creamos imagenes de acuardo a las url de la BD
    List<Map<String, dynamic>> listAdjuntos = new List();
    list.forEach((image) {
      Map<String, dynamic> imagen = {
        'tipo': 'image',
        'fileType': 0, //Externa
        'src': image.src
      };
      listAdjuntos.add(imagen);
    });

    //Creamos las imagenes que se vana mostrar en el post (solo hasta 4)
    List<Widget> listaImagenes = new List();

    listAdjuntos.forEach((imagen) {
      var size =
          (MediaQuery.of(scaffoldState.currentContext).size.width / 2) - 19;

      listaImagenes.add(Container(
        width: size,
        height: size,
        child: MiImage(
            currentUrl: imagen['src'],
            fileType: 0,
            listImages: listAdjuntos), //Internal
      ));
    });

    setState(() {
      _cargando = false;
      _listaImages = Center(
          child: Padding(
              padding: EdgeInsets.all(5.0),
              child: Wrap(
                  spacing: 10.0, // gap between adjacent chips
                  runSpacing: 4.0, // gap between lines
                  children: listaImagenes)));
    });
  }
}
