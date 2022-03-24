import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Class Comment:
/// PolylineManager is a manager class that organises and creates
/// polylines to be displayed on the map as routes

class PolylineManager {
  //********** Fields **********

  // stores set of all polylines on display
  final Set<Polyline> _polylines = <Polyline>{};

  // keeps track of how many polylines on display
  int _polylineIdCounter = 1;

  //********** Singleton **********

  /// Holds Singleton Instance
  static final PolylineManager _polylineManager = PolylineManager._internal();

  /// Singleton Constructor Override
  factory PolylineManager() {
    return _polylineManager;
  }

  PolylineManager._internal();

  //********** Private **********

  //********** Public **********

  /// @param void
  /// @return Set<Polyline> - set of all the polylines on show
  Set<Polyline> getPolyLines() {
    return _polylines;
  }

  /// @param -
  ///  points - List<PointLatLng>; list of points to be added to the polyline route
  ///  color - Color; color of polyline
  /// @return Void
  /// @affect adds polylines regardless of how many are currently on display
  void addPolyline(List<PointLatLng> points, Color color) {
    final String polylineIdVal = 'polyline_$_polylineIdCounter';
    _polylineIdCounter++;

    _polylines.add(Polyline(
      polylineId: PolylineId(polylineIdVal),
      width: 6,
      color: color,
      points: points
          .map(
            (point) => LatLng(point.latitude, point.longitude),
          )
          .toList(),
    ));
  }

  /// @param -
  ///  points - List<PointLatLng>; list of points to be added to the polyline route
  ///  color - Color; color of polyline
  /// @return Void
  /// @affect sets a polyline and clears any existing ones
  void setPolyline(List<PointLatLng> points, Color color) {
    final String polylineIdVal = 'polyline_$_polylineIdCounter';
    _polylineIdCounter++;
    _polylines.clear();

    _polylines.add(Polyline(
      polylineId: PolylineId(polylineIdVal),
      width: 6,
      color: color,
      points: points
          .map(
            (point) => LatLng(point.latitude, point.longitude),
          )
          .toList(),
    ));
  }

  /// @param void
  /// @return Set<Polyline> - set of all the polylines on show
  void clearPolyline() {
    _polylines.clear();
  }
}
