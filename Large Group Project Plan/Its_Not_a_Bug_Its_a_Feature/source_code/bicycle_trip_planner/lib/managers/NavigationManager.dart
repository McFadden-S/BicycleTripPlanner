import 'package:bicycle_trip_planner/managers/LocationManager.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/managers/StationManager.dart';
import 'package:bicycle_trip_planner/models/place.dart';
import 'package:bicycle_trip_planner/models/station.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Class Comment:
/// NavigationManager is a manager class that manages the data required for navigation

class NavigationManager {

  //********** Fields **********

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

  bool _isLoading = false;

  //********** Singleton **********

  /// Holds Singleton Instance
  static final NavigationManager _navigationManager =
      NavigationManager._internal();

  /// Singleton Constructor Override
  factory NavigationManager() => _navigationManager;

  NavigationManager._internal();

  NavigationManager.forMock(StationManager stationManager, RouteManager routeManager, LocationManager locationManager){
    _stationManager = stationManager;
    _routeManager = routeManager;
    _locationManager = locationManager;
  }

  //********** Private **********

  /// Set isBeginning to @param isBeginning
  @visibleForTesting
  void setIfBeginning(bool isBeginning) {
    _isBeginning = isBeginning;
  }

  /// Set isCycling to @param isCycling
  @visibleForTesting
  void setIfCycling(bool isCycling) {
    _isCycling = isCycling;
  }

  /// Set isEndWalking to @param isEndWalking
  @visibleForTesting
  void setIfEndWalking(bool isEndWalking) {
    _isEndWalking = isEndWalking;
  }

  /// Set pickUpStation to @param station
  @visibleForTesting
  void setPickupStation(Station station) {
    _pickUpStation = station;
  }

  /// Set dropOffStation to @param station
  @visibleForTesting
  void setDropoffStation(Station station) {
    _dropOffStation = station;
  }

  /// Update Start location to Current location
  /// Check if passed PickUp/DropOff stations
  Future<void> _updateStartLocationAndStations() async {
    await _changeRouteStartToCurrentLocation();
    checkPassedByPickUpDropOffStations();
  }

  /// Change Start location to Current location
  Future<void> _changeRouteStartToCurrentLocation() async {
    _routeManager.changeStart(_locationManager.getCurrentLocation());
  }

  /// Update Route with new PickUp/DropOff stations if needed
  _updateRoute() async {
    LatLng startLocation = _routeManager.getStart().getStop().latlng;
    LatLng endLocation = _routeManager.getDestination().getStop().latlng;

    updatePickUpDropOffStations(
        startLocation, endLocation, _routeManager.getGroupSize());
  }

  //********** Public **********

  /// @return true if loading, false otherwise
  bool ifLoading() {
    return _isLoading;
  }

  /// Set isLoading to @param loading
  void setLoading(bool loading) {
    _isLoading = loading;
  }

  /// @return Pick Up Station
  Station getPickupStation() {
    return _pickUpStation;
  }

  /// @return Drop Off Station
  Station getDropoffStation() {
    return _dropOffStation;
  }

  /// @return true if navigating, false otherwise
  bool ifNavigating() {
    return _isNavigating;
  }

  /// @return true if isBeginning, false otherwise
  bool ifBeginning() {
    return _isBeginning;
  }

  /// @return true if isCycling, false otherwise
  bool ifCycling() {
    return _isCycling;
  }

  /// @return true if isEndWalking, false otherwise
  bool ifEndWalking() {
    return _isEndWalking;
  }

  /// Start navigation and set initial values:
  ///   - PickUp/DropOff stations
  /// Pick right type of navigation
  Future<void> start() async {
    _isNavigating = true;
    if (_routeManager.ifStartFromCurrentLocation()) {
      await setInitialPickUpDropOffStations(
          _routeManager.getStart().getStop().latlng,
          _routeManager.getDestination().getStop().latlng);
    } else {
      if (_routeManager.ifWalkToFirstWaypoint()) {
        Place firstStop = _routeManager.getStart().getStop();
        _routeManager.addFirstWaypoint(firstStop);
        await setInitialPickUpDropOffStations(
            firstStop.latlng, _routeManager.getDestination().getStop().latlng);
        await updateRouteWithWalking();
        updateRouteWithWalking();
      } else {
        Place firstStop = _routeManager.getStart().getStop();
        _routeManager.addFirstWaypoint(firstStop);
        await updateRoute();
        await setInitialPickUpDropOffStations(
            _routeManager.getStart().getStop().latlng,
            _routeManager.getDestination().getStop().latlng);
      }
    }
  }

  /// Update navigation route
  Future<void> updateRoute() async {
    await _updateStartLocationAndStations();
    await _updateRoute();
  }

  /// Update navigation route when walking to start location
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

  /// @return true if @param waypoint was passed, false otherwise
  bool isWaypointPassed(LatLng waypoint) {

    return (_locationManager.distanceFromToInMeters(
            _locationManager.getCurrentLocation().getLatLng(), waypoint) <=
        30);
  }

  /// Check if passed waypoint was PickUp/DropOff station
  /// Change values accordingly
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

  /// Check if passed PickUp/DropOff station
  void checkPassedByPickUpDropOffStations() {
    passedStation(_pickUpStation, setIfBeginning, setIfCycling);
    passedStation(_dropOffStation, setIfCycling, setIfEndWalking);
  }

  /// Remove waypoint once passed by it
  /// @return true if we reached the destination, false otherwise
  Future<bool> checkWaypointPassed() async {
    if (_routeManager.getWaypoints().isNotEmpty &&
        isWaypointPassed(
          _routeManager.getWaypoints().first.getStop().getLatLng(),
        )) {
      _routeManager.removeStop(_routeManager.getWaypoints().first.getUID());
    }
    return (_routeManager.getStops().length <= 1);
  }

  /// Update PickUp/DropOff stations when walking to first location
  walkToFirstLocation(Place first,
      [List<Place> intermediates = const <Place>[], int groupSize = 1]) async {
    LatLng firstLocation = first.latlng;
    LatLng endLocation = _routeManager.getDestination().getStop().latlng;

    updatePickUpDropOffStations(firstLocation, endLocation, groupSize);
  }

  /// Update PickUp/DropOff stations if they don't have enough bikes/empty docks
  Future<void> updatePickUpDropOffStations(
      LatLng startLocation, LatLng endLocation, int groupSize) async {
    // Looks like some code duplication here too??
    if (_pickUpStation.bikes < groupSize && !_passedPickUpStation) {
      await setNewPickUpStation(startLocation, groupSize);
    }
    if (_dropOffStation.bikes < groupSize && !_passedDropOffStation) {
      await setNewDropOffStation(endLocation, groupSize);
    }
  }

  /// Set new PickUp station closest to @param location
  Future<void> setNewPickUpStation(LatLng location, [int groupSize = 1]) async {
    _pickUpStation =
        await _stationManager.getPickupStationNear(location, groupSize);
  }

  /// Set new DropOff station closest to @param location
  Future<void> setNewDropOffStation(LatLng location, [int groupSize = 1]) async {
    _dropOffStation =
        await _stationManager.getDropoffStationNear(location, groupSize);
  }

  /// Set initial PickUp/DropOff stations closes to Start and End locations
  Future<void> setInitialPickUpDropOffStations(
      LatLng startLocation, LatLng endLocation) async {
    setNewPickUpStation(_routeManager.getStart().getStop().latlng,
        _routeManager.getGroupSize());
    setNewDropOffStation(_routeManager.getDestination().getStop().latlng,
        _routeManager.getGroupSize());
  }

  /// Clear all variables related to navigation
  void clear() {
    _isBeginning = true;
    _isCycling = false;
    _isEndWalking = false;
    _isNavigating = false;
    _passedDropOffStation = false;
    _passedPickUpStation = false;
    _pickUpStation = Station.stationNotFound();
    _dropOffStation = Station.stationNotFound();
  }

  /// Reset all variables related to navigation
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
