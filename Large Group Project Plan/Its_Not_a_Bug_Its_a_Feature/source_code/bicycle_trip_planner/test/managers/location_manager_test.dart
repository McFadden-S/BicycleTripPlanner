import 'dart:async';

import 'package:bicycle_trip_planner/managers/LocationManager.dart';
import 'package:bicycle_trip_planner/models/distance_types.dart';
import 'package:bicycle_trip_planner/models/locator.dart';
import 'package:bicycle_trip_planner/models/place.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:location/location.dart';
import 'location_manager_test.mocks.dart';

@GenerateMocks([Location, Locator])
void main(){
  final location = MockLocation();
  final locator = MockLocator();
  final locationManager = LocationManager.forMock(location, locator);

  when(location.serviceEnabled()).thenAnswer((realInvocation) async=> false);
  when(location.requestService()).thenAnswer((realInvocation) async=> false);

  when(location.hasPermission()).thenAnswer((realInvocation) async=> PermissionStatus.denied);
  when(location.requestPermission()).thenAnswer((realInvocation) async=> PermissionStatus.denied);

  when(location.changeSettings(accuracy: LocationAccuracy.navigation, interval: 1000, distanceFilter: 0)).thenAnswer((realInvocation) async=> true);
  when(locator.locate()).thenAnswer((realInvocation) async=> LatLng(10.0, 10.0));

  test("Check if service is enabled",() async {
    expect(await locationManager.checkServiceEnabled(),false);
  });

  test("Check permission",() async {
    expect(await locationManager.checkPermission(), false);
  });

  test("Location settings",() async {
    expect(await locationManager.locationSettings(), true);
  });

  test("Locate",() async {
    expect(await locationManager.locate(), LatLng(10.0,10.0));
  });

  test("Request permissions",() async{
    expect(await locationManager.requestPermission(), false);
  });

  test("Distance between 2 latlng points", () async{
    expect(await locationManager.distanceFromTo(LatLng(10.0,10.0), LatLng(20.0,20.0)),960.9455107989572);
  });

  test("Distance to location",() async{
    expect(await locationManager.distanceTo(LatLng(10.0,10.0)), 0.0);
  });

  test("Distance between 2 latlng points in meters",() async{
    expect(await locationManager.distanceFromToInMeters(LatLng(10.0,10.0), LatLng(20.0,20.0)), 1546488.0483491938);
  });

  test("Set and get current location",() async{
    var place = Place(latlng: LatLng(10.0,10.0), name: "name", placeId: "placeId", description: "test");
    locationManager.setCurrentLocation(place);
    expect(locationManager.getCurrentLocation().description, "test");
  });

  test("Set and get distance type",(){
    locationManager.setUnits(DistanceType.km);
    expect(locationManager.getUnits(), DistanceType.km);
    locationManager.setUnits(DistanceType.miles);
    expect(locationManager.getUnits(), DistanceType.miles);
  });

  test("On user location change",(){
    var controller = StreamController<LocationData>();
    Stream<LocationData> stream =  controller.stream;
    when(location.onLocationChanged).thenAnswer((realInvocation) => stream);

    expect(locationManager.onUserLocationChange(),stream);
  });
}