import 'dart:convert';

import 'package:bicycle_trip_planner/models/location.dart';
import 'package:test/test.dart';
import 'package:bicycle_trip_planner/models/geometry.dart';

main(){
  final location = Location(lat: 1, lng: -1);
  final geometry = Geometry(location: location);

  test('ensure location is a Location', (){
    expect(geometry.location.runtimeType, Location);
  });

  test('test building geometry from json', (){
    String geometryJSON = '{"location": {"lat": 1.0 ,"lng": -1.0 }}';
    expect(Geometry.fromJson(jsonDecode(geometryJSON)).location.lat, geometry.location.lat);
    expect(Geometry.fromJson(jsonDecode(geometryJSON)).location.lng, geometry.location.lng);
  });
}