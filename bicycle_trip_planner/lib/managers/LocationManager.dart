import 'package:bicycle_trip_planner/models/locator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart' as geo;

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
    return await location.hasPermission();
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
}
