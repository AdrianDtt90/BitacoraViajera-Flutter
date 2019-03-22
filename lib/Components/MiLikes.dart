import 'dart:math';

import 'package:flutter/material.dart';

import 'package:sandbox_flutter/Redux/index.dart';
import 'package:sandbox_flutter/Entities/Likes.dart';

class MiLikes extends StatefulWidget {
  String idPost;

  MiLikes({Key key, this.idPost}) : super(key: key);

  @override
  _MiLikesState createState() => _MiLikesState();
}

class _MiLikesState extends State<MiLikes> {
  bool _cargando = true;
  bool _like = false;
  int _cantLikes = 0;
  var _user;
  String _idPost;
  List<Likes> _listaLikes = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _idPost = widget.idPost;
    _user = store.state['loggedUser'];

    Likes.onFireStoreChange().listen((data) {
      actualizarLikes();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Container(
        margin: const EdgeInsets.only(right: 10.0),
        child: Row(children: <Widget>[
          IconButton(
            icon: _like ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
            color: Colors.red,
            onPressed: () {
              if (_like) {
                Likes.deleteLike(widget.idPost, _user['uid']).then((value) {
                  actualizarLikes();
                });
              } else {
                Random rnd = new Random();

                Map<String, dynamic> like = {
                  "idLike": "idLike_${rnd.nextInt(100000000)}",
                  "uidUser": _user['uid'],
                  "idPost": widget.idPost,
                };
                Likes.create(like).then((value) {
                  actualizarLikes();
                });
              }
              setState(() {
                _like = _like ? false : true;
                _cantLikes = _like
                    ? _cantLikes + 1
                    : _cantLikes > 0 ? _cantLikes - 1 : 0;
              });
            },
          ),
          _cargando == true ?
            Text('...')
          : GestureDetector(
            child: Text(
                "${_cantLikes} Me ${_cantLikes == 1 ? 'Gusta' : 'Gustas'}"),
            onTap: () {
              if(_cargando == true) return false;
              
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LikesList(listaLikes: _listaLikes)),
              );
            },
          )
        ]));
  }

  void actualizarLikes() {
    Likes.getPostLikes(_idPost).then((likes) {
      int count = 0;
      bool likeUidUset = false;

      likes.forEach((like) {
        if (like.uidUser == _user['uid']) {
          likeUidUset = true;
        }

        count++;
      });

      setState(() {
        _like = likeUidUset;
        _cantLikes = count;
        _listaLikes = likes;
        _cargando = false;
      });
    });
  }
}

class LikesList extends StatelessWidget {
  List<Likes> listaLikes = new List();

  LikesList({Key key, this.listaLikes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Me Gustas'),
        ),
        body: listaLikes == null || listaLikes.length == 0
            ? Center(
                child: Text("No hay me gustas"),
              )
            : ListView(
                children: getUsersLikes(),
              ));
  }

  List<ListTile> getUsersLikes() {
    List<ListTile> listResult = new List();
    listaLikes.forEach((like) {
      String _imageAvatar = like != null
          ? like.user.photoUrl.toString()
          : 'https://cdn.iconscout.com/icon/free/png-256/avatar-375-456327.png';

      var itemList = ListTile(
        contentPadding: EdgeInsets.all(10.0),
        leading: Container(
            width: 55,
            height: 55,
            decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                    fit: BoxFit.fill,
                    image: new NetworkImage("${_imageAvatar}")))),
        title: Text("${like.user.displayName}"),
      );

      listResult.add(itemList);
    });

    return listResult;
  }
}
