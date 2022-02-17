import 'package:bicycle_trip_planner/models/legs.dart';
import 'package:bicycle_trip_planner/models/bounds.dart';
import 'package:bicycle_trip_planner/models/overview_polyline.dart';

class Route {
  final Bounds bounds;
  final Legs legs;
  final OverviewPolyline polyline;

  Route({required this.bounds, required this.legs, required this.polyline});

  factory Route.fromJson(Map<String, dynamic> parsedJson) {
    return Route(
      bounds: Bounds.fromJson(parsedJson['bounds']),
      legs: Legs.fromJson(parsedJson['legs'][0]),
      polyline: OverviewPolyline.fromJson(parsedJson['overview_polyline']),
    );
  }
}
