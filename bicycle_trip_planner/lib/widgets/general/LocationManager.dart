import 'package:bicycle_trip_planner/models/locator.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationManager{

  // Defines how the location should be fine-tuned
  // ignore: prefer_const_constructors
  final LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high, // How accurate the location is
    distanceFilter: 0, // The distance needed to travel until the next update (0 means it will always update)
  );

  // This is specifying the Locator class in locator.dart
  final Locator _locator = Locator();

  LocationManager();

  Future<LatLng> locate() async{
    return _locator.locate();
  }

  Future<LocationPermission> requestPermission() async{
    return await Geolocator.requestPermission();
  }

}