import 'package:google_maps_flutter/google_maps_flutter.dart';

class Place {
  final LatLng latlng;
  final String name;
  final String placeId;
  final String description;

  /// constructor with specified required inputs
  Place(
      {required this.latlng,
      required this.name,
      required this.placeId,
      required this.description});

  /// constructor default assignments when place is not found
  const Place.placeNotFound(
      {this.latlng = const LatLng(0, 0),
      this.name = "",
      this.placeId = "",
      this.description = ""});

  /// factory constructor when data is passed from Json
  /// @param Map<String, dynamic> parsed Json
  factory Place.fromJson(Map<String, dynamic> parsedJson, String description) {
    return Place(
      latlng: LatLng(parsedJson['geometry']['location']['lat'], parsedJson['geometry']['location']['lng']),
      name: parsedJson['formatted_address'],
      placeId: parsedJson['place_id'],
      description: description,
    );
  }

  /// @return LatLng coordinates of the place
  LatLng getLatLng() {
    return latlng;
  }

  /// method override the toString method
  /// @return String of the toString of the object
  @override
  String toString() {
    return description;
  }
}
