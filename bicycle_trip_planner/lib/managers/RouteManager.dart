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

class RouteManager {
  //********** Fields **********

  final PolylineManager _polylineManager = PolylineManager();
  final MarkerManager _markerManager = MarkerManager();
  final DirectionManager _directionManager = DirectionManager();
  final CameraManager _cameraManager = CameraManager.instance;
  final Pathway _pathway = Pathway();

  bool _startFromCurrentLocation = false;
  bool _walkToFirstWaypoint = false;

  int _groupsize = 1;

  bool _changed = false;
  bool _optimised = true;
  bool _costOptimised = false;

  R.Route _startWalkingRoute = R.Route.routeNotFound();
  R.Route _bikingRoute = R.Route.routeNotFound();
  R.Route _endWalkingRoute = R.Route.routeNotFound();

  //********** Singleton **********

  static final RouteManager _routeManager = RouteManager._internal();

  factory RouteManager() => _routeManager;

  RouteManager._internal();

  //********** Private **********

  void _moveCameraTo(R.Route route) {
    _cameraManager.goToPlace(
        route.legs.first.startLocation.lat,
        route.legs.first.startLocation.lng,
        route.bounds.northeast,
        route.bounds.southwest);
  }

  //********** Public **********

  void setRoutes(R.Route startWalk, R.Route bike, R.Route endWalk) {
    _startWalkingRoute = startWalk;
    _bikingRoute = bike;
    _endWalkingRoute = endWalk;
  }

  // Only shows one of the walking route
  void showCurrentWalkingRoute([bool relocateMap = true]) {
    if (_startWalkingRoute != R.Route.routeNotFound()) {
      setCurrentRoute(_startWalkingRoute, relocateMap);
    } else if (_endWalkingRoute != R.Route.routeNotFound()) {
      setCurrentRoute(_endWalkingRoute, relocateMap);
    }
  }

  // Shows only one of the routes
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

  void showBikeRoute([relocateMap = true]) {
    setCurrentRoute(_bikingRoute, relocateMap);
  }

  void setDirectionsData(R.Route route) {
    List<Steps> directionsPassByValue = [];
    for (var step in route.directions) {
      directionsPassByValue.add(Steps.from(step));
    }
    _directionManager.setDirections(directionsPassByValue);
    _directionManager.setDuration(route.duration);
    _directionManager.setDistance(route.distance);
  }

  void showAllRoutes([bool relocateMap = true]) {
    _polylineManager.clearPolyline();
    _polylineManager.addPolyline(_startWalkingRoute.polyline.points,
        _startWalkingRoute.routeType.polylineColor);
    _polylineManager.addPolyline(
        _bikingRoute.polyline.points, _bikingRoute.routeType.polylineColor);
    _polylineManager.addPolyline(_endWalkingRoute.polyline.points,
        _endWalkingRoute.routeType.polylineColor);

    int duration = 0;
    int distance = 0;

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

  void setCurrentRoute(R.Route route, [relocateMap = true]) {
    setDirectionsData(route);
    _polylineManager.setPolyline(
        route.polyline.points, route.routeType.polylineColor);
    if (relocateMap) {
      _moveCameraTo(route);
    }
  }

  bool ifRouteSet() {
    return _startWalkingRoute != R.Route.routeNotFound() &&
        _endWalkingRoute != R.Route.routeNotFound() &&
        _bikingRoute != R.Route.routeNotFound();
  }

  int getGroupSize() {
    return _groupsize;
  }

  void setGroupSize(int size) {
    if (size > 0) {
      _groupsize = size;
      _changed = true;
    }
  }

  bool ifWalkToFirstWaypoint() {
    return _walkToFirstWaypoint;
  }

  void toggleWalkToFirstWaypoint() {
    _walkToFirstWaypoint = !_walkToFirstWaypoint;
    _pathway.toggleHasFirstWaypoint();
    _changed = true;
  }

  void setWalkToFirstWaypoint(bool ifWalk) {
    _walkToFirstWaypoint = ifWalk;
    _pathway.setHasFirstWaypoint(ifWalk);
    _changed = true;
  }

  bool ifStartFromCurrentLocation() {
    return _startFromCurrentLocation;
  }

  void toggleStartFromCurrentLocation() {
    _startFromCurrentLocation = !_startFromCurrentLocation;
    _changed = true;
  }

  void setStartFromCurrentLocation(bool value) {
    _startFromCurrentLocation = value;
    _changed = true;
  }

  void setOptimised(bool optimised) {
    _optimised = optimised;
    _changed = true;
  }

  void toggleOptimised() {
    _optimised = !_optimised;
    _changed = true;
  }

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


  Stop getStart() => _pathway.getStart();

  Stop getDestination() => _pathway.getDestination();

  List<Stop> getWaypoints() => _pathway.getWaypoints();

  Stop getFirstWaypoint() => _pathway.getFirstWaypoint();

  //List<Stop> getWaypointsWithFirstWaypoint() => _pathway.getWaypointsWithFirstWaypoint();

  List<Stop> getStops() => _pathway.getStops();

  Stop getStop(int id) => _pathway.getStop(id);

  bool ifChanged() => _changed;

  Stop getStopByIndex(int index) => _pathway.getStopByIndex(index);

  bool ifStartSet() =>
      _pathway.getStart().getStop() != const Place.placeNotFound();

  bool ifDestinationSet() =>
      _pathway.getDestination().getStop() != const Place.placeNotFound();

  bool ifFirstWaypointSet() {
    return _pathway.getFirstWaypoint().getStop() != const Place.placeNotFound();
  }

  bool ifWaypointsSet() => getWaypoints().isNotEmpty;

  void changeStart(Place start) {
    _pathway.changeStart(start);
    _changed = true;
  }

  void changeDestination(Place destination) {
    _pathway.changeDestination(destination);
    _changed = true;
  }

  void changeWaypoint(int id, Place waypoint) {
    _pathway.changeStop(id, waypoint);
    _changed = true;
  }

  void changeStop(int id, Place stop) {
    _pathway.changeStop(id, stop);
    _changed = true;
  }

  void swapStops(int stop1ID, int stop2ID) {
    _pathway.swapStops(stop1ID, stop2ID);
    _changed = true;
  }

  // Overrides the old destination
  void addDestination(Place destination) {
    Stop destinationStop = Stop(destination);
    _pathway.addStop(destinationStop);
    _changed = true;
  }

  // Overrides the new stop
  void addStart(Place start) {
    Stop startStop = Stop(start);
    _pathway.addStop(startStop);
    _pathway.moveStop(startStop.getUID(), 0);
    _changed = true;
  }

  // Adds a new waypoint at the end (before destination)
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

  // Adds a new waypoint at the beginning (before destination)
  Stop addFirstWaypoint(Place waypoint) {
    Stop waypointStop = Stop(waypoint);
    _pathway.addFirstWayPoint(waypointStop);
    //Adding a new waypoint with empty string implies no change
    if (waypoint != const Place.placeNotFound()) {
      _changed = true;
    }
    return waypointStop;
  }

  void clearStart() {
    _pathway.changeStart(const Place.placeNotFound());
    _changed = true;
  }

  void clearDestination() {
    _pathway.changeDestination(const Place.placeNotFound());
    _changed = true;
  }

  // Clears a waypoint (doesn't remove)
  void clearStop(int id) {
    _pathway.changeStop(id, const Place.placeNotFound());
    _changed = true;
  }

  void clearFirstWaypoint() {
    _pathway.setHasFirstWaypoint(false);
    _pathway.removeFirstWayPoint();
    _changed = true;
  }

  void removeStop(int id) {
    _pathway.removeStop(id);
    _changed = true;
  }

  void removeWaypoints() {
    List<int> uids =
        _pathway.getWaypoints().map((waypoint) => waypoint.getUID()).toList();
    for (int id in uids) {
      removeStop(id);
    }
  }

  void clearRouteMarkers() {
    List<int> uids = _pathway.getStops().map((stop) => stop.getUID()).toList();
    for (int id in uids) {
      _markerManager.clearMarker(id);
    }
  }

  void clearChanged() => _changed = false;

  void clearRoutes() {
    _startWalkingRoute = R.Route.routeNotFound();
    _bikingRoute = R.Route.routeNotFound();
    _endWalkingRoute = R.Route.routeNotFound();
  }

  void clear() {
    _polylineManager.clearPolyline();
    clearRoutes();
    _walkToFirstWaypoint = false;
    _startFromCurrentLocation = false;
    clearRouteMarkers();

    removeWaypoints();
    clearFirstWaypoint();
    clearStart();
    clearDestination();
    _pathway.initial();
  }
}
