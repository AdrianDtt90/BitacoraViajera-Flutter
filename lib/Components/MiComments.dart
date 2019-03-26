import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sandbox_flutter/Components/MiGiphy.dart';
import 'package:sandbox_flutter/Components/MiImage.dart';
import 'package:sandbox_flutter/Entities/Users.dart';
import 'package:sandbox_flutter/MyFunctionalities/MyFunctions.dart';

import 'package:sandbox_flutter/Redux/index.dart';
import 'package:sandbox_flutter/Entities/Comments.dart';

class MiComments extends StatefulWidget {
  String idPost;

  MiComments({Key key, this.idPost}) : super(key: key);

  @override
  State createState() => new MiCommentsState();
}

class MiCommentsState extends State<MiComments> {
  var _user;
  String _idPost;
  bool _cargando = true;
  int _cantComments = 0;
  List<Comments> _listaComments = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _idPost = widget.idPost;
    _user = store.state['loggedUser'];

    Comments.onFireStoreChange().listen((data) {
      actualizarComments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(right: 10.0),
        child: Row(children: <Widget>[
          IconButton(
              icon: const Icon(Icons.chat),
              color: Colors.grey,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PostComments(idPost: widget.idPost)),
                );
              }),
          _cargando == true
              ? Text('...')
              : GestureDetector(
                  child: Text(
                      "${_cantComments} ${_cantComments == 1 ? 'Comentario' : 'Comentarios'}"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PostComments(idPost: widget.idPost)),
                    );
                  },
                )
        ]));
  }

  void actualizarComments() {
    Comments.getPostComments(_idPost).then((comments) {
      setState(() {
        _cantComments = comments.length;
        _listaComments = comments;
        _cargando = false;
      });
    });
  }
}

class PostComments extends StatefulWidget {
  String idPost;

  PostComments({Key key, this.idPost}) : super(key: key);

  @override
  State createState() => new PostCommentsState();
}

class PostCommentsState extends State<PostComments> {
  final TextEditingController _chatController = new TextEditingController();
  List<ChatMessage> _messages = <ChatMessage>[];
  var _user;
  String _idPost;
  bool _cargando = true;
  int _cantComentarios = 0;

  bool _onLoad = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _idPost = widget.idPost;
    _user = store.state['loggedUser'];

    Comments.onFireStoreChange().listen((data) {
      int cantComentarios = data.documents.length;

      if ((data.documents[0].data['uidUser'] == _user['uid'] &&
              cantComentarios >= _cantComentarios) ||
          _onLoad) {
        setState(() {
          _cantComentarios = cantComentarios;
        });
        return false;
      }

      setState(() {
        _cantComentarios = cantComentarios;
        _cargando = true;
      });
      actualizarComments();
    });

    actualizarComments();
  }

  void _handleSubmit(String text) {
    _chatController.clear();

    Random rnd = new Random();
    Map<String, dynamic> comment = {
      "idComment": "idComment_${rnd.nextInt(100000000)}",
      "uidUser": _user['uid'],
      "idPost": widget.idPost,
      "comment": text,
      "fecha": getStringDateNow(),
      "timestamp": getDateFromString(getStringDateNow()).millisecondsSinceEpoch
    };
    Comments.create(comment).then((value) {
      ChatMessage message = new ChatMessage(comment: value);

      setState(() {
        _messages.insert(0, message);
      });
    });
  }

  Widget _chatEnvironment(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());

    return IconTheme(
      data: new IconThemeData(color: Color.fromRGBO(67, 170, 139, 1)),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                decoration:
                    new InputDecoration.collapsed(hintText: "Escriba algo..."),
                controller: _chatController,
                onSubmitted: _handleSubmit,
              ),
            ),
            new Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () => _handleSubmit(_chatController.text),
              ),
            ),
            new Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                icon: new Icon(Icons.gif),
                onPressed: () {
                  _enviarGif();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Comentarios'),
        ),
        body: _cargando
            ? Center(
                child: Container(
                    child: SizedBox(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(
                      Color.fromRGBO(67, 170, 139, 1)),
                ),
                height: 50.0,
                width: 50.0,
              )))
            : Column(
                children: <Widget>[
                  new Container(
                    decoration: new BoxDecoration(
                      color: Theme.of(context).cardColor,
                    ),
                    child: _chatEnvironment(context),
                  ),
                  new Divider(
                    height: 1.0,
                  ),
                  _messages.length == 0
                      ? Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Text("No hay comentarios"),
                        )
                      : Container(),
                  new Flexible(
                    child: ListView.builder(
                      padding: new EdgeInsets.all(8.0),
                      reverse: true,
                      itemBuilder: (_, int index) => _messages[index],
                      itemCount: _messages.length,
                    ),
                  ),
                ],
              ));
  }

  void _enviarGif() async {
    final resultUrlGif = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MiGiphy()),
    );

    // if (resultUrlGif != null) {
    //   try {
    //     Random rnd = new Random();
    //     Map<String, dynamic> comment = {
    //       "idComment": "idComment_${rnd.nextInt(100000000)}",
    //       "uidUser": _user['uid'],
    //       "idPost": widget.idPost,
    //       "urlGif": resultUrlGif,
    //       "fecha": getStringDateNow(),
    //       "timestamp":
    //           getDateFromString(getStringDateNow()).millisecondsSinceEpoch
    //     };
    //     Comments.create(comment).then((value) {
    //       ChatMessage message = new ChatMessage(comment: value);

    //       setState(() {
    //         _messages.insert(0, message);
    //       });
    //     });
    //   } catch (e) {
    //     errorGif();
    //   }
    // } else {
    //   errorGif();
    // }
  }

  void errorGif() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Error"),
          content: new Text("Ocurrió un error al intentar enviar el gif."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Cerrar"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    );
  }

  void actualizarComments() {
    Comments.getPostComments(_idPost).then((comments) {
      List<ChatMessage> listaComments = new List();
      comments.forEach((comment) {
        ChatMessage message = new ChatMessage(comment: comment);
        listaComments.add(message);
      });

      setState(() {
        _messages = listaComments;
        _cargando = false;
        _onLoad = false;
      });
    });
  }

  String getStringDateNow() {
    var now = new DateTime.now();
    String addZero(int value) {
      if (value <= 9) {
        return "0${value}";
      }

      return value.toString();
    }

    return "${addZero(now.day)}/${addZero(now.month)}/${addZero(now.year)} ${addZero(now.hour)}:${addZero(now.minute)}";
  }
}

class ChatMessage extends StatelessWidget {
  final Comments comment;

  ChatMessage({this.comment});

  var _user = store.state['loggedUser'];

  @override
  Widget build(BuildContext context) {
    String _imageAvatar = comment != null
        ? (comment.user != null
            ? comment.user.photoUrl.toString()
            : _user['photoUrl'].toString())
        : 'https://cdn.iconscout.com/icon/free/png-256/avatar-375-456327.png';

    return new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: new CircleAvatar(
                child: Container(
                    width: 55,
                    height: 55,
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: new NetworkImage("${_imageAvatar}")))),
              ),
            ),
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Row(
                  //crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    new Text(
                        comment.user != null
                            ? comment.user.displayName
                            : _user['displayName'],
                        style: Theme.of(context).textTheme.subhead),
                    new Padding(
                        padding: EdgeInsets.only(left: 5.0),
                        child: new Text(
                          comment.fecha,
                          style: TextStyle(fontSize: 12.0, color: Colors.grey),
                        )),
                    comment.uidUser == _user['uid']
                        ? GestureDetector(
                            child: Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Icon(
                                  Icons.delete,
                                  size: 20.0,
                                  color: Colors.grey,
                                )),
                            onTap: () {
                              _deleteComment(context, comment.idComment);
                            },
                          )
                        : Container()
                  ],
                ),
                new Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: comment.urlGif != null
                      ? Container(
                          width: MediaQuery.of(context).size.width - 100,
                          height: 100,
                          child: MiImage(
                              currentUrl:
                                  comment.urlGif,
                              fileType: 0,
                              listImages: []))
                      : new Text(comment.comment),
                )
              ],
            )
          ],
        ));
  }

  void _deleteComment(BuildContext context, String idComment) async {
    var result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Eliminación"),
          content: new Text("¿Seguro que quiere eliminar el comentario?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            new FlatButton(
              child: new Text("Si"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (result) {
      Comments.deleteComment(idComment).then((result) {
        if (!result) {
          _mensajeError(context);
        }
      });
    }
  }

  void _mensajeError(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Error"),
          content:
              new Text("Ocurrió un error al intentar eliminar el commentario."),
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
