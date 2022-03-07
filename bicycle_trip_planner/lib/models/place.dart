import 'package:bicycle_trip_planner/models/geometry.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  // TODO: Make getLatLng for geometry 
  LatLng getLatLng(){
    return LatLng(geometry.location.lat, geometry.location.lng);
  }
}
