import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolylineManager{

  //********** Fields **********

  final Set<Polyline> _polylines = <Polyline>{};

  int _polylineIdCounter = 1;

  //********** Singleton **********

  static final PolylineManager _polylineManager = PolylineManager._internal();

  factory PolylineManager() {return _polylineManager;}

  PolylineManager._internal();

  //********** Private **********

  void _addPolyline(List<PointLatLng> points, Color color){
    final String polylineIdVal = 'polyline_$_polylineIdCounter';
    _polylineIdCounter++;

    _polylines.add(Polyline(
      polylineId: PolylineId(polylineIdVal),
      width: 6,
      color: color,
      points: points.map((point) => LatLng(point.latitude, point.longitude),)
          .toList(),
    ));
  }

  //********** Public **********

  Set<Polyline> getPolyLines(){
    return _polylines;
  }

  void addWalkingPolyline(List<PointLatLng> points){
    _addPolyline(points, Colors.grey);
  }

  void addBikingPolyline(List<PointLatLng> points){
    _addPolyline(points, Colors.red);
  }

  void setPolyline(List<PointLatLng> points, Color color) {
    final String polylineIdVal = 'polyline_$_polylineIdCounter';
    _polylineIdCounter++;
    _polylines.clear();

    _polylines.add(Polyline(
      polylineId: PolylineId(polylineIdVal),
      width: 6,
      color: color,
      points: points.map((point) => LatLng(point.latitude, point.longitude),)
          .toList(),
    ));
  }

  void clearPolyline(){
    _polylines.clear();
  }

}