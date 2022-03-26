import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Locator {
  LocationSettings? settings;
  LocationAccuracy accuracy;
  int distanceFilter;
  Geolocator geolocator = Geolocator();


  /**
   * default constructor to set locator values
   */
  Locator({this.accuracy = LocationAccuracy.high, this.distanceFilter = 0}) {
    settings = LocationSettings(
      accuracy: accuracy,
      distanceFilter: distanceFilter,
    );
  }

  /**
   * constructor with mock input
   */
  Locator.withMock(Geolocator mockGeolocator,
      {this.accuracy = LocationAccuracy.high, this.distanceFilter = 0}) {
    settings = LocationSettings(
      accuracy: accuracy,
      distanceFilter: distanceFilter,
    );
    geolocator = mockGeolocator;
  }

  /**
   * method locates the current position of the user
   * @return LatLng current position
   */
  Future<LatLng> locate() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return LatLng(position.latitude, position.longitude);
  }
}
