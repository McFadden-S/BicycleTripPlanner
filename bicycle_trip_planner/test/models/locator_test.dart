import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:test/test.dart';
import 'package:bicycle_trip_planner/models/locator.dart';
import 'package:mockito/mockito.dart';

main(){
  final locator = Locator();

  test('ensure accuracy is a LocationAccuracy', (){
    expect(locator.settings.runtimeType, LocationSettings);
  });

  test('ensure accuracy is a LocationAccuracy', (){
    expect(locator.accuracy.runtimeType, LocationAccuracy);
  });

  test('ensure distanceFilter is an int', (){
    expect(locator.distanceFilter.runtimeType, int);
  });

}