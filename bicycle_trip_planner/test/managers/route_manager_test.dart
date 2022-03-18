import 'package:bicycle_trip_planner/models/geometry.dart';
import 'package:bicycle_trip_planner/models/place.dart';
import 'package:bicycle_trip_planner/models/route.dart';
import 'package:bicycle_trip_planner/models/stop.dart';
import 'package:test/test.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';

void main() {
  final routeManager = RouteManager();

  // ************ Helper functions ***************

  Place createPlace(String name, String id) {
    return Place(
        geometry: const Geometry.geometryNotFound(),
        name: name,
        placeId: id,
        description: "description");
  }

  setUp(() {
    routeManager.clear();
  });

  test('ensure that group size is 1 when initialized', () {
    expect(routeManager.getGroupSize(), 1);
  });

  test('ensure that group size can be set when needed', () {
    routeManager.setGroupSize(2);
    expect(routeManager.getGroupSize(), 2);
  });

  test('ensure optimised is true when initialized', () {
    expect(routeManager.ifOptimised(), true);
  });

  test('ensure optimised can be toggled when requested', () {
    routeManager.toggleOptimised();
    expect(routeManager.ifOptimised(), false);
  });

  test('ensure that start is empty when initialized', () {
    expect(routeManager.getStart().getStop(), const Place.placeNotFound());
  });

  test('ensure that destination is empty when initialized', () {
    expect(
        routeManager.getDestination().getStop(), const Place.placeNotFound());
  });

  test('ensure that waypoints are empty when initialized', () {
    expect(routeManager.getWaypoints().length, 0);
  });

  test('ensure that start is changed when requested', () {
    Place start = createPlace("start", "1");
    routeManager.changeStart(start);
    expect(routeManager.getStart().getStop(), start);
    expect(routeManager.getStart().getStop().placeId, "1");
    expect(routeManager.ifChanged(), true);
    expect(routeManager.ifStartSet(), true);
  });

  test('ensure that start can be cleared when requested', () {
    Place start = createPlace("start", "1");
    routeManager.changeStart(start);
    routeManager.clearStart();
    expect(routeManager.getStart().getStop(), const Place.placeNotFound());
    expect(routeManager.ifChanged(), true);
    expect(routeManager.ifStartSet(), false);
  });

  test('ensure that destination is changed when requested', () {
    Place end = createPlace("end", "1");
    routeManager.changeDestination(end);
    expect(routeManager.getDestination().getStop(), end);
    expect(routeManager.getDestination().getStop().placeId, "1");
    expect(routeManager.ifChanged(), true);
    expect(routeManager.ifDestinationSet(), true);
  });

  test('ensure that destination can be cleared when requested', () {
    Place end = createPlace("end", "1");
    routeManager.changeDestination(end);
    routeManager.clearDestination();
    expect(
        routeManager.getDestination().getStop(), const Place.placeNotFound());
    expect(routeManager.ifDestinationSet(), false);
  });

  test('ensure that can add waypoint when requested', () {
    expect(routeManager.getWaypoints().length, 0);
    routeManager.addWaypoint(const Place.placeNotFound());
    expect(routeManager.getWaypoints().length, 1);
    expect(routeManager.ifWaypointsSet(), true);
  });

  test(
      'ensure that number of waypoints do not changed when existing id is changed',
      () {
    Stop waypoint = routeManager.addWaypoint(const Place.placeNotFound());
    expect(routeManager.getWaypoints().length, 1);
    Place place = createPlace("waypoint", "1");
    routeManager.changeWaypoint(waypoint.getUID(), place);
    expect(routeManager.getWaypoints().length, 1);
  });

  test('ensure can clear waypoint using id', () {
    Place place = createPlace("waypoint", "1");
    Stop waypoint = routeManager.addWaypoint(place);
    expect(routeManager.getWaypoints().length, 1);
    routeManager.clearStop(waypoint.getUID());
    expect(routeManager.getStop(waypoint.getUID()).getStop(),
        const Place.placeNotFound());
    expect(routeManager.getWaypoints().length, 1);
  });

  test('ensure can remove waypoint using id', () {
    Place place = createPlace("waypoint", "1");
    Stop waypoint = routeManager.addWaypoint(place);
    expect(routeManager.getWaypoints().length, 1);
    routeManager.removeStop(waypoint.getUID());
    expect(routeManager.getWaypoints().length, 0);
  });

  test('ensure can clear waypoints when requested', () {
    routeManager.addWaypoint(const Place.placeNotFound());
    routeManager.addWaypoint(const Place.placeNotFound());
    routeManager.addWaypoint(const Place.placeNotFound());
    expect(routeManager.getWaypoints().length, 3);
    routeManager.removeWaypoints();
    expect(routeManager.getWaypoints().length, 0);
  });

  test('ensure clear changed clears changes', () {
    routeManager.changeStart(const Place.placeNotFound());
    expect(routeManager.ifChanged(), true);
    routeManager.clearChanged();
    expect(routeManager.ifChanged(), false);
  });

  test('ensure route manager initialises correctly', () {
    expect(routeManager.ifStartFromCurrentLocation(), false);
    expect(routeManager.ifWalkToFirstWaypoint(), false);
    expect(routeManager.ifOptimised(), true);
    expect(routeManager.getStartWalkingRoute(), Route.routeNotFound());
    expect(routeManager.getBikingRoute(), Route.routeNotFound());
    expect(routeManager.getEndWalkingRoute(), Route.routeNotFound());
  });

  //TODO: Create dummy routes for walk, bike and end
  test('ensure route manager sets routes correctly', () {
    routeManager.setRoutes(
        Route.routeNotFound(), Route.routeNotFound(), Route.routeNotFound());
  });

  // TODO: test all functions below

  // void setDirectionsData(R.Route route) {
  //   List<Steps> directionsPassByValue = [];
  //   for (var step in route.directions) {
  //     directionsPassByValue.add(Steps.from(step));
  //   }
  //   _directionManager.setDirections(directionsPassByValue);
  //   _directionManager.setDuration(route.duration);
  //   _directionManager.setDistance(route.distance);
  // }

  // Test setCurrentRoute by checking that the polylines in polylineManager match currentRoute

  // void setCurrentRoute(R.Route route, [relocateMap = true]) {
  //   setDirectionsData(route);
  //   _polylineManager.setPolyline(
  //       route.polyline.points, route.routeType.polylineColor);
  //   if (relocateMap) {
  //     _moveCameraTo(route);
  //   }
  // }

  // bool ifRouteSet() {
  //   return _startWalkingRoute != R.Route.routeNotFound() &&
  //       _endWalkingRoute != R.Route.routeNotFound() &&
  //       _bikingRoute != R.Route.routeNotFound();
  // }

  // TODO: Check that all polylines are setted in polyline manager...

  // void showAllRoutes([bool relocateMap = true]) {
  //   _polylineManager.clearPolyline();
  //   _polylineManager.addPolyline(_startWalkingRoute.polyline.points,
  //       _startWalkingRoute.routeType.polylineColor);
  //   _polylineManager.addPolyline(
  //       _bikingRoute.polyline.points, _bikingRoute.routeType.polylineColor);
  //   _polylineManager.addPolyline(_endWalkingRoute.polyline.points,
  //       _endWalkingRoute.routeType.polylineColor);

  //   int duration = 0;
  //   double distance = 0;

  //   duration += _startWalkingRoute.duration;
  //   distance += _startWalkingRoute.distance;

  //   duration += _bikingRoute.duration;
  //   distance += _bikingRoute.distance;

  //   duration += _endWalkingRoute.duration;
  //   distance += _endWalkingRoute.distance;

  //   _directionManager.setDuration(duration);
  //   _directionManager.setDistance(distance);

  //   if (relocateMap) {
  //     _moveCameraTo(_bikingRoute);
  //   }
  // }

  // void toggleWalkToFirstWaypoint() {
  //   _walkToFirstWaypoint = !_walkToFirstWaypoint;
  //   _pathway.toggleHasFirstWaypoint();
  //   _changed = true;
  // }

  // void setWalkToFirstWaypoint(bool ifWalk) {
  //   _walkToFirstWaypoint = ifWalk;
  //   _pathway.setHasFirstWaypoint(ifWalk);
  //   _changed = true;
  // }
}
