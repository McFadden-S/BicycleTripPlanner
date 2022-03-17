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
  bool _isBeginning = true;
  bool _isCycling = false;
  bool _isEndWalking = false;

  Station _pickUpStation = Station.stationNotFound();
  Station _dropOffStation = Station.stationNotFound();
  bool _passedDropOffStation = false;
  bool _passedPickUpStation = false;

  //********** Singleton **********

  static final NavigationManager _navigationManager =
      NavigationManager._internal();

  factory NavigationManager() => _navigationManager;

  NavigationManager._internal();

  //********** Public **********

  bool ifNavigating() {
    return _isNavigating;
  }

  Future<void> start() async {
    _isNavigating = true;
    if (_routeManager.ifStartFromCurrentLocation()) {
      await setInitialPickUpDropOffStations();
    } else {
      if (_routeManager.ifWalkToFirstWaypoint()) {
        await setInitialPickUpDropOffStations();
        Place firstStop = _routeManager.getStart().getStop();
        _routeManager.addFirstWaypoint(firstStop);
        updateRouteWithWalking();
      } else {
        Place firstStop = _routeManager.getStart().getStop();
        _routeManager.addFirstWaypoint(firstStop);
        await updateRoute();
        await setInitialPickUpDropOffStations();
      }
    }
  }

  Future<void> updateRoute() async {
    //TODO: Duplicated code here anbd below
    await _changeRouteStartToCurrentLocation();
    checkPassedByPickUpDropOffStations();
    await _updateRoute(
        _routeManager.getStart().getStop(),
        _routeManager
            .getWaypoints()
            .map((waypoint) => waypoint.getStop())
            .toList(),
        _routeManager.getGroupSize());
  }

  Future<void> updateRouteWithWalking() async {
    await _changeRouteStartToCurrentLocation();
    checkPassedByPickUpDropOffStations();
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

  Future<void> _changeRouteStartToCurrentLocation() async {
    _routeManager.changeStart(_locationManager.getCurrentLocation());
  }

  bool isWaypointPassed(LatLng waypoint) {
    return (_locationManager.distanceFromToInMeters(
            _locationManager.getCurrentLocation().getLatLng(), waypoint) <=
        30);
  }

  // TODO: Check what isStationSet does
  // Also why are functions passed in?
  // Rename pass into at...
  void passedStation(Station station, bool setFalse, bool setTrue) {
    // if (_stationManager.isStationSet(station) &&
    //     isWaypointPassed(LatLng(station.lat, station.lng))) {
    //   _stationManager.passedStation(station);
    //   _stationManager.clearStation(station);
    //   functionA(false);
    //   functionB(true);
    // }
    if (isWaypointPassed(LatLng(station.lat, station.lng))) {
      if (station == _pickUpStation) {
        _passedPickUpStation = true;
      } else {
        _passedDropOffStation = true;
      }
      station = Station.stationNotFound();
      setFalse = false;
      setTrue = true;
    }
  }

  void checkPassedByPickUpDropOffStations() {
    passedStation(_pickUpStation, _isBeginning, _isCycling);
    passedStation(_dropOffStation, _isCycling, _isEndWalking);
  }

  //remove waypoint once passed by it, return true if we reached the destination
  // Change name to removeWaypointIfPassed
  Future<bool> checkWaypointPassed() async {
    if (_routeManager.getWaypoints().isNotEmpty &&
        isWaypointPassed(
          _routeManager.getWaypoints().first.getStop().getLatLng(),
        )) {
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
    //TODO: Change this...
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

    String startStationId = _pickUpStation.place.placeId;
    String endStationId = _dropOffStation.place.placeId;

    Rou.Route startWalkRoute = _isBeginning
        ? await _directionsService.getWalkingRoutes(
            originId, startStationId, first, false)
        : Rou.Route.routeNotFound();

    Rou.Route bikeRoute = _isBeginning
        ? await _directionsService.getRoutes(startStationId, endStationId,
            intermediates, _routeManager.ifOptimised())
        : _isCycling
            ? await _directionsService.getRoutes(originId, endStationId,
                intermediates, _routeManager.ifOptimised())
            : Rou.Route.routeNotFound();

    Rou.Route endWalkRoute = _isEndWalking
        ? await _directionsService.getWalkingRoutes(originId, destinationId)
        : await _directionsService.getWalkingRoutes(
            endStationId, destinationId);

    //Temporary change: Otherwise directionManager and navigationManager try to
    //initialise each other (circular import where they infinitely initialise each other)
    DirectionManager()
        .setRoutes(startWalkRoute, bikeRoute, endWalkRoute, false);
  }

  Future<void> updatePickUpDropOffStations(
      Location startLocation, Location endLocation, int groupSize) async {
    // Looks like some code duplication here too??
    if (_pickUpStation.bikes < groupSize && !_passedPickUpStation) {
      await setNewPickUpStation(startLocation, groupSize);
    }
    if (_dropOffStation.bikes < groupSize && !_passedDropOffStation) {
      await setNewDropOffStation(endLocation, groupSize);
    }
  }

  Future<void> setNewPickUpStation(Location location,
      [int groupSize = 1]) async {
    _pickUpStation = await _stationManager.getPickupStationNear(
        LatLng(location.lat, location.lng), groupSize);
  }

  Future<void> setNewDropOffStation(Location location,
      [int groupSize = 1]) async {
    _dropOffStation = await _stationManager.getDropoffStationNear(
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
    _isBeginning = true;
    _isCycling = false;
    _isEndWalking = false;
    _isNavigating = false;
    _passedDropOffStation = false;
    _passedPickUpStation = false;
    _pickUpStation = Station.stationNotFound();
    _dropOffStation = Station.stationNotFound();
    _locationManager.locationSettings();
  }
}
