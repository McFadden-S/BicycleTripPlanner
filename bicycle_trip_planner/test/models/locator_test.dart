import 'package:geolocator/geolocator.dart';
import 'package:test/test.dart';
import 'package:bicycle_trip_planner/models/locator.dart';

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