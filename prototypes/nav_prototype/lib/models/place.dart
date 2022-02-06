import 'package:nav_prototype/models/geometry.dart';

class Place {

  final Geometry geometry;
  final String name;
  final String vicinity;

  Place({this.geometry, this.name, this.vicinity});

  factory Place.fromJson(Map<String, dynamic> parsedJson) {
    return Place(
      geometry: Geometry.fromJson(parsedJson['geometry']),
      name: parsedJson['formatted_address'],
      vicinity: parsedJson['vicinity']
    );
  }

}