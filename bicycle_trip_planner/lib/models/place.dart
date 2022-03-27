import 'package:bicycle_trip_planner/models/geometry.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Place {
  final Geometry geometry;
  final String name;
  final String placeId;
  final String description;

  /// constructor with specified required inputs
  Place(
      {required this.geometry,
      required this.name,
      required this.placeId,
      required this.description});

  /// constructor default assignments when place is not found
  const Place.placeNotFound(
      {this.geometry = const Geometry.geometryNotFound(),
      this.name = "",
      this.placeId = "",
      this.description = ""});

  /// factory constructor when data is passed from Json
  /// @param Map<String, dynamic> parsed Json
  factory Place.fromJson(Map<String, dynamic> parsedJson, String description) {
    return Place(
      geometry: Geometry.fromJson(parsedJson['geometry']),
      name: parsedJson['formatted_address'],
      placeId: parsedJson['place_id'],
      description: description,
    );
  }

  // TODO: Make getLatLng for geometry
  /// @return LatLng coordinates of the place
  LatLng getLatLng() {
    return LatLng(geometry.location.lat, geometry.location.lng);
  }

  /// method override the toString method
  /// @return String of the toString of the object
  @override
  String toString() {
    return description;
  }
}
