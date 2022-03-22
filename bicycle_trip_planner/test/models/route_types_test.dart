import 'package:test/test.dart';
import 'package:bicycle_trip_planner/models/route_types.dart';
import 'package:flutter/material.dart';

main(){
  final none = RouteType.none;
  final walk = RouteType.walk;
  final bike = RouteType.bike;

  test('ensure all types return correct color', (){
    expect(none.polylineColor, Colors.transparent);
    expect(walk.polylineColor, Colors.lightBlue);
    expect(bike.polylineColor, Colors.red);
  });
}