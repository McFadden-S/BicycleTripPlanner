import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:test/test.dart';
import 'package:bicycle_trip_planner/models/locator.dart';
import 'package:mockito/mockito.dart';
import 'locator_test.mocks.dart';


@GenerateMocks([Geolocator])
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

  test("ensure locator returns LatLng object when locate is called",() async {
    final geolocator = MockGeolocator();
    final locator = Locator.withMock(geolocator);
    when(geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high, forceAndroidLocationManager: false, timeLimit: null)).thenAnswer((_) async=>
      Position(longitude: 10, latitude: 40, timestamp: DateTime(1) , accuracy: 0.0 , altitude: 0.0, heading: 0.0, speed: 0, speedAccuracy: 0.0)
    );

    expect(await locator.locate(), LatLng(40, 10));
  });
}