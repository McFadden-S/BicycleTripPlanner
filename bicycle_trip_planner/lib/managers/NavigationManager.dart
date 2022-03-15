import 'dart:async';
import 'package:bicycle_trip_planner/managers/DirectionManager.dart';
import 'package:bicycle_trip_planner/managers/LocationManager.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/managers/StationManager.dart';
import 'package:bicycle_trip_planner/models/location.dart';
import 'package:bicycle_trip_planner/models/place.dart';
import 'package:bicycle_trip_planner/models/route.dart' as Rou;
import 'package:bicycle_trip_planner/models/station.dart';
import 'package:bicycle_trip_planner/services/directions_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NavigationManager {
  final _directionsService = DirectionsService();

  final _locationManager = LocationManager();
  final _stationManager = StationManager();
  final _routeManager = RouteManager();

  bool _isNavigating = false;

  //********** Singleton **********

  static final NavigationManager _navigationManager =
      NavigationManager._internal();

  factory NavigationManager() => _navigationManager;

  NavigationManager._internal();

  //********** Public **********

  bool ifNavigating() {
    return _isNavigating;
  }

  //TODO: Temporary fix, should be refactored
  void setNavigating(bool isNavigating) {
    _isNavigating = isNavigating;
  }

  void start(Place currentLocation) async {
    _isNavigating = true;
    if (_routeManager.ifStartFromCurrentLocation()) {
      await setInitialPickUpDropOffStations();
    } else {
      if (_routeManager.ifWalkToFirstWaypoint()) {
        await setInitialPickUpDropOffStations();
        Place firstStop = _routeManager.getStart().getStop();
        _routeManager.addFirstWaypoint(firstStop);
        updateRouteWithWalking(currentLocation);
      } else {
        Place firstStop = _routeManager.getStart().getStop();
        _routeManager.addFirstWaypoint(firstStop);
        await _updateRoute(currentLocation);
        await setInitialPickUpDropOffStations();
      }
    }
  }

  Future<void> updateRoute(Place currentLocation) async {
    //TODO: Duplicated code here anbd below
    await _changeRouteStartToCurrentLocation(currentLocation);
    checkPassedByPickUpDropOffStations(currentLocation);
    await _updateRoute(
        _routeManager.getStart().getStop(),
        _routeManager
            .getWaypoints()
            .map((waypoint) => waypoint.getStop())
            .toList(),
        _routeManager.getGroupSize());
  }

  Future<void> updateRouteWithWalking(Place currentLocation) async {
    await _changeRouteStartToCurrentLocation(currentLocation);
    checkPassedByPickUpDropOffStations(currentLocation);
    await walkToFirstLocation(
        _routeManager.getStart().getStop(),
        _routeManager.getFirstWaypoint().getStop(),
        _routeManager
            .getWaypoints()
            .sublist(1)
            .map((waypoint) => waypoint.getStop())
            .toList(),
        _routeManager.getGroupSize());
  }

  Future<void> _changeRouteStartToCurrentLocation(Place currentLocation) async {
    _routeManager.changeStart(currentLocation);
  }

  bool isWaypointPassed(LatLng waypoint, Place currentLocation) {
    return (_locationManager.distanceFromToInMeters(
            currentLocation.getLatLng(), waypoint) <=
        30);
  }

  void passedStation(Station station, void Function(bool) functionA,
      void Function(bool) functionB, Place currentLocation) {
    if (_stationManager.isStationSet(station) &&
        isWaypointPassed(LatLng(station.lat, station.lng), currentLocation)) {
      _stationManager.passedStation(station);
      _stationManager.clearStation(station);
      functionA(false);
      functionB(true);
    }
  }

  void checkPassedByPickUpDropOffStations(Place currentLocation) {
    Station startStation = _stationManager.getPickupStation();
    Station endStation = _stationManager.getDropOffStation();
    passedStation(startStation, _routeManager.setIfBeginning,
        _routeManager.setIfCycling, currentLocation);
    passedStation(endStation, _routeManager.setIfCycling,
        _routeManager.setIfEndWalking, currentLocation);
  }

  //remove waypoint once passed by it, return true if we reached the destination
  Future<bool> checkWaypointPassed(Place currentLocation) async {
    if (_routeManager.getWaypoints().isNotEmpty &&
        isWaypointPassed(
            _routeManager.getWaypoints().first.getStop().getLatLng(),
            currentLocation)) {
      _routeManager.removeStop(_routeManager.getWaypoints().first.getUID());
    }
    return (_routeManager.getStops().length <= 1);
  }

  walkToFirstLocation(Place origin, Place first,
      [List<Place> intermediates = const <Place>[], int groupSize = 1]) async {
    Location firstLocation = first.geometry.location;
    Location endLocation = _routeManager.getDestinationLocation();

    updatePickUpDropOffStations(firstLocation, endLocation, groupSize);

    await setPartialRoutes([first.name],
        (intermediates.map((intermediate) => intermediate.placeId)).toList());
  }

//TODO get rid of parameters since they are from _routeManager
  _updateRoute(Place origin,
      [List<Place> intermediates = const <Place>[], int groupSize = 1]) async {
    Location startLocation = origin.geometry.location;
    Location endLocation = _routeManager.getDestinationLocation();

    updatePickUpDropOffStations(startLocation, endLocation, groupSize);

    await setPartialRoutes([],
        (intermediates.map((intermediate) => intermediate.placeId)).toList());
  }

  Future<void> setPartialRoutes(
      [List<String> first = const <String>[],
      List<String> intermediates = const <String>[]]) async {
    String originId = _routeManager.getStart().getStop().placeId;
    String destinationId = _routeManager.getDestination().getStop().placeId;

    String startStationId = _stationManager.getPickupStation().place.placeId;
    String endStationId = _stationManager.getDropOffStation().place.placeId;

    Rou.Route startWalkRoute = _routeManager.ifBeginning()
        ? await _directionsService.getWalkingRoutes(
            originId, startStationId, first, false)
        : Rou.Route.routeNotFound();

    Rou.Route bikeRoute = _routeManager.ifBeginning()
        ? await _directionsService.getRoutes(startStationId, endStationId,
            intermediates, _routeManager.ifOptimised())
        : _routeManager.ifCycling()
            ? await _directionsService.getRoutes(originId, endStationId,
                intermediates, _routeManager.ifOptimised())
            : Rou.Route.routeNotFound();

    Rou.Route endWalkRoute = _routeManager.ifEndWalking()
        ? await _directionsService.getWalkingRoutes(originId, destinationId)
        : await _directionsService.getWalkingRoutes(
            endStationId, destinationId);

    //Temporary change: Otherwise directionManager and navigationManager try to
    //initialise each other (circular import where they infinitely initialise each other)
    DirectionManager().setRoutes(startWalkRoute, bikeRoute, endWalkRoute);
  }

  Future<void> updatePickUpDropOffStations(
      Location startLocation, Location endLocation, int groupSize) async {
    if (!_stationManager.checkPickUpStationHasBikes(groupSize) &&
        !_stationManager.passedPickUpStation()) {
      await setNewPickUpStation(startLocation, groupSize);
    }
    if (!_stationManager.checkDropOffStationHasEmptyDocks(groupSize) &&
        !_stationManager.passedDropOffStation()) {
      await setNewDropOffStation(endLocation, groupSize);
    }
  }

  //TODO: Move pick up and drop off station variables in stationManager here...

  Future<Station> setNewPickUpStation(Location location,
      [int groupSize = 1]) async {
    return await _stationManager.getPickupStationNear(
        LatLng(location.lat, location.lng), groupSize);
  }

  Future<Station> setNewDropOffStation(Location location,
      [int groupSize = 1]) async {
    return await _stationManager.getDropoffStationNear(
        LatLng(location.lat, location.lng), groupSize);
  }

  Future<void> setInitialPickUpDropOffStations() async {
    setNewPickUpStation(_routeManager.getStart().getStop().geometry.location,
        _routeManager.getGroupSize());
    setNewDropOffStation(
        _routeManager.getDestination().getStop().geometry.location,
        _routeManager.getGroupSize());
  }

  // TODO: Include in relevant places and clear up any left behidn variables
  void clear() {
    _isNavigating = false;
  }
}
