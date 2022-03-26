import 'package:bicycle_trip_planner/models/distance_types.dart';
import 'package:bicycle_trip_planner/models/locator.dart';
import 'package:bicycle_trip_planner/models/place.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart' as geo;

class LocationManager {
  //********** Fields **********

  // This is specifying the Locator class in locator.dart
  final Locator _locator = Locator();
  Place _currentPlace = const Place.placeNotFound();
  DistanceType _units = DistanceType.miles; // default

  //********** Singleton **********

  static final LocationManager _locationManager = LocationManager._internal();

  factory LocationManager() {
    return _locationManager;
  }

  LocationManager._internal();

  //********** Private **********

  //********** Public *********

  Future<LatLng> locate() async {
    return _locator.locate();
  }

  Future<bool> requestPermission() async {
    bool permission = await checkPermission();
    bool service = await checkServiceEnabled();
    return permission && service;
  }

  Future<bool> checkServiceEnabled() async {
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

  // returns true or false based on user accepting or rejecting location services
  Future<bool> checkPermission() async {
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

  Future<void> openLocationSettingsOnDevice() async {
    await geo.Geolocator.openLocationSettings();
  }

  Future<double> distanceTo(LatLng pos) async {
    return distanceFromTo(await locate(), pos);
  }

  double distanceFromTo(LatLng posFrom, LatLng posTo) {
    return _units.convert(_calculateDistance(posFrom, posTo));
  }

  double distanceFromToInMeters(LatLng posFrom, LatLng posTo) {
    return _calculateDistance(posFrom, posTo);
  }

  Future<bool> locationSettings([double distanceFilter = 0]) {
    return Location().changeSettings(
        accuracy: LocationAccuracy.navigation,
        interval: 1000,
        distanceFilter: distanceFilter);
  }

  void setCurrentLocation(Place currentPlace) {
    _currentPlace = currentPlace;
  }

  Place getCurrentLocation() {
    return _currentPlace;
  }

  DistanceType getUnits() {
    return _units;
  }

  //********** private *********

  // Returns the distance between the two points in metres
  double _calculateDistance(LatLng pos1, LatLng pos2) {
    return geo.Geolocator.distanceBetween(
        pos1.latitude, pos1.longitude, pos2.latitude, pos2.longitude);
  }

  Stream<LocationData> onUserLocationChange([double distanceFilter = 0]) {
    Location location = Location();
    print(distanceFilter);
    locationSettings(distanceFilter);
    return location.onLocationChanged;
  }

  void setUnits(DistanceType units) {
    _units = units;
  }

  @visibleForTesting
  void isTest(geo.Geolocator geolocator){
    _locator.locate();

  }


}
