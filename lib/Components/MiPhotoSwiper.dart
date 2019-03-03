import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'package:sandbox_flutter/Components/MiComments.dart';

class MiPhotoSwiper extends StatefulWidget {
  final String date;
  final double width;
  final double height;
  final dynamic content;

  MiPhotoSwiper({Key key, this.date, this.width, this.height, this.content})
      : super(key: key);

  @override
  _MiPhotoSwiperState createState() => _MiPhotoSwiperState();
}

class _MiPhotoSwiperState extends State<MiPhotoSwiper> {
  bool _favourite = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: Column(children: <Widget>[
        Center(child: Text(widget.date)),
        Swiper(
          itemBuilder: (BuildContext context, int index) {
            return Container(
                color: Colors.transparent,
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[Text('Foto ${index}')],
                  ),
                ));
          },
          pagination: new SwiperCustomPagination(
              builder: (BuildContext context, SwiperPluginConfig config) {
            return new Container(width: 0, height: 0);
          }),
          itemCount: 5,
          itemWidth: 300.0,
          itemHeight: 400.0,
          layout: SwiperLayout.STACK,
        ),
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
                                builder: (context) =>
                                    PostComments(post: 'Post ${widget.key}')),
                          );
                        });
                      },
                    )),
              ],
            ))
      ]),
    );
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
        body: MiComments()
    );
  }
}