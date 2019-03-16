import 'package:flutter/material.dart';

import 'package:sandbox_flutter/Components/MiLikes.dart';
import 'package:sandbox_flutter/Components/MiComments.dart';

class MiCard extends StatefulWidget {
  final String idPost;
  final String date;
  final double width;
  final double height;
  final dynamic content;

  MiCard({Key key, this.idPost, this.date, this.width, this.height, this.content})
      : super(key: key);

  @override
  _MiCardState createState() => _MiCardState();
}

class _MiCardState extends State<MiCard> {
  bool _favourite = false;
  bool _comments = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              child: Text(
                widget.date,
                textAlign: TextAlign.right,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
                width: double.infinity,
                height: widget.height,
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[Container(child: widget.content)],
                  ),
                )),
            Container(
                margin: const EdgeInsets.only(left: 10.0),
                child: Row(
                  children: <Widget>[
                    MiLikes(idPost: widget.idPost),
                    MiComments(idPost: widget.idPost)
                  ],
                ))
          ],
        ));
  }
}