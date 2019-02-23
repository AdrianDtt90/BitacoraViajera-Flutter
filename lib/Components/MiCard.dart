import 'package:flutter/material.dart';

class MiCard extends StatelessWidget {
  final String date;
  final double width;
  final double height;
  final dynamic content;

  MiCard({Key key, this.date, this.width, this.height, this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
        child: Column(
          children: <Widget>[
            Center(child: Text(date)),
            SizedBox(
                width: width,
                height: height,
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(child: content),
                    ],
                  ),
                ))
          ],
        ));
  }
}
