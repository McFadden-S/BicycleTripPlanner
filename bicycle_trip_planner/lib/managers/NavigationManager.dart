import 'package:bicycle_trip_planner/managers/LocationManager.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/managers/StationManager.dart';
import 'package:bicycle_trip_planner/models/location.dart';
import 'package:bicycle_trip_planner/models/place.dart';
import 'package:bicycle_trip_planner/models/station.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NavigationManager {
  var _locationManager = LocationManager();
  var _stationManager = StationManager();
  var _routeManager = RouteManager();

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

  NavigationManager.forMock(StationManager stationManager, RouteManager routeManager, LocationManager locationManager){
    _stationManager = stationManager;
    _routeManager = routeManager;
    _locationManager = locationManager;
  }

  //********** Private **********

  @visibleForTesting
  void setIfBeginning(bool isBeginning) {
    _isBeginning = isBeginning;
  }

  @visibleForTesting
  void setIfCycling(bool isCycling) {
    _isCycling = isCycling;
  }

  @visibleForTesting
  void setIfEndWalking(bool isEndWalking) {
    _isEndWalking = isEndWalking;
  }

  @visibleForTesting
  void setPickupStation(Station station) {
    _pickUpStation = station;
  }

  @visibleForTesting
  void setDropoffStation(Station station) {
    _dropOffStation = station;
  }

  Future<void> _updateStartLocationAndStations() async {
    await _changeRouteStartToCurrentLocation();
    checkPassedByPickUpDropOffStations();
  }

  Future<void> _changeRouteStartToCurrentLocation() async {
    _routeManager.changeStart(_locationManager.getCurrentLocation());
  }

  //TODO get rid of parameters since they are from _routeManager
  _updateRoute(Place origin,
      [List<Place> intermediates = const <Place>[], int groupSize = 1]) async {
    Location startLocation = origin.geometry.location;
    Location endLocation =
        _routeManager.getDestination().getStop().geometry.location;

    updatePickUpDropOffStations(startLocation, endLocation, groupSize);

    // await setPartialRoutes([],
    //     (intermediates.map((intermediate) => intermediate.placeId)).toList());
  }

  //********** Public **********

  Station getPickupStation() {
    return _pickUpStation;
  }

  Station getDropoffStation() {
    return _dropOffStation;
  }

  bool ifNavigating() {
    return _isNavigating;
  }

  bool ifBeginning() {
    return _isBeginning;
  }

  bool ifCycling() {
    return _isCycling;
  }

  bool ifEndWalking() {
    return _isEndWalking;
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
    await _updateStartLocationAndStations();
    await _updateRoute(
        _routeManager.getStart().getStop(),
        _routeManager
            .getWaypoints()
            .map((waypoint) => waypoint.getStop())
            .toList(),
        _routeManager.getGroupSize());
  }

  Future<void> updateRouteWithWalking() async {
    await _updateStartLocationAndStations();
    await walkToFirstLocation(
        _routeManager.getFirstWaypoint().getStop(),
        _routeManager
            .getWaypoints()
            .sublist(1)
            .map((waypoint) => waypoint.getStop())
            .toList(),
        _routeManager.getGroupSize());
  }

  bool isWaypointPassed(LatLng waypoint) {

    print((_locationManager.distanceFromToInMeters(
        _locationManager.getCurrentLocation().getLatLng(), waypoint)));

    return (_locationManager.distanceFromToInMeters(
            _locationManager.getCurrentLocation().getLatLng(), waypoint) <=
        30);
  }

  void passedStation(Station station, void Function(bool) setFalse,
      void Function(bool) setTrue) {
    if (isWaypointPassed(LatLng(station.lat, station.lng))) {
      if (station == _pickUpStation) {
        _passedPickUpStation = true;
      } else {
        _passedDropOffStation = true;
      }
      setFalse(false);
      setTrue(true);
      station = Station.stationNotFound();
    }
  }

  void checkPassedByPickUpDropOffStations() {
    passedStation(_pickUpStation, setIfBeginning, setIfCycling);
    passedStation(_dropOffStation, setIfCycling, setIfEndWalking);
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

  walkToFirstLocation(Place first,
      [List<Place> intermediates = const <Place>[], int groupSize = 1]) async {
    Location firstLocation = first.geometry.location;
    Location endLocation =
        _routeManager.getDestination().getStop().geometry.location;

    updatePickUpDropOffStations(firstLocation, endLocation, groupSize);
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

  @visibleForTesting
  void reset() {
    _isBeginning = true;
    _isCycling = false;
    _isEndWalking = false;
    _isNavigating = false;
    _passedDropOffStation = false;
    _passedPickUpStation = false;
    _pickUpStation = Station.stationNotFound();
    _dropOffStation = Station.stationNotFound();
  }
}
