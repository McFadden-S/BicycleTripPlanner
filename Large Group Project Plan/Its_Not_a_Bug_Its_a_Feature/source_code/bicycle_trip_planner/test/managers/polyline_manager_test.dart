import 'package:flutter/material.dart';
import 'package:test/test.dart';
import 'package:bicycle_trip_planner/managers/PolylineManager.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

void main() {
  final polyLineManager = PolylineManager();

  setUp(() {
    polyLineManager.getPolyLines().clear();
  });

  test('ensure that there are no polylines at the start', () {
    expect(PolylineManager().getPolyLines().length, 0);
  });

  test('ensure polyline is added when requested', () {
    List<PointLatLng> points = [const PointLatLng(51.511448, -0.116414)];
    expect(polyLineManager.getPolyLines().length, 0);
    polyLineManager.setPolyline(points, Colors.grey);
    expect(polyLineManager.getPolyLines().length, 1);
  });

  test('ensure multiple points added to a polyline can be recognised as one',
      () {
    List<PointLatLng> points = [];
    expect(polyLineManager.getPolyLines().length, 0);
    for (int i = 0; i < 100; i++) {
      points.add(PointLatLng(i.toDouble(), -i.toDouble()));
    }
    polyLineManager.setPolyline(points, Colors.grey);
    expect(polyLineManager.getPolyLines().length, 1);
  });

  test('be able to add multiple polylines', () {
    List<PointLatLng> points = [const PointLatLng(51.511448, -0.116414)];
    expect(polyLineManager.getPolyLines().length, 0);
    for (int i = 0; i < 100; i++) {
      polyLineManager.addPolyline(points, Colors.grey);
    }
    expect(polyLineManager.getPolyLines().length, 100);
  });

  test('be able to remove multiple polylines from addPolyline', () {
    List<PointLatLng> points = [const PointLatLng(51.511448, -0.116414)];
    expect(polyLineManager.getPolyLines().length, 0);
    for (int i = 0; i < 100; i++) {
      polyLineManager.addPolyline(points, Colors.grey);
    }
    expect(polyLineManager.getPolyLines().length, 100);
    polyLineManager.clearPolyline();
    expect(polyLineManager.getPolyLines().length, 0);
  });

  test('ensure polyline is cleared when created with setPolyline', () {
    List<PointLatLng> points = [const PointLatLng(51.511448, -0.116414)];
    expect(polyLineManager.getPolyLines().length, 0);
    polyLineManager.setPolyline(points, Colors.grey);
    expect(polyLineManager.getPolyLines().length, 1);
    polyLineManager.clearPolyline();
    expect(polyLineManager.getPolyLines().length, 0);
  });

  test('ensure setPolyline replaces old polyline', () {
    List<PointLatLng> points = [const PointLatLng(51.511448, -0.116414)];
    expect(polyLineManager.getPolyLines().length, 0);
    for (int i = 0; i < 100; i++) {
      polyLineManager.addPolyline(points, Colors.grey);
    }
    expect(polyLineManager.getPolyLines().length, 100);
    polyLineManager.setPolyline(points, Colors.grey);
    expect(polyLineManager.getPolyLines().length, 1);
    polyLineManager.clearPolyline();
    expect(polyLineManager.getPolyLines().length, 0);
  });

  test('ensure clearPolyline does not crash if there are no polylines to clear',
      () {
    expect(polyLineManager.getPolyLines().length, 0);
    polyLineManager.clearPolyline();
    expect(polyLineManager.getPolyLines().length, 0);
  });
}
