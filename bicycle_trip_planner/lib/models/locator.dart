

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Locator {

  LocationSettings? settings; 
  LocationAccuracy accuracy;
  int distanceFilter; 

  Locator({this.accuracy = LocationAccuracy.high, this.distanceFilter = 0}){
    settings = LocationSettings(
      accuracy: accuracy, 
      distanceFilter: distanceFilter,
    ); 
  } 

  // Locates the current position of the user
  Future<LatLng> locate() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return LatLng(position.latitude, position.longitude);
  }
}
