import 'package:bicycle_trip_planner/models/legs.dart';
import 'package:bicycle_trip_planner/models/bounds.dart';
import 'package:bicycle_trip_planner/models/overview_polyline.dart';
import 'package:bicycle_trip_planner/models/route_types.dart';
import 'package:bicycle_trip_planner/models/steps.dart';

class Route {
  final Bounds bounds;
  final List<Legs> legs;
  final OverviewPolyline polyline;
  final RouteType routeType;
  List<Steps> directions = [];
  double distance = 0;
  int duration = 0;

  /// constructor with specified required inputs
  Route(
      {required this.bounds,
      required this.legs,
      required this.polyline,
      required this.routeType}) {
    for (Legs leg in legs) {
      duration += leg.duration;
      distance += leg.distance;
      directions += leg.steps;
    }
  }

  /// constructor default assignments when route is not found
  Route.routeNotFound(
      {this.bounds = const Bounds.boundsNotFound(),
      this.legs = const <Legs>[],
      this.routeType = RouteType.none,
      this.polyline = const OverviewPolyline.overviewPolylineNotFound()});

  /// factory constructor when data is passed from Json
  /// @param Map<String, dynamic> parsed Json
  factory Route.fromJson(Map<String, dynamic> parsedJson, RouteType routeType) {
    List<Legs> xLegs = [];
    for (var x = 0; x < parsedJson['legs'].length; x++) {
      xLegs.add(Legs.fromJson(parsedJson['legs'][x]));
    }

    return Route(
        bounds: Bounds.fromJson(parsedJson['bounds']),
        legs: xLegs,
        polyline: OverviewPolyline.fromJson(parsedJson['overview_polyline']),
        routeType: routeType);
  }

  /// method override the toString method
  /// @return String of the toString of the object
  @override
  String toString() {
    return legs.toString();
  }

  /// method override the == operator
  /// @return bool of whether the object is same or not
  @override
  bool operator ==(Object other) {
    return other is Route &&
        other.bounds == bounds &&
        other.polyline == polyline &&
        other.legs == legs;
  }

  /// method override the get hashCode method
  /// @return int of the hashCode
  @override
  int get hashCode => Object.hash(bounds, polyline, legs);
}
