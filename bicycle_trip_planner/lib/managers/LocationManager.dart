import 'package:bicycle_trip_planner/models/distance_types.dart';
import 'package:bicycle_trip_planner/models/locator.dart';
import 'package:bicycle_trip_planner/models/place.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart' as geo;

/// Class Comment:
/// LocationManager is a manager class that manages finding the users current
/// location and distances

class LocationManager {
  //********** Fields **********

  // This is specifying the Locator class in locator.dart
  Locator _locator = Locator();
  var _location = Location();

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

  @visibleForTesting
  LocationManager.forMock(Location location, Locator locator){
    _location = location;
    _locator = locator;
  }

  //********** Private **********
  /// Returns true if device is turned on and GPS is turned on
  @visibleForTesting
  Future<bool> checkServiceEnabled() async {
    bool _serviceEnabled = true;
    // Device is on
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      // GPS Device is turned on
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        _serviceEnabled = false;
      }
    }
    return _serviceEnabled;
  }

  /// Returns true or false based on user accepting or rejecting location services
  @visibleForTesting
  Future<bool> checkPermission() async {
    bool grantedPermission = true;
    PermissionStatus _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        grantedPermission = false;
      }
    }
    return grantedPermission;
  }


  Future<void> openLocationSettingsOnDevice() async {
    await geo.Geolocator.openLocationSettings();
  }

  Future<bool> locationSettings([double distanceFilter = 0]) {
    return _location.changeSettings(
        accuracy: LocationAccuracy.navigation,
        interval: 1000,
        distanceFilter: distanceFilter);
  }

  //********** private *********

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
    bool permission = await checkPermission();
    bool service = await checkServiceEnabled();
    return permission && service;
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
  DistanceType getUnits()   {
    return _units;
  }

  /// Returns Stream that updates on user's location change
  /// distance filter adjusts the update sensitivity
  Stream<LocationData> onUserLocationChange([double distanceFilter = 0]) {
    Location location = _location;
    locationSettings(distanceFilter);
    return location.onLocationChanged;
  }

  Future<bool> _locationSettings([double distanceFilter = 0]) {
    return Location().changeSettings(
        accuracy: LocationAccuracy.navigation,
        interval: 1000,
        distanceFilter: distanceFilter);
  }

  /// Set the units for distance
  void setUnits(DistanceType units) {
    _units = units;
  }
}
