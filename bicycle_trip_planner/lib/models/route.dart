import 'package:bicycle_trip_planner/models/legs.dart';
import 'package:bicycle_trip_planner/models/bounds.dart';
import 'package:bicycle_trip_planner/models/overview_polyline.dart';

class Route {
  final Bounds bounds;
  final List<Legs> legs;
  final OverviewPolyline polyline;

  Route({required this.bounds, required this.legs, required this.polyline});

  Route.routeNotFound(
      {this.bounds = const Bounds.boundsNotFound(),
      this.legs = const <Legs>[],
      this.polyline = const OverviewPolyline.overviewPolylineNotFound()});

  factory Route.fromJson(Map<String, dynamic> parsedJson) {
    //TODO Find more suitable name than substitute 'xLegs'
    List<Legs> xLegs = [];
    for (var x = 0; x < parsedJson['legs'].length; x++) {
      xLegs.add(Legs.fromJson(parsedJson['legs'][x]));
    }

    return Route(
      bounds: Bounds.fromJson(parsedJson['bounds']),
      legs: xLegs,
      polyline: OverviewPolyline.fromJson(parsedJson['overview_polyline']),
    );
  }

  @override
  String toString() {
    return legs.toString();
  }

  @override
  bool operator ==(Object other) {
    return other is Route &&
        other.bounds == bounds &&
        other.polyline == polyline &&
        other.legs == legs;
  }

  @override
  // TODO: implement hashCode
  int get hashCode => Object.hash(bounds, polyline, legs);
}
