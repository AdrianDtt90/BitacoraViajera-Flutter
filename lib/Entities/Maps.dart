import 'package:sandbox_flutter/Firebase/QueriesMaps.dart';

class Maps {
  String idMap;
  String text;
  double lat;
  double lon;

  Maps(this.idMap,
  this.text,
  this.lat,
  this.lon);

  Future<Maps> update () {
    return updateMaps(this);
  }

  Future<Maps> delete () {
    return deleteMaps(this);
  }

  //Statics
  static Future<Maps> create (Map<String,dynamic> user) {
    Maps nuevoMaps = new Maps(user['idMap'],
    user['text'],
    user['lat'],
    user['lon'],);
    return insertMaps(nuevoMaps);
  }

  static Future<List<Maps>> allMaps () {
    return getMaps();
  }

  //Json configuration
  Maps.fromJson(Map<String, dynamic> json)
      : idMap = json['idMap'],
        text = json['text'],
        lat = json['lat'],
        lon = json['lon'];

  Map<String, dynamic> toJson() =>
    {
      'idMap': idMap,
      'text': text,
      'lat': lat,
      'lon': lon,
    };
}