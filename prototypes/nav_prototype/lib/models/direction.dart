import 'package:nav_prototype/models/legs.dart';
import 'package:nav_prototype/models/bounds.dart';
import 'package:nav_prototype/models/overview_polyline.dart';

class Direction {
  final Bounds bounds;
  final Legs legs;
  final OverviewPolyline polyline;

  Direction({this.bounds, this.legs, this.polyline});

  factory Direction.fromJson(Map<String, dynamic> parsedJson) {
    return Direction(
      bounds: Bounds.fromJson(parsedJson['bounds']),
      legs: Legs.fromJson(parsedJson['legs'][0]),
      polyline: OverviewPolyline.fromJson(parsedJson['overview_polyline']),
    );
  }
}
