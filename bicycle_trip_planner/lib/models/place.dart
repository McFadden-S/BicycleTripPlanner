import 'package:bicycle_trip_planner/models/geometry.dart';

class Place {
  final Geometry geometry;
  final String name;
  final String placeId;

  Place({required this.geometry, required this.name, required this.placeId});

  factory Place.fromJson(Map<String, dynamic> parsedJson) {
    return Place(
        geometry: Geometry.fromJson(parsedJson['geometry']),
        name: parsedJson['formatted_address'],
        placeId: parsedJson['place_id'],
    );
  }
}
