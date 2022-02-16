import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolylineManager{

  final Set<Polyline> polylines;

  int _polylineIdCounter = 1;

  PolylineManager({required this.polylines});

  void setPolyline(List<PointLatLng> points) {
    final String polylineIdVal = 'polyline_$_polylineIdCounter';
    _polylineIdCounter++;
    polylines.clear();

    polylines.add(Polyline(
      polylineId: PolylineId(polylineIdVal),
      width: 2,
      color: Colors.blue,
      points: points.map((point) => LatLng(point.latitude, point.longitude),)
          .toList(),
    ));
  }

}