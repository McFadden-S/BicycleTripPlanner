import 'package:flutter/material.dart';
import 'package:test/test.dart';
import 'package:bicycle_trip_planner/managers/PolylineManager.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

void main(){
  final polyLineManager = PolylineManager();
  test('ensure that there are no polylines at the start', (){
    expect(PolylineManager().getPolyLines().length,0);
  });

  test('ensure polyline is added when requested', (){
    List<PointLatLng> points = [PointLatLng(51.511448, -0.116414)];
    expect(polyLineManager.getPolyLines().length,0);
    polyLineManager.setPolyline(points, Colors.grey);
    expect(polyLineManager.getPolyLines().length,1);
  });


}