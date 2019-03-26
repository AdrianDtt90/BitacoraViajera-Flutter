import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MiGiphy extends StatefulWidget {
  List<Map<String, dynamic>> markers;

  MiGiphy({Key key, this.markers}) : super(key: key);

  @override
  State<MiGiphy> createState() => MiGiphyState();
}

class MiGiphyState extends State<MiGiphy> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Enviar Gif'),
      ),
      body: GridView.count(
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this would produce 2 rows.
        crossAxisCount: 2,
        // Generate 100 Widgets that display their index in the List
        children: List.generate(100, (index) {
          return Center(
            child: Text(
              'Item $index',
              style: Theme.of(context).textTheme.headline,
            ),
          );
        }),
      ),
    );
  }
}
