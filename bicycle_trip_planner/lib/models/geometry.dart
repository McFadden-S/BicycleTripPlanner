import 'package:bicycle_trip_planner/models/location.dart';

class Geometry {
  final Location location;

  Geometry({required this.location});

  const Geometry.geometryNotFound({this.location = const Location.locationNotFound()});

  factory Geometry.fromJson(Map<dynamic, dynamic> parsedJson) {
    return Geometry(location: Location.fromJson(parsedJson['location']));
  }
}
