import 'package:flutter/material.dart';

class MiLoading extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SimpleDialog(
        title: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset("assets/bolso.png")
            ]
          )
        ),
        children: <Widget>[
          Text('Cargando...', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),)
        ],
      ),
      decoration: new BoxDecoration(
        color: const Color.fromRGBO(72, 114, 155, 1),
      ),
    );
  }
}