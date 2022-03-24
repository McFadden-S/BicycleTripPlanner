import 'dart:ui';

import 'package:bicycle_trip_planner/managers/CameraManager.dart';
import 'package:bicycle_trip_planner/managers/DirectionManager.dart';
import 'package:bicycle_trip_planner/managers/MarkerManager.dart';
import 'package:bicycle_trip_planner/managers/PolylineManager.dart';
import 'package:bicycle_trip_planner/models/bounds.dart';
import 'package:bicycle_trip_planner/models/pathway.dart';
import 'package:bicycle_trip_planner/models/route.dart' as R;
import 'package:bicycle_trip_planner/models/route_types.dart';
import 'package:bicycle_trip_planner/models/steps.dart';
import 'package:bicycle_trip_planner/models/stop.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/place.dart';

/// Class comment: Route manager is a manager class that updates
/// the route taken during navigation and route planning

class RouteManager {

  //********** Fields **********

  /// Managers needed in route manager
  final PolylineManager _polylineManager = PolylineManager();
  MarkerManager _markerManager = MarkerManager();
  final DirectionManager _directionManager = DirectionManager();
  CameraManager _cameraManager = CameraManager.instance;
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

  /// Current route: The route the user is currently on. Decided by navigationManager
  R.Route _currentRoute = R.Route.routeNotFound();

  /// Manage route markers
  final Set<String> _routeMarkers = {};
  final String _markerPrefix = "Route";
  int _markerId = 0;

  //********** Singleton **********

  static final RouteManager _routeManager = RouteManager._internal();

  // @param void
  // @return RouteManager
  factory RouteManager() => _routeManager;

  RouteManager._internal();
  RouteManager.forMock(
      CameraManager cameraManager, MarkerManager markerManager) {
    _cameraManager = cameraManager;
    _markerManager = markerManager;
  }

  //********** Private **********

  /// @param - Route route, Bounds bounds
  /// @return void
  /// @effects - Moves camera to the route and views its bounds or the given bounds
  @visibleForTesting
  void moveCameraTo(R.Route route,
      [Bounds bounds = const Bounds.boundsNotFound()]) {
    if (bounds == const Bounds.boundsNotFound()) bounds = route.bounds;
    _cameraManager.goToPlace(
        route.legs.first.startLocation, bounds.northeast, bounds.southwest);
  }

  /// @param - Bounds route1Bounds, Bounds route2Bounds
  /// @return Bounds
  /// @effects - returns the new bounds depending on which inputted
  ///            bounds covers a greater area
  Bounds _addBounds(Bounds route1Bounds, Bounds route2Bounds) {
    Map<String, dynamic> newNorthEast = {};
    route1Bounds.northeast['lat'] > route2Bounds.northeast['lat']
        ? newNorthEast['lat'] = route1Bounds.northeast['lat']
        : newNorthEast['lat'] = route2Bounds.northeast['lat'];
    route1Bounds.northeast['lng'] > route2Bounds.northeast['lng']
        ? newNorthEast['lng'] = route1Bounds.northeast['lng']
        : newNorthEast['lng'] = route2Bounds.northeast['lng'];

    Map<String, dynamic> newSouthWest = {};
    route1Bounds.southwest['lat'] < route2Bounds.southwest['lat']
        ? newSouthWest['lat'] = route1Bounds.southwest['lat']
        : newSouthWest['lat'] = route2Bounds.southwest['lat'];
    route1Bounds.southwest['lng'] < route2Bounds.southwest['lng']
        ? newSouthWest['lng'] = route1Bounds.southwest['lng']
        : newSouthWest['lng'] = route2Bounds.southwest['lng'];

    return Bounds(northeast: newNorthEast, southwest: newSouthWest);
  }

  /// @param - Route; the route to create a marker for
  /// @return void
  /// @affects - Sets a marker at the start of the route and
  ///            at the end of the route. If there are intermediate
  ///            stops, they are also set.
  _createRouteMarker(R.Route route) {
    double color = route.routeType == RouteType.bike
        ? BitmapDescriptor.hueGreen
        : BitmapDescriptor.hueRed;
    setRouteMarker(route.legs.last.endLocation, color);
    // Add waypoints
    if (route.legs.length > 1) {
      color = BitmapDescriptor.hueRed;
      for (int i = 1; i < route.legs.length; i++) {
        setRouteMarker(route.legs[i].startLocation, color);
      }
    }
  }

  /// @param - LatLng; the position the marker will be placed
  ///        - doube; color of the marker
  /// @return void
  /// @affects - Sets a marker with the given position and color.
  @visibleForTesting
  setRouteMarker(LatLng pos, [double color = BitmapDescriptor.hueRed]) {
    String markerId = "$_markerPrefix${_markerId++}";
    _routeMarkers.add(markerId);
    _markerManager.setMarker(pos, markerId, color);
  }

  //********** Public **********

  /// Clears all route markers from map
  clearRouteMarkers() {
    for (String markerId in _routeMarkers) {
      _markerManager.removeMarker(markerId);
    }
    _routeMarkers.clear();
  }

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
    List<R.Route> allRoutes = [
      _startWalkingRoute,
      _bikingRoute,
      _endWalkingRoute
    ];

    _polylineManager.clearPolyline();
    clearRouteMarkers();

    int duration = 0;
    double distance = 0;

    for (R.Route route in allRoutes) {
      _polylineManager.addPolyline(
          route.polyline.points, route.routeType.polylineColor);
      duration += route.duration;
      distance += route.distance;
    }

    // Display the pickup and dropoff station
    setRouteMarker(
        _bikingRoute.legs.first.startLocation, BitmapDescriptor.hueGreen);
    setRouteMarker(
        _bikingRoute.legs.last.endLocation, BitmapDescriptor.hueGreen);

    _directionManager.setDuration(duration);
    _directionManager.setDistance(distance);

    Bounds bounds = _addBounds(
        _addBounds(_startWalkingRoute.bounds, _bikingRoute.bounds),
        _endWalkingRoute.bounds);

    if (relocateMap) {
      moveCameraTo(_bikingRoute, bounds);
    }
  }

  /// Set loading to isLoading value
  void setLoading(bool isLoading) {
    _loading = isLoading;
  }

  /// Returns true if loading, false otherwise
  bool ifLoading() {
    return _loading;
  }

  /// @param - Route route, bool relocateMap
  /// @return void
  /// @effects - Set directions and polylines to show current route data
  ///            If relocate map = true, camera will move to given route
  void setCurrentRoute(R.Route route, [relocateMap = true]) {
    setDirectionsData(route);
    clearPathwayMarkers();
    clearRouteMarkers();
    _createRouteMarker(route);
    _polylineManager.setPolyline(
        route.polyline.points, route.routeType.polylineColor);
    _currentRoute = route;
    if (relocateMap) {
      moveCameraTo(route);
    }
  }

  /// Returns Current Route
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

  /// Set costOptimised to @param optimised
  void setCostOptimised(bool optimised) {
    _costOptimised = optimised;
    _changed = true;
  }

  /// Toggle costOptimised
  void toggleCostOptimised() {
    _costOptimised = !_costOptimised;
    _changed = true;
  }

  /// @return true if costOptimised, false otherwise
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

  /// @param - Place waypoint
  /// @return stop - returns waypoint as stop
  /// @effects - Adds a new cost optimised waypoint at the end (before destination)
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
  void clearPathwayMarkers() {
    List<int> uids = _pathway.getStops().map((stop) => stop.getUID()).toList();
    for (int id in uids) {
      _markerManager.clearMarker(id);
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
    clearPathwayMarkers();
    removeWaypoints();
    clearStart();
    clearDestination();
    _changed = false;
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

  /// @return true if costOptimised, false otherwise
  @visibleForTesting
  bool getCostOptimised() {
    return _costOptimised;
  }

  /// @param void
  /// @return Route - returns loading
  @visibleForTesting
  bool getLoading() {
    return _loading;
  }
}
