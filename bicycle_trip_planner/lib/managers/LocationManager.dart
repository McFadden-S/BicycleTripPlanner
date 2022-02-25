import 'package:bicycle_trip_planner/models/locator.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationManager{

  //********** Fields **********

  // This is specifying the Locator class in locator.dart
  final Locator _locator = Locator();

  //********** Singleton **********

  static final LocationManager _locationManager = LocationManager._internal();

  factory LocationManager() {return _locationManager;}

  LocationManager._internal();

  //********** Private **********

  //********** Public *********

  Future<LatLng> locate() async{
    return _locator.locate();
  }

  Future<LocationPermission> requestPermission() async{
    return await Geolocator.requestPermission();
  }

  Future<double> distanceTo(LatLng pos) async {
    return distanceFromTo(await locate(), pos);
  }

  double distanceFromTo(LatLng posFrom, LatLng posTo){
    return _convertMetresToMiles(_calculateDistance(posFrom, posTo));
  }

  LocationSettings locationSettings([int distanceFilter = 0]){
    return LocationSettings(
      accuracy: LocationAccuracy.best, // How accurate the location is
      distanceFilter: distanceFilter, // The distance needed to travel until the next update (0 means it will always update)
    );
  }

  //********** private *********

  double _convertMetresToMiles(double distance) {
    return distance * 0.000621;
  }

  // Returns the distance between the two points in metres
  double _calculateDistance(LatLng pos1, LatLng pos2) {
    return Geolocator.distanceBetween(
        pos1.latitude, pos1.longitude, pos2.latitude, pos2.longitude);
  }


}