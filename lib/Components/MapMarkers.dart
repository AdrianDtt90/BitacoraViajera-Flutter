import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sandbox_flutter/Entities/Maps.dart';
import 'package:sandbox_flutter/Screens/listPosts.dart';

class MapMarkers extends StatefulWidget {
  List<Map<String, dynamic>> markers;

  MapMarkers({Key key, this.markers}) : super(key: key);

  @override
  State<MapMarkers> createState() => MapMarkersState();
}

class MapMarkersState extends State<MapMarkers> {
  GoogleMapController mapController;
  int count = 0;
  double _lat = -27.0000000; //Sydeny Australia
  double _lon = 133.0000000;
  String _text = 'Australia';
  Set<Marker> _marcadores = new Set();

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();

    var service = Maps.allMaps();

    service.then((List<Maps> markador) {
      Set<Marker> marcadores = new Set();

      markador.forEach((Maps mark) {
        var marcador = new Marker(
            markerId: MarkerId("${mark.idMap}"),
            icon: BitmapDescriptor.defaultMarker,
            position: LatLng(mark.lat, mark.lon),
            infoWindow: InfoWindow(
                title: mark.text,
                snippet: "Ver Publicaciones",
                onTap: () {
                  postDeMarkador(mark.text, mark.lat, mark.lon);
                }));

        marcadores.add(marcador);
      });

      setState(() {
        _marcadores = marcadores;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(_lat, _lon),
          zoom: 3.8,
        ),
        markers: _marcadores,
      ),
    );
  }

  void postDeMarkador(String text, double lat, double lon) async {
    Map<String, dynamic> filtros = {
      "markador": {"lat": lat, "lon": lon}
    };

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ListPosts(
              filters: filtros,
              title: '${text}'),
    ));
  }
}
