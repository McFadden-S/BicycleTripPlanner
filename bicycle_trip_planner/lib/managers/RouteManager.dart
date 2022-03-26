import 'dart:ui';

import 'package:bicycle_trip_planner/managers/CameraManager.dart';
import 'package:bicycle_trip_planner/managers/DirectionManager.dart';
import 'package:bicycle_trip_planner/managers/MarkerManager.dart';
import 'package:bicycle_trip_planner/managers/NavigationManager.dart';
import 'package:bicycle_trip_planner/managers/PolylineManager.dart';
import 'package:bicycle_trip_planner/models/pathway.dart';
import 'package:bicycle_trip_planner/models/route.dart' as R;
import 'package:bicycle_trip_planner/models/route_types.dart';
import 'package:bicycle_trip_planner/models/steps.dart';
import 'package:bicycle_trip_planner/models/stop.dart';
import 'package:flutter/material.dart';

import '../models/place.dart';

/// Class comment: Route manager is a manager class that updates
/// the route taken during navigation and route planning
class RouteManager {
  //********** Fields **********
  /// Managers needed in route manager
  final PolylineManager _polylineManager = PolylineManager();
  final MarkerManager _markerManager = MarkerManager();
  final DirectionManager _directionManager = DirectionManager();
  final CameraManager _cameraManager = CameraManager.instance;
  Pathway _pathway = Pathway();

  /// True if user is starting from current location
  bool _startFromCurrentLocation = false;

  /// True if user needs to walk to first waypoint
  bool _walkToFirstWaypoint = false;
  bool _loading = false;

  /// The size of the group the user is travelling with
  int _groupsize = 1;

  /// True if route has been changed
  bool _changed = false;

  /// True if user has chosen optimised path
  bool _optimised = true;
  bool _costOptimised = false;

  /// Journey is split into 3 separate routes
  /// Start walking route: Route between user and pickup station
  /// Biking route: Cycling route from pickup station to drop off station
  /// End walking route: Route between drop off station and user destination
  R.Route _startWalkingRoute = R.Route.routeNotFound();
  R.Route _bikingRoute = R.Route.routeNotFound();
  R.Route _endWalkingRoute = R.Route.routeNotFound();

  R.Route _currentRoute = R.Route.routeNotFound();

  //********** Singleton **********

  static final RouteManager _routeManager = RouteManager._internal();

  // @param void
  // @return RouteManager
  factory RouteManager() => _routeManager;

  RouteManager._internal();

  //********** Private **********

  /// @param void
  /// @return void
  /// @effects - Moves camera to start location
  void _moveCameraTo(R.Route route) {
    _cameraManager.goToPlace(
        route.legs.first.startLocation.lat,
        route.legs.first.startLocation.lng,
        route.bounds.northeast,
        route.bounds.southwest);
  }

  //********** Public **********

  /// @param - Route startWalk, Route bike, Route endWalk
  /// @return void
  /// @effects - Sets the journey's routes
  void setRoutes(R.Route startWalk, R.Route bike, R.Route endWalk) {
    _startWalkingRoute = startWalk;
    _bikingRoute = bike;
    _endWalkingRoute = endWalk;
  }

  // Only shows one of the walking route
  //Checks to see which part of the walking journey the user is on and sets that
  //as their current route
  //If relocateMap = true, camera is panned towards that section of the route

  /// @param - bool relocateMap
  /// @return void
  /// @effects - shows current route depending on the part of the journey
  ///            the user is on
  ///            If relocateMap = true, the camera will move to the given route
  void showCurrentWalkingRoute([bool relocateMap = true]) {
    if (_startWalkingRoute != R.Route.routeNotFound()) {
      setCurrentRoute(_startWalkingRoute, relocateMap);
    } else if (_endWalkingRoute != R.Route.routeNotFound()) {
      setCurrentRoute(_endWalkingRoute, relocateMap);
    }
  }

  /// @param - bool relocateMap
  /// @return void
  /// @effects - shows the current route the user  is travelling on
  ///            If relocateMap = true, the camera will move to the given route
  void showCurrentRoute([bool relocateMap = true]) {
    if (_startWalkingRoute != R.Route.routeNotFound()) {
      setCurrentRoute(_startWalkingRoute, relocateMap);
      return;
    }

    if (_bikingRoute != R.Route.routeNotFound()) {
      setCurrentRoute(_bikingRoute, relocateMap);
      return;
    }

    if (_endWalkingRoute != R.Route.routeNotFound()) {
      setCurrentRoute(_endWalkingRoute, relocateMap);
      return;
    }
  }

  /// @param - bool relocateMap
  /// @return void
  /// @effects - shows the bike route
  ///            If relocateMap = true, the camera will move to the biking route
  void showBikeRoute([relocateMap = true]) {
    setCurrentRoute(_bikingRoute, relocateMap);
  }

  /// @param - Route route
  /// @return void
  /// @effects - Set directions based on the given route
  void setDirectionsData(R.Route route) {
    List<Steps> directionsPassByValue = [];
    for (var step in route.directions) {
      directionsPassByValue.add(Steps.from(step));
    }
    _directionManager.setDirections(directionsPassByValue);
    _directionManager.setDuration(route.duration);
    _directionManager.setDistance(route.distance);
  }

  /// @param - bool relocateMap
  /// @return void
  /// @effects - Show all routes using polyline manager
  ///            Update duration and distance to give values for whole journey
  ///            if relocateMap = true, camera will move to the biking route
  void showAllRoutes([bool relocateMap = true]) {
    _polylineManager.clearPolyline();
    _polylineManager.addPolyline(_startWalkingRoute.polyline.points,
        _startWalkingRoute.routeType.polylineColor);
    _polylineManager.addPolyline(
        _bikingRoute.polyline.points, _bikingRoute.routeType.polylineColor);
    _polylineManager.addPolyline(_endWalkingRoute.polyline.points,
        _endWalkingRoute.routeType.polylineColor);

    int duration = 0;
    double distance = 0;

    duration += _startWalkingRoute.duration;
    distance += _startWalkingRoute.distance;

    duration += _bikingRoute.duration;
    distance += _bikingRoute.distance;

    duration += _endWalkingRoute.duration;
    distance += _endWalkingRoute.distance;

    _directionManager.setDuration(duration);
    _directionManager.setDistance(distance);

    if (relocateMap) {
      _moveCameraTo(_bikingRoute);
    }
  }

  void setLoading(bool isLoading) {
    _loading = isLoading;
  }

  bool ifLoading() {
    return _loading;
  }

  /// @param - Route route, bool relocateMap
  /// @return void
  /// @effects - Set directions and polylines to show current route data
  ///            If relocate map = true, camera will move to given route
  void setCurrentRoute(R.Route route, [relocateMap = true]) {
    setDirectionsData(route);
    _polylineManager.setPolyline(
        route.polyline.points, route.routeType.polylineColor);
    _currentRoute = route;
    if (relocateMap) {
      _moveCameraTo(route);
    }
  }

  R.Route getCurrentRoute() {
    return _currentRoute;
  }

  /// @param void
  /// @return bool - if route is set
  bool ifRouteSet() {
    return _startWalkingRoute != R.Route.routeNotFound() &&
        _endWalkingRoute != R.Route.routeNotFound() &&
        _bikingRoute != R.Route.routeNotFound();
  }

  /// @param void
  /// @return int - the group size
  int getGroupSize() {
    return _groupsize;
  }

  /// @param int Size
  /// @return void
  /// @effects - sets group size
  void setGroupSize(int size) {
    if (size > 0) {
      _groupsize = size;
      _changed = true;
    }
  }

  /// @param void
  /// @return bool - if user is walking to first waypoint
  bool ifWalkToFirstWaypoint() {
    return _walkToFirstWaypoint;
  }

  /// @param void
  /// @return void
  /// @effects - toggles walkToFirstWaypoint
  void toggleWalkToFirstWaypoint() {
    _walkToFirstWaypoint = !_walkToFirstWaypoint;
    _pathway.toggleHasFirstWaypoint();
    _changed = true;
  }

  /// @param - bool ifWalk
  /// @return void
  /// @effects - sets walkToFirstWaypoint to ifWalk value
  void setWalkToFirstWaypoint(bool ifWalk) {
    _walkToFirstWaypoint = ifWalk;
    _pathway.setHasFirstWaypoint(ifWalk);
    _changed = true;
  }

  /// @param void
  /// @return bool - if starting from current location
  bool ifStartFromCurrentLocation() {
    return _startFromCurrentLocation;
  }

  /// @param void
  /// @return void
  /// @effects - toggles startFromCurrentLocation
  void toggleStartFromCurrentLocation() {
    _startFromCurrentLocation = !_startFromCurrentLocation;
    _changed = true;
  }

  /// @param bool value
  /// @return void
  /// @effects - sets startFromCurrentLocation to value
  void setStartFromCurrentLocation(bool value) {
    _startFromCurrentLocation = value;
    _changed = true;
  }

  /// @param - bool optimised
  /// @return void
  /// @effects - sets optimised to given value
  void setOptimised(bool optimised) {
    _optimised = optimised;
    _changed = true;
  }

  /// @param void
  /// @return void
  /// @effects - toggles optimised
  void toggleOptimised() {
    _optimised = !_optimised;
    _changed = true;
  }

  /// @param void
  /// @return bool - gets optimised value
  bool ifOptimised() {
    return _optimised;
  }

  void setCostOptimised(bool optimised) {
    _costOptimised = optimised;
    _changed = true;
  }

  void toggleCostOptimised() {
    _costOptimised = !_costOptimised;
    _changed = true;
  }

  bool ifCostOptimised() {
    return _costOptimised;
  }

  /// @param void
  /// @return stop - gets the start stop from pathway
  Stop getStart() => _pathway.getStart();

  /// @param void
  /// @return stop - gets the destination stop from pathway
  Stop getDestination() => _pathway.getDestination();

  /// @param void
  /// @return List<Stop> - gets all waypoints from pathway
  List<Stop> getWaypoints() => _pathway.getWaypoints();

  /// @param void
  /// @return stop - gets the first waypoint from pathway
  Stop getFirstWaypoint() => _pathway.getFirstWaypoint();

  /// @param void
  /// @return List<Stop> - gets list of stops from pathway
  List<Stop> getStops() => _pathway.getStops();

  /// @param - int id
  /// @return stop - gets stop based of id from pathway
  Stop getStop(int id) => _pathway.getStop(id);

  /// @param void
  /// @return stop - gets changed from pathway
  bool ifChanged() => _changed;

  /// @param - int index
  /// @return stop - gets stop based off index from pathway
  Stop getStopByIndex(int index) => _pathway.getStopByIndex(index);

  /// @param void
  /// @return bool - if start is set
  bool ifStartSet() =>
      _pathway.getStart().getStop() != const Place.placeNotFound();

  /// @param void
  /// @return bool - if destination is set
  bool ifDestinationSet() =>
      _pathway.getDestination().getStop() != const Place.placeNotFound();

  /// @param void
  /// @return bool - if firstWaypoint is set
  bool ifFirstWaypointSet() {
    return _pathway.getFirstWaypoint().getStop() != const Place.placeNotFound();
  }

  /// @param void
  /// @return bool - ifWaypoints are set
  bool ifWaypointsSet() => getWaypoints().isNotEmpty;

  /// @param - Place start
  /// @return void
  /// @effects - Changes the start in the pathway
  void changeStart(Place start) {
    _pathway.changeStart(start);
    _changed = true;
  }

  /// @param - Place destination
  /// @return void
  /// @effects - Changes the destination in the pathway
  void changeDestination(Place destination) {
    _pathway.changeDestination(destination);
    _changed = true;
  }

  /// @param - int id, Place stop
  /// @return void
  /// @effects - Replaces the stop at a certain id with another stop
  void changeStop(int id, Place stop) {
    _pathway.changeStop(id, stop);
    _changed = true;
  }

  /// @param - int stop1ID, int stop2ID
  /// @return void
  /// @effects - Changes the position of 2 stops in the pathway
  void swapStops(int stop1ID, int stop2ID) {
    _pathway.swapStops(stop1ID, stop2ID);
    _changed = true;
  }

  /// @param - Place waypoint
  /// @return stop - returns waypoint as stop
  /// @effects - Adds a new waypoint at the end (before destination)
  Stop addWaypoint(Place waypoint) {
    Stop destination = getDestination();
    Stop waypointStop = Stop(waypoint);
    _pathway.addStop(waypointStop);
    _pathway.swapStops(destination.getUID(), waypointStop.getUID());
    //Adding a new waypoint with empty string implies no change
    if (waypoint != const Place.placeNotFound()) {
      _changed = true;
    }
    return waypointStop;
  }

  Stop addCostWaypoint(Place waypoint) {
    Stop destination = getDestination();
    Stop waypointStop = Stop(waypoint);
    _pathway.addStop(waypointStop);
    _pathway.swapStops(destination.getUID(), waypointStop.getUID());
    return waypointStop;
  }

  /// @param - Place waypoint
  /// @return - waypoint as stop
  /// @effects - Adds a new waypoint at the beginning (before destination)
  Stop addFirstWaypoint(Place waypoint) {
    Stop waypointStop = Stop(waypoint);
    _pathway.addFirstWayPoint(waypointStop);
    //Adding a new waypoint with empty string implies no change
    if (waypoint != const Place.placeNotFound()) {
      _changed = true;
    }
    return waypointStop;
  }

  /// @param void
  /// @return void
  /// @effects - Clears start to default
  void clearStart() {
    _pathway.changeStart(const Place.placeNotFound());
    _changed = true;
  }

  /// @param void
  /// @return void
  /// @effects - Clears destination to default
  void clearDestination() {
    // _pathway.clearDestination();
    _pathway.changeDestination(const Place.placeNotFound());
    _changed = true;
  }

  /// @param int id
  /// @return void
  /// @effects - Clears a waypoint (doesn't remove)
  void clearStop(int id) {
    _pathway.changeStop(id, const Place.placeNotFound());
    _changed = true;
  }

  /// @param void
  /// @return void
  /// @effects - Clears the first waypoint set in the pathway
  void clearFirstWaypoint() {
    _pathway.removeFirstWayPoint();
    _pathway.setHasFirstWaypoint(false);
    _changed = true;
  }

  /// @param - int id
  /// @return void
  /// @effects - Removes a stop based off of id
  void removeStop(int id) {
    _pathway.removeStop(id);
    _changed = true;
  }

  /// @param void
  /// @return void
  /// @effects - Removes all waypoints
  void removeWaypoints() {
    List<int> uids =
        _pathway.getWaypoints().map((waypoint) => waypoint.getUID()).toList();
    for (int id in uids) {
      removeStop(id);
    }
  }

  /// @param void
  /// @return void
  /// @effects - Clears all route markers
  void clearRouteMarkers() {
    List<int> uids = _pathway.getStops().map((stop) => stop.getUID()).toList();
    for (int id in uids) {
      _markerManager.clearMarker(id);
    }
  }

  void setRouteMarkers() {
    List<Stop> stops = _pathway.getStops();
    for (Stop stop in stops) {
      _markerManager.setPlaceMarker(stop.getStop(), stop.getUID());
    }
  }

  /// @param void
  /// @return void
  /// @effects - Resets changed to false
  void clearChanged() => _changed = false;

  /// @param void
  /// @return void
  /// @effects - Clears route data
  void clearRoutes() {
    _startWalkingRoute = R.Route.routeNotFound();
    _bikingRoute = R.Route.routeNotFound();
    _endWalkingRoute = R.Route.routeNotFound();
  }

  /// @param void
  /// @return void
  /// @effects - Clears all data
  void clear() {
    _polylineManager.clearPolyline();

    clearRoutes();
    _walkToFirstWaypoint = false;
    _startFromCurrentLocation = false;
    _optimised = true;
    _costOptimised = false;
    clearRouteMarkers();
    removeWaypoints();
    clearStart();
    clearDestination();
    _changed = false;
  }

  /// @param - pathway Pathway
  /// @return void
  /// @effects - sets the pathway
  @visibleForTesting
  void setPathway(Pathway pathway) {
    _pathway = pathway;
  }

  /// @param void
  /// @return Route - returns startWalkingRoute
  @visibleForTesting
  R.Route getStartWalkingRoute() {
    return _startWalkingRoute;
  }

  /// @param void
  /// @return Route - returns bikingRoute
  @visibleForTesting
  R.Route getBikingRoute() {
    return _bikingRoute;
  }

  /// @param void
  /// @return Route - returns endWalkingRoute
  @visibleForTesting
  R.Route getEndWalkingRoute() {
    return _endWalkingRoute;
  }
}
