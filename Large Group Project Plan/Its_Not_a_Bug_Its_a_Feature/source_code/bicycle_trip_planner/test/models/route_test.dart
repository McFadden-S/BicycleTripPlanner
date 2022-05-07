import 'package:bicycle_trip_planner/models/route_types.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test/test.dart';
import 'package:bicycle_trip_planner/models/route.dart';
import 'package:bicycle_trip_planner/models/bounds.dart';
import 'package:bicycle_trip_planner/models/legs.dart';
import 'package:bicycle_trip_planner/models/steps.dart';
import 'package:bicycle_trip_planner/models/overview_polyline.dart';

main() {
  final bounds = Bounds(
      northeast: <String, dynamic>{}, southwest: <String, dynamic>{});
  const startLocation = LatLng(1, -1);
  const endLocation = LatLng(2, -2);
  final steps = Steps(instruction: "right", distance: 1, duration: 1);
  final polyline = OverviewPolyline(points: []);
  final legs = Legs(
      startLocation: startLocation,
      endLocation: endLocation,
      steps: [steps],
      distance: 1,
      duration: 1);
  final route = Route(
      bounds: bounds,
      legs: [legs],
      polyline: polyline,
      routeType: RouteType.walk);
  final route2 = Route(
      bounds: bounds,
      legs: [legs],
      polyline: polyline,
      routeType: RouteType.bike);

  test('ensure bounds is Bounds', () {
    expect(route.bounds.runtimeType, Bounds);
  });

  test('ensure legs is list of Legs', () {
    expect(route.legs.runtimeType, List<Legs>);
  });

  test('ensure polyline is OverviewPolyline', () {
    expect(route.polyline.runtimeType, OverviewPolyline);
  });

  test('ensure overridden toString is correct', () {
    expect(route.toString(), route.legs.toString());
  });

  test('ensure overridden == operator is correct', () {
    expect(route == route2, false);
  });

  test('ensure return the correct hashCode', () {
    expect(route.hashCode, Object.hash(route.bounds, route.polyline, route.legs));
  });

}
