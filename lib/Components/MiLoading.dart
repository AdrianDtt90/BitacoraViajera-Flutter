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
              SizedBox(
                child: CircularProgressIndicator(),
                height: 50.0,
                width: 50.0,
              )
            ]
          )
        ),
        children: <Widget>[
          Text('Cargando...', textAlign: TextAlign.center)
        ],
      ),
      decoration: new BoxDecoration(
        color: const Color.fromRGBO(88, 183, 251, 0.8),
      ),
    );
  }
}