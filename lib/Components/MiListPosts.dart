import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sandbox_flutter/Components/MiCard.dart';
import 'package:sandbox_flutter/Components/MiImage.dart';

import 'package:sandbox_flutter/Components/MiLikes.dart';
import 'package:sandbox_flutter/Components/MiComments.dart';
import 'package:sandbox_flutter/Entities/Posts.dart';
import 'package:sandbox_flutter/MyFunctionalities/MyMapPicker/MyGeolocation.dart';

class MiListPosts extends StatefulWidget {
  final Map<String,dynamic> filters;

  MiListPosts({Key key, this.filters}) : super(key: key);

  @override
  _MiListPostsState createState() => _MiListPostsState();
}

class _MiListPostsState extends State<MiListPosts> {
  List<Widget> _listPost = new List();
  int lote = 5; //Definición por defecto
  bool _ultimosPost = false;
  bool _cargandoSigPosts = true;

  @override
  initState() {
    super.initState();

    Posts.onFireStoreChange().listen((data) {
      setState(() {
        _listPost = []; // Volvemos a cargar cuando se agrega uno nuevo
      });
      _actualizarPublicaciones();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(245, 245, 245, 1)
      ),
        child: _listPost.length > 0
            ? Stack(children: <Widget>[
                Container(
                  height: double.infinity,
                  width: 8.0,
                  color: Colors.white,
                  margin: const EdgeInsets.only(left: 28.0, right: 28.0),
                ),
                ListView(children: <Widget>[
                  Column(
                    children: _listPost,
                  ),
                  _cargandoSigPosts == true
                      ? Center(
                          child: SizedBox(
                            child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color.fromRGBO(67, 170, 139, 1)),),
                            height: 20.0,
                            width: 20.0,
                          ),
                        )
                      : Container(),
                  _ultimosPost == false && _cargandoSigPosts == false
                      ? Padding(
                          padding: EdgeInsets.only(left: 65.0, right: 5.0),
                          child: FlatButton(
                            child: Text("VER MÁS...", style: TextStyle(color: Color.fromRGBO(67, 170, 139, 1)),),
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
            : 
            _cargandoSigPosts == false ?
              Center(
                child: Text("No hay publicaciones.")
              )
            : Center(
                child: SizedBox(
                  child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color.fromRGBO(67, 170, 139, 1)),),
                  height: 50.0,
                  width: 50.0,
                ),
              ));
  }

  _actualizarPublicaciones() {
    var service;
    
    //Por defecto paginacion (lote) de 5
    var pagina = (_listPost.length / lote).ceil() + 1;
    service = Posts.allPosts(pagina, lote, widget.filters);
    
    service.then((result) {
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
                    uidUser: "${document.data['uidUser']}",
                    date: "${document.data['fecha']}",
                    width: 300.0,
                    content: Column(children: <Widget>[
                          Text("${document.data['titulo']}",
                              style: TextStyle(
                                color: Color.fromRGBO(67, 170, 139, 1),
                                fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold, fontSize: 18.0)),
                          Padding(
                              padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
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
                        ]))),
            Padding(
                padding: EdgeInsets.only(top: 8.0, left: 4.0),
                child: Container(
                    width: 55,
                    height: 55,
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      border: new Border.all(color: Colors.white, width: 4.0),
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
