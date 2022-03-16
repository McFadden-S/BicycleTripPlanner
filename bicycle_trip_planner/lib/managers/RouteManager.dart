import 'package:bicycle_trip_planner/managers/MarkerManager.dart';
import 'package:bicycle_trip_planner/managers/PolylineManager.dart';
import 'package:bicycle_trip_planner/models/pathway.dart';
import 'package:bicycle_trip_planner/models/station.dart';
import 'package:bicycle_trip_planner/models/stop.dart';
import 'package:bicycle_trip_planner/models/location.dart';
import 'package:bicycle_trip_planner/services/places_service.dart';

import '../models/place.dart';

class RouteManager {
  //********** Fields **********

  final PolylineManager _polylineManager = PolylineManager();
  final MarkerManager _markerManager = MarkerManager();
  final Pathway _pathway = Pathway();

  bool _startFromCurrentLocation = false;
  bool _walkToFirstWaypoint = false;

  // TODO: These are variables tied during navigation
  bool _ifBeginning = true;
  bool _ifCycling = false;
  bool _ifEndWalking = false;

  int _groupsize = 1;

  bool _changed = false;
  bool _optimised = true;

  // Remove this
  Location _destination = Location(lng: -1, lat: -1);

  //********** Singleton **********

  static final RouteManager _routeManager = RouteManager._internal();

  factory RouteManager() => _routeManager;

  RouteManager._internal();

  //********** Private **********

  //********** Public **********

  bool ifBeginning() {
    return _ifBeginning;
  }

  void setIfBeginning(bool value) {
    _ifBeginning = value;
  }

  bool ifCycling() {
    return _ifCycling;
  }

  void setIfCycling(bool value) {
    _ifCycling = value;
  }

  bool ifEndWalking() {
    return _ifEndWalking;
  }

  void setIfEndWalking(bool value) {
    _ifEndWalking = value;
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

  Stop getStart() => _pathway.getStart();

  Stop getDestination() => _pathway.getDestination();

  Location getDestinationLocation() => _destination;

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
    _destination = Location(lng: -1, lat: -1);
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

  void clear() {
    _polylineManager.clearPolyline();
    _ifBeginning = true;
    _ifCycling = false;
    _ifEndWalking = false;
    _walkToFirstWaypoint = false;
    _startFromCurrentLocation = false;
    clearRouteMarkers();

    removeWaypoints();
    clearStart();
    clearDestination();
    _pathway.initial();
  }
}
