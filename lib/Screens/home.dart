import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:sandbox_flutter/Components/MiImage.dart';
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
  List<Widget> _listPost = new List();
  int lote = 2; //Definición por defecto
  bool _ultimosPost = false;
  bool _cargandoSigPosts = false;

  @override
  initState() {
    super.initState();

    _actualizarPublicaciones();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        body: Container(
            child: _listPost.length > 0
                ? Stack(children: <Widget>[
                    Container(
                      height: double.infinity,
                      width: 1.0,
                      color: Colors.black,
                      margin: const EdgeInsets.only(left: 28.0, right: 28.0),
                    ),
                    ListView(children: <Widget>[
                      Column(
                        children: _listPost,
                      ),
                      _cargandoSigPosts == true
                          ? Center(
                              child: SizedBox(
                                child: CircularProgressIndicator(),
                                height: 20.0,
                                width: 20.0,
                              ),
                            )
                          : Container(),
                      _ultimosPost == false && _cargandoSigPosts == false
                          ? Padding(
                              padding: EdgeInsets.only(left: 65.0, right: 5.0),
                              child: RaisedButton(
                                child: Text("Ver más..."),
                                onPressed: () {
                                  setState(() {
                                    _cargandoSigPosts = true;
                                  });
                                  _actualizarPublicaciones();
                                },
                              ))
                          : Container()
                    ]),
                  ])
                : Center(
                    child: SizedBox(
                      child: CircularProgressIndicator(),
                      height: 50.0,
                      width: 50.0,
                    ),
                  )),
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

    if (result == true) {
      setState(() {
        _listPost = []; // Volvemos a cargar cuando se agrega uno nuevo
      });
      _actualizarPublicaciones();
    }
  }

  _actualizarPublicaciones() {
    //Por defecto paginacion (lote) de 5
    var pagina = (_listPost.length / lote).ceil() + 1;
    Posts.allPosts(pagina, lote).then((result) {
      List<Widget> listPost = new List();
      List<DocumentSnapshot> lista = result;

      lista.forEach((document) {
        var adjuntosPost = Container();

        if (document.data['adjuntos'] != null &&
            document.data['adjuntos'].length > 0) {
          //Creamos imagenes de acuardo a las url de la BD
          List<Map<String, dynamic>> listAdjuntos = new List();
          document.data['adjuntos'].forEach((url) {
            Map<String, dynamic> imagen = {
              'tipo': 'image',
              'fileType': 0, //Externa
              'src': url
            };
            listAdjuntos.add(imagen);
          });

          //Creamos las imagenes que se vana mostrar en el post (solo hasta 4)
          List<Widget> listaImagenes = new List();
          int count = 1;
          listAdjuntos.forEach((imagen) {
            if (count > 4) {
              listaImagenes.add(MiImage(
                  linkTexto: '+ ver más',
                  currentUrl: imagen['src'],
                  fileType: 0,
                  listImages: listAdjuntos));
              return true;
            }

            listaImagenes.add(Container(
              width: 150,
              height: 150,
              child: MiImage(
                  currentUrl: imagen['src'],
                  fileType: 0,
                  listImages: listAdjuntos), //Internal
            ));

            count++;
          });

          adjuntosPost = Container(
              child: Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Wrap(
                      spacing: 8.0, // gap between adjacent chips
                      runSpacing: 4.0, // gap between lines
                      children: listaImagenes)));
        }

        String _imageAvatar = document.data['user'] != null
            ? document.data['user'].photoUrl.toString()
            : 'https://cdn.iconscout.com/icon/free/png-256/avatar-375-456327.png';

        listPost.add(Container(
            child: Stack(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(left: 60.0),
                child: MiCard(
                    key: Key("${document.data['idPost']}"),
                    idPost: "${document.data['idPost']}",
                    date: "${document.data['fecha']}",
                    width: 300.0,
                    content: Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Column(children: <Widget>[
                          Text("${document.data['titulo']}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18.0)),
                          Padding(
                              padding: EdgeInsets.only(bottom: 10.0),
                              child: Text("${document.data['descripcion']}")),
                          adjuntosPost,
                          document.data['nombreMapa'] != null
                              ? GestureDetector(
                                  onTap: () => launchMapsUrl(
                                      document.data['latitud'],
                                      document.data['longitud']),
                                  child: Container(
                                    width: double.infinity,
                                    height: 50.0,
                                    decoration: BoxDecoration(
                                        color:
                                            Color.fromRGBO(248, 248, 248, 1)),
                                    child: Row(children: <Widget>[
                                      Padding(
                                          padding: EdgeInsets.only(bottom: 2.0),
                                          child: IconButton(
                                            //Map
                                            icon: Icon(Icons.place),
                                            color: Color.fromRGBO(232, 3, 3, 1),
                                            onPressed: () {},
                                          )),
                                      Padding(
                                          padding: EdgeInsets.only(right: 10.0),
                                          child: Text(
                                              document.data['nombreMapa'],
                                              overflow: TextOverflow.ellipsis))
                                    ]),
                                  ))
                              : Container()
                        ])))),
            Padding(
                padding: EdgeInsets.only(top: 25.0),
                child: Container(
                    width: 55,
                    height: 55,
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: new NetworkImage("${_imageAvatar}"))))),
          ],
        )));
      });

      setState(() {
        _listPost = new List.from(_listPost)..addAll(listPost);
        _ultimosPost = lista.length < lote ? true : false;
        _cargandoSigPosts = false;
      });
    });
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
