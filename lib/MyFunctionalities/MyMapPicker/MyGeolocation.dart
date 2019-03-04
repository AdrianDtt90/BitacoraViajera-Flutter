import 'package:url_launcher/url_launcher.dart';

import 'package:geocoder/geocoder.dart';

dynamic calcularDireccion(String address) async {
  // From a query
  try {
    if (address != null && address != '') {
      var query = address;
      var addresses = await Geocoder.local.findAddressesFromQuery(query);
      if (addresses.length > 0) {
        var first = addresses.first;
        print("${first.featureName} : ${first.coordinates}");

        Map<String, dynamic> coordinates = {
          "lat": first.coordinates.latitude,
          "lon": first.coordinates.longitude,
        };

        return coordinates;
      } else {
        return null;
      }
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }

  //latitude, longitude
  //launchMapsUrl(37.421587599999995, -122.08397710000001);

  // // From coordinates
  // final coordinates = new Coordinates(1.10, 45.50);
  // Geocoder.local.findAddressesFromCoordinates(coordinates).then((addresses){
  //   first = addresses.first;
  //   print("${first.featureName} : ${first.addressLine}");
  // });
}

//Buscar en google maps de chrome
void launchMapsUrl(double lat, double lon) async {
  final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lon';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
