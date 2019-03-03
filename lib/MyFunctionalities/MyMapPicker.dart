import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:sandbox_flutter/MyFunctionalities/MyAutocompleteAdress.dart';
import 'package:sandbox_flutter/MyFunctionalities/MyGeolocation.dart';

class MyMapPicker extends StatefulWidget {
  @override
  _MyMapPickerState createState() => _MyMapPickerState();
}

class _MyMapPickerState extends State<MyMapPicker> {
  TextEditingController _controller = TextEditingController();

  List<Widget> _listSugerencias;
  int _amountText = 0;

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      //print(_controller.text);
      _amountText = _amountText + 1;

      Timer(new Duration(seconds: 2), () {
        if (_amountText >= 3) {
          _amountText = 0;

          //Consumimos API
          getSugerencia(_controller.text);
        }
        _amountText = 0;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Selección de sito'),
        ),
        body: ListView(children: <Widget>[
          Container(
              child: Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: TextField(
                      autofocus: true,
                      controller: _controller,
                      maxLength: 25,
                      decoration: InputDecoration(
                          hintText: "Ingrese la dirección...",
                          labelText: "Dirección")))),
          _listSugerencias != null
              ? Column(children: _listSugerencias)
              : Container()
        ]));
  }

  void getSugerencia(String valueAddress) async {
    var result = await getAutocompleteAdress(valueAddress);

    List<ListTile> listSugerencias = new List();

    result['suggestions'].forEach((suggestion) {
      listSugerencias.add(ListTile(
        leading: Icon(Icons.place),
        title: Text(suggestion['label']),
        onTap: () {
          _controller.text = suggestion['label'];
        },
      ));
    });

    setState(() {
      _listSugerencias = listSugerencias;
    });
  }
}
