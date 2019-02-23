import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class MiPhotoSwiper extends StatelessWidget {
  final String date;
  final double width;
  final double height;
  final dynamic content;

  MiPhotoSwiper({Key key, this.date, this.width, this.height, this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: Column(children: <Widget>[
        Center(child: Text(date)),
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
        )
      ]),
    );
  }
}
