import 'package:bicycle_trip_planner/models/locator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart' as geo;

import '../models/place.dart';

class LocationManager {
  //********** Fields **********

  // This is specifying the Locator class in locator.dart
  final Locator _locator = Locator();
  final Location location = Location();

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

  Future<PermissionStatus> requestPermission() async {
    await checkServiceEnabled();
    await checkPermission();
    PermissionStatus _permissionGranted = await location.hasPermission();
    return _permissionGranted;
  }

  Future<bool> checkServiceEnabled() async {
    bool _serviceEnabled = true;
    // Device is on
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      // GPS Device is turned on
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        _serviceEnabled = false;
      }
    }
    return _serviceEnabled;
  }

  // returns true or false based on user accepting or rejecting location services
  Future<bool> checkPermission() async {
    bool grantedPermission = true;
    PermissionStatus _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        grantedPermission = false;
        // TODO: Using geolocator to openLocationSettings causes another
        // permission dialogue to pop up. Perhaps rely on only one location package
        // geo.Geolocator.openLocationSettings();
      }
    }
    return grantedPermission;
  }

  Future<double> distanceTo(LatLng pos) async {
    return distanceFromTo(await locate(), pos);
  }

  double distanceFromTo(LatLng posFrom, LatLng posTo) {
    return _convertMetresToMiles(_calculateDistance(posFrom, posTo));
  }

  double distanceFromToInMeters(LatLng posFrom, LatLng posTo) {
    return _calculateDistance(posFrom, posTo);
  }

  Future<bool> locationSettings([double distanceFilter = 0]) {
    return location.changeSettings(
        accuracy: LocationAccuracy.high,
        interval: 1000,
        distanceFilter: distanceFilter);
  }

  //********** private *********

  double _convertMetresToMiles(double distance) {
    return distance * 0.000621;
  }

  // Returns the distance between the two points in metres
  double _calculateDistance(LatLng pos1, LatLng pos2) {
    return geo.Geolocator.distanceBetween(
        pos1.latitude, pos1.longitude, pos2.latitude, pos2.longitude);
  }

  Stream<LocationData> onUserLocationChange() {
    return location.onLocationChanged;
  }

  double getHeading(Place headingTo)  {
    var latlng = headingTo.getLatLng();
    return geo.Geolocator.bearingBetween(0, 0, latlng.latitude, latlng.longitude);
  }
}
