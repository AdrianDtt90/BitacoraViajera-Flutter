import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:geocoder/geocoder.dart';

class MyGeolocation extends StatefulWidget {
  @override
  _MyGeolocationState createState() => _MyGeolocationState();
}

class _MyGeolocationState extends State<MyGeolocation> {

  @override
  void initState() {
    super.initState();
    calcularDireccion();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  void calcularDireccion () {
    // From a query
    final query = "1600 Amphiteatre Parkway, Mountain View";
    Geocoder.local.findAddressesFromQuery(query).then((addresses){
      var first = addresses.first;
      print("${first.featureName} : ${first.coordinates}");

      _launchMapsUrl(37.421587599999995,-122.08397710000001);
      // // From coordinates
      // final coordinates = new Coordinates(1.10, 45.50);
      // Geocoder.local.findAddressesFromCoordinates(coordinates).then((addresses){
      //   first = addresses.first;
      //   print("${first.featureName} : ${first.addressLine}");
      // });
    });
  }

  void _launchMapsUrl(double lat, double lon) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lon';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}