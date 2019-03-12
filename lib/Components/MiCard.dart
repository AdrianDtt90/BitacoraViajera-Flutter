import 'package:flutter/material.dart';

import 'package:sandbox_flutter/Components/MiComments.dart';

class MiCard extends StatefulWidget {
  final String date;
  final double width;
  final double height;
  final dynamic content;

  MiCard({Key key, this.date, this.width, this.height, this.content})
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
                    Container(
                        margin: const EdgeInsets.only(right: 10.0),
                        child: IconButton(
                          icon: _favourite
                              ? Icon(Icons.favorite)
                              : Icon(Icons.favorite_border),
                          color: Colors.red,
                          onPressed: () {
                            setState(() {
                              _favourite = _favourite ? false : true;
                            });
                          },
                        )),
                    Container(
                        margin: const EdgeInsets.only(right: 10.0),
                        child: IconButton(
                          icon: const Icon(Icons.chat),
                          color: Colors.grey,
                          onPressed: () {
                            setState(() {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PostComments(
                                        post: 'Post ${widget.key}')),
                              );
                            });
                          },
                        ))
                  ],
                ))
          ],
        ));
  }
}

class PostComments extends StatefulWidget {
  final String post;

  PostComments({Key key, this.post}) : super(key: key);

  @override
  _PostCommentsState createState() => _PostCommentsState();
}

class _PostCommentsState extends State<PostComments> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${widget.post}'),
        ),
        body: MiComments());
  }
}
