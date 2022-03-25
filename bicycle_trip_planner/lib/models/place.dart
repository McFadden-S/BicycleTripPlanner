import 'package:bicycle_trip_planner/models/geometry.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Place {
  final Geometry geometry;
  final String name;
  final String placeId;
  final String description;

  Place(
      {required this.geometry,
      required this.name,
      required this.placeId,
      required this.description});

  const Place.placeNotFound(
      {this.geometry = const Geometry.geometryNotFound(),
      this.name = "",
      this.placeId = "",
      this.description = ""});

  factory Place.fromJson(Map<String, dynamic> parsedJson, String description) {
    return Place(
      geometry: Geometry.fromJson(parsedJson['geometry']),
      name: parsedJson['formatted_address'],
      placeId: parsedJson['place_id'],
      description: description,
    );
  }

  // TODO: Make getLatLng for geometry
  LatLng getLatLng() {
    return LatLng(geometry.location.lat, geometry.location.lng);
  }

  @override
  String toString() {
    return description;
  }
}
