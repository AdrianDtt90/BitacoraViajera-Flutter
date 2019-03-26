import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:http/http.dart' as http;
import 'package:sandbox_flutter/Components/MiImage.dart';

class MiGiphy extends StatefulWidget {
  List<Map<String, dynamic>> markers;

  MiGiphy({Key key, this.markers}) : super(key: key);

  @override
  State<MiGiphy> createState() => MiGiphyState();
}

class MiGiphyState extends State<MiGiphy> {
  final TextEditingController _searchController = new TextEditingController();
  ScrollController _scrollController = new ScrollController();

  List<Widget> _listaGif = new List();
  int _offset = 0;
  int _limit = 6;
  bool _cargandoGifs = false;
  bool _cargandoInicio = true;
  bool _bottom = true;
  bool _searching = false;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        setState(() {
          _bottom = true;
        });
      }
    });
    getGif();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text('Enviar Gif'),
        ),
        body: _listaGif.length > 0
            ? Column(
                children: <Widget>[
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: new Row(children: <Widget>[
                        new Flexible(
                          child: new TextField(
                              controller: _searchController,
                              decoration: _searching == true
                                  ? InputDecoration(
                                      hintText: "Escriba algo...",
                                      suffixIcon: IconButton(
                                        //Map
                                        icon: Icon(Icons.cancel),
                                        color: Colors.grey,
                                        onPressed: () {
                                          _searchController.text = '';
                                          
                                          setState(() {
                                            _searching = false;
                                            _listaGif = new List();
                                            _offset = 0;
                                            _limit = 6;
                                            _cargandoGifs = false;
                                            _bottom = true;
                                          });
                                          getGif();
                                        },
                                      ))
                                  : InputDecoration(
                                      hintText: "Escriba algo...",
                                    )),
                        ),
                        new Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: new IconButton(
                            icon: new Icon(Icons.search),
                            onPressed: () {
                              setState(() {
                                _searching = true;
                                _listaGif = new List();
                                _offset = 0;
                                _limit = 6;
                                _cargandoGifs = false;
                                _bottom = true;
                              });
                              if (_searchController.text != '') {
                                getGif();
                              }
                            },
                          ),
                        )
                      ])),
                  Expanded(
                    child: GridView.count(
                      controller: _scrollController,
                      // Create a grid with 2 columns. If you change the scrollDirection to
                      // horizontal, this would produce 2 rows.
                      crossAxisCount: 2,
                      // Generate 100 Widgets that display their index in the List
                      children: _listaGif,
                    ),
                  ),
                  _cargandoGifs == true
                      ? Center(
                          child: SizedBox(
                            child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Color.fromRGBO(67, 170, 139, 1)),
                            ),
                            height: 20.0,
                            width: 20.0,
                          ),
                        )
                      : _bottom == true
                          ? FlatButton(
                              child: Text(
                                "VER MÁS...",
                                style: TextStyle(
                                    color: Color.fromRGBO(67, 170, 139, 1)),
                              ),
                              onPressed: () {
                                setState(() {
                                  _cargandoGifs = true;
                                  _bottom = false;
                                });
                                getGif();
                              },
                            )
                          : Container()
                ],
              )
            : _cargandoInicio == true
                ? Center(
                    child: SizedBox(
                      child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            Color.fromRGBO(67, 170, 139, 1)),
                      ),
                      height: 50.0,
                      width: 50.0,
                    ),
                  )
                : Center(
                    child: Text("No se encontraron gifs"),
                  ));
  }

  void getGif() {
    var search = http.get(
        'http://api.giphy.com/v1/gifs/trending?api_key=oDF2CBuue3FPXVA2FWV1vleT5kHPM122&limit=${_limit}&lang=es&offset=${_offset}');

    if (_searchController.text != '') {
      var textSearch = _searchController.text
          .replaceAll(new RegExp(r','), '')
          .replaceAll(new RegExp(r' '), '+');

      search = http.get(
          'http://api.giphy.com/v1/gifs/search?q=${textSearch}&api_key=oDF2CBuue3FPXVA2FWV1vleT5kHPM122&limit=${_limit}&lang=es&offset=${_offset}');
    }

    search.then((response) {
      if (response.statusCode == 200) {
        Map valueMap = json.decode(response.body);

        if (valueMap['data'] != null) {
          List<Widget> listaGif = new List();

          valueMap['data'].forEach((gif) {
            String url = gif['images']['preview_gif']['url'];
            listaGif.add(Center(
                child: MiImage(currentUrl: url, fileType: 0, listImages: [])));
          });

          List<Widget> oldList = _listaGif;
          int oldOffset = _offset;
          int oldLimit = _limit;
          if (_listaGif.length > 0) {
            oldList.removeLast();
          }

          List<Widget> lista = [oldList, listaGif].expand((x) => x).toList();
          setState(() {
            _listaGif = lista;
            _offset = oldOffset + oldLimit;
            _cargandoGifs = false;
            _cargandoInicio = lista.length == 0 ? false : true;
          });
        }
      } else {
        print("Request failed with status: ${response.statusCode}.");
      }
    });
  }
}
