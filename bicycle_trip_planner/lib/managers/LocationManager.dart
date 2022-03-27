import 'package:bicycle_trip_planner/models/distance_types.dart';
import 'package:bicycle_trip_planner/models/locator.dart';
import 'package:bicycle_trip_planner/models/place.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart' as geo;

/// Class Comment:
/// LocationManager is a manager class that manages finding the users current
/// location

class LocationManager {
  //********** Fields **********

  // This is specifying the Locator class in locator.dart
  final Locator _locator = Locator();

  Place _currentPlace = const Place.placeNotFound();

  DistanceType _units = DistanceType.miles; // default

  //********** Singleton **********

  /// Holds Singleton instance
  static final LocationManager _locationManager = LocationManager._internal();

  /// Singleton Constructor Override
  factory LocationManager() {
    return _locationManager;
  }

  LocationManager._internal();

  //********** Private **********

  @visibleForTesting
  void isTest(geo.Geolocator geolocator){
    _locator.locate();
  }

  /// Returns true if device is turned on and GPS is turned on
  Future<bool> _checkServiceEnabled() async {
    bool _serviceEnabled = true;
    // Device is on
    _serviceEnabled = await Location().serviceEnabled();
    if (!_serviceEnabled) {
      // GPS Device is turned on
      _serviceEnabled = await Location().requestService();
      if (!_serviceEnabled) {
        _serviceEnabled = false;
      }
    }
    return _serviceEnabled;
  }

  /// Returns true or false based on user accepting or rejecting location services
  Future<bool> _checkPermission() async {
    bool grantedPermission = true;
    PermissionStatus _permissionGranted = await Location().hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await Location().requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        grantedPermission = false;
      }
    }
    return grantedPermission;
  }

  Future<bool> _locationSettings([double distanceFilter = 0]) {
    return Location().changeSettings(
        accuracy: LocationAccuracy.navigation,
        interval: 1000,
        distanceFilter: distanceFilter);
  }

  /// Returns the distance between the two points in metres
  double _calculateDistance(LatLng pos1, LatLng pos2) {
    return geo.Geolocator.distanceBetween(
        pos1.latitude, pos1.longitude, pos2.latitude, pos2.longitude);
  }

  //********** Public *********

  /// Returns the users current location
  Future<LatLng> locate() async {
    return _locator.locate();
  }

  /// Requests the current location permissions
  Future<bool> requestPermission() async {
    bool permission = await _checkPermission();
    bool service = await _checkServiceEnabled();
    return permission && service;
  }

  Future<void> openLocationSettingsOnDevice() async {
    await geo.Geolocator.openLocationSettings();
  }

  /// Returns the straight line distance from the users location to the passed coordinates
  Future<double> distanceTo(LatLng pos) async {
    return distanceFromTo(await locate(), pos);
  }

  /// Returns the straight line distance from the first passed coordinates to the
  /// second passed coordinates in the set units
  double distanceFromTo(LatLng posFrom, LatLng posTo) {
    return _units.convert(_calculateDistance(posFrom, posTo));
  }

  /// Returns the straight line distance from the first passed coordinates to the
  /// second passed coordinates in meters
  double distanceFromToInMeters(LatLng posFrom, LatLng posTo) {
    return _calculateDistance(posFrom, posTo);
  }

  /// Sets the cached current location
  void setCurrentLocation(Place currentPlace) {
    _currentPlace = currentPlace;
  }

  /// Returns cached current location
  Place getCurrentLocation() {
    return _currentPlace;
  }

  /// Returns the set units
  DistanceType getUnits() {
    return _units;
  }

  /// Returns Stream that updates on user's location change
  /// distance filter adjusts the update sensitivity
  Stream<LocationData> onUserLocationChange([double distanceFilter = 0]) {
    Location location = Location();
    _locationSettings(distanceFilter);
    return location.onLocationChanged;
  }

  /// Set the units for distance
  void setUnits(DistanceType units) {
    _units = units;
  }


}
