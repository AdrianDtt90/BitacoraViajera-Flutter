import 'package:flutter/material.dart';

import 'package:sandbox_flutter/Components/MiLikes.dart';
import 'package:sandbox_flutter/Components/MiComments.dart';
import 'package:sandbox_flutter/Entities/Posts.dart';
import 'package:sandbox_flutter/Redux/index.dart';

class MiCard extends StatefulWidget {
  final String idPost;
  final String uidUser;
  final String date;
  final double width;
  final double height;
  final dynamic content;

  MiCard(
      {Key key,
      this.idPost,
      this.uidUser,
      this.date,
      this.width,
      this.height,
      this.content})
      : super(key: key);

  @override
  _MiCardState createState() => _MiCardState();
}

class _MiCardState extends State<MiCard> {
  bool _favourite = false;
  bool _comments = false;

  String _user = store.state['loggedUser']['uid'];

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
        child: Column(
          children: <Widget>[
            SizedBox(
                width: double.infinity,
                height: widget.height,
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 4.0, right: 4.0),
                        child:Container(
                        width: double.infinity,
                        child: Text(
                          widget.date,
                          textAlign: TextAlign.right,
                          style: TextStyle(color: Colors.grey),
                        ),
                      )),
                      Container(child: widget.content)
                    ],
                  ),
                )),
            Container(
                margin: const EdgeInsets.only(left: 10.0),
                child: Row(
                  children: <Widget>[
                    MiLikes(idPost: widget.idPost),
                    MiComments(idPost: widget.idPost),
                    widget.uidUser == _user
                        ? GestureDetector(
                            child: Icon(
                              Icons.delete,
                              color: Colors.grey,
                            ),
                            onTap: () {
                              _deletePost(widget.idPost);
                            },
                          )
                        : Container()
                  ],
                ))
          ],
        ));
  }

  void _deletePost(String idPost) async {
    var result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Eliminación"),
          content: new Text("¿Seguro que quiere eliminar el post?"),
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
      Posts.deletePost(idPost).then((result) {
        if (!result) {
          _mensajeError();
        }
      });
    }
  }

  void _mensajeError() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Error"),
          content: new Text("Ocurrió un error al intentar eliminar el post."),
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
