import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class OverviewPolyline {
  final List<PointLatLng> points;

  OverviewPolyline({required this.points});

  const OverviewPolyline.overviewPolylineNotFound(
      {this.points = const <PointLatLng>[]});

  factory OverviewPolyline.fromJson(Map<String, dynamic> parsedJson) {
    return OverviewPolyline(
      points: PolylinePoints().decodePolyline(parsedJson['points']),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is OverviewPolyline && other.points == points;
  }
}
