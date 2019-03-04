import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:sandbox_flutter/MyFunctionalities/MyMapPicker/MyAutocompleteAdress.dart';
import 'package:sandbox_flutter/MyFunctionalities/MyMapPicker/MyGeolocation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyMapPicker extends StatefulWidget {
  @override
  _MyMapPickerState createState() => _MyMapPickerState();
}

class _MyMapPickerState extends State<MyMapPicker> {
  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey();

  //Valores por defecto
  double _lat = -33.865143; //Sydeny Australia
  double _lon = 151.209900;
  String _text = 'Sydney, Australia';
  bool _resultFound = true;

  //Devolviendo mapa seleccionado
  void acceptMap() {
    Map<String, dynamic> result = {
      "text": _text,
      "lat": _lat,
      "lon": _lon,
    };
    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldState,
        appBar: AppBar(
          title: Text('Selección de sitio'),
        ),
        body: Stack(
          children: <Widget>[
            MapSample(text: _text, lat: _lat, lon: _lon),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                  alignment: Alignment.topRight,
                  child: FloatingActionButton(
                    onPressed: () {
                      _setLatLon();
                    },
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    child: const Icon(Icons.search, size: 36.0),
                  )),
            ),
            Padding(
                padding: EdgeInsets.only(
                    top: 90.0, left: 16.0, right: 16.0, bottom: 16.0),
                child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                        width: 55,
                        height: 55,
                        decoration: new BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          color: Colors.white,
                          icon: Icon(Icons.check, size: 36.0),
                          tooltip: 'Increase volume by 10',
                          onPressed: () {
                            acceptMap();
                          },
                        )))),
            _resultFound == false
                ? _mostrarMensajeNoFound(context)
                : Container()
          ],
        ));
  }

  Widget _mostrarMensajeNoFound(BuildContext context) {
    scaffoldState.currentState.showSnackBar(
        new SnackBar(content: new Text('No se encontró el sitio buscado')));
    setState(() {
      _resultFound = true;
    });
    return Container();
  }

  void _setLatLon() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchAddress()),
    );

    if (result != null) {
      setState(() {
        _resultFound = true;
        _text = result['text'];
        _lat = result['lat'];
        _lon = result['lon'];
      });
    } else {
      setState(() {
        _resultFound = false;
      });
    }
  }
}

class MapSample extends StatefulWidget {
  String text;
  double lat;
  double lon;

  MapSample(
      {Key key,
      this.text: 'Sydney, Australia',
      this.lat: -33.865143,
      this.lon: 151.209900})
      : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  GoogleMapController mapController;
  int count = 0;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var marcador = new Marker(
        markerId: MarkerId("1"),
        icon: BitmapDescriptor.defaultMarker,
        position: LatLng(widget.lat, widget.lon),
        infoWindow:
            InfoWindow(title: widget.text, snippet: "Dirección seleccionada"));

    Set<Marker> marcadores = new Set();
    marcadores.add(marcador);

    //El contados es para que la primera vez no se ejecute
    if (count > 0) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(widget.lat, widget.lon), zoom: 11.0),
        ),
      );
    }
    count = count + 1;

    return new Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.lat, widget.lon),
          zoom: 11.0,
        ),
        markers: marcadores,
      ),
    );
  }
}

class SearchAddress extends StatefulWidget {
  @override
  _SearchAddressState createState() => _SearchAddressState();
}

class _SearchAddressState extends State<SearchAddress> {
  TextEditingController _controller = TextEditingController();

  List<Widget> _listSugerencias;
  int _amountText = 0;
  bool _isButtonDisabled = true;

  double _lat;
  double _lon;

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      //print(_controller.text);
      _amountText = _amountText + 1;

      Timer(new Duration(seconds: 1), () {
        if (_amountText >= 3) {
          _amountText = 0;

          //Consumimos API
          getSugerencia(_controller.text);
        }
        _amountText = 0;
      });

      setState(() {
        _isButtonDisabled = true;
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
              : Container(),
          Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: RaisedButton(
                child: _isButtonDisabled
                    ? Text("Esperando selección...")
                    : Text("Buscar direción"),
                onPressed: () async {
                  if (_isButtonDisabled == true) return false;

                  var result = await calcularDireccion(_controller.text);

                  if (result != null) {
                    Map<String, dynamic> coordenadas = {
                      "text": _controller.text,
                      "lat": result['lat'],
                      "lon": result['lon'],
                    };

                    Navigator.pop(context, coordenadas);
                  } else {
                    //No se encontró sitio
                    Navigator.pop(context, null);
                  }
                },
              ))
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
          setState(() {
            _listSugerencias = [];
            _isButtonDisabled = false;
          });
        },
      ));
    });

    setState(() {
      _listSugerencias = listSugerencias;
    });
  }
}
