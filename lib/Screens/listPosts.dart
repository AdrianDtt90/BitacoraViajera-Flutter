import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sandbox_flutter/Components/MiListPosts.dart';

class ListPosts extends StatelessWidget {
  final Map<String, dynamic> filters;
  final String title;

  ListPosts({Key key, this.filters, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title != null ? title : 'Lista de Publicaciones'),
        ),
        body: MiListPosts(filters: filters));
  }
}
