import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _idPost = widget.idPost;
    _user = store.state['loggedUser'];
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
              })
        ]));
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _idPost = widget.idPost;
    _user = store.state['loggedUser'];

    Comments.onFireStoreChange().listen((data){
      setState(() {
        _cargando = true;
      });
      actualizarComments();
    });
  }

  void _handleSubmit(String text) {
    _chatController.clear();

    Random rnd = new Random();
    Map<String, dynamic> comment = {
      "idComment": "idComment_${rnd.nextInt(100000000)}",
      "uidUser": _user['uid'],
      "displayName": _user['displayName'],
      "photoUrl": _user['photoUrl'],
      "idPost": widget.idPost,
      "comment": text,
      "fecha": getStringDateNow()
    };
    Comments.create(comment).then((value) {
      ChatMessage message = new ChatMessage(comment: value);

      setState(() {
        _messages.insert(0, message);
      });
    });
  }

  Widget _chatEnvironment() {
    return IconTheme(
      data: new IconThemeData(color: Colors.blue),
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
                child: CircularProgressIndicator(),
                height: 50.0,
                width: 50.0,
              )))
            : Column(
                children: <Widget>[
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
                  new Divider(
                    height: 1.0,
                  ),
                  new Container(
                    decoration: new BoxDecoration(
                      color: Theme.of(context).cardColor,
                    ),
                    child: _chatEnvironment(),
                  )
                ],
              ));
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

  @override
  Widget build(BuildContext context) {
    String _imageAvatar = comment != null
        ? comment.photoUrl.toString()
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
                    new Text(comment.displayName,
                        style: Theme.of(context).textTheme.subhead),
                    new Padding(
                        padding: EdgeInsets.only(left: 5.0),
                        child: new Text(
                          comment.fecha,
                          style: TextStyle(fontSize: 12.0, color: Colors.grey),
                        ))
                  ],
                ),
                new Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: new Text(comment.comment),
                )
              ],
            )
          ],
        ));
  }
}
