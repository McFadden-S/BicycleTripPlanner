import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class OverviewPolyline {
  final List<PointLatLng>? points;

  OverviewPolyline({this.points});

  factory OverviewPolyline.fromJson(Map<String, dynamic> parsedJson) {
    return OverviewPolyline(
      points: PolylinePoints().decodePolyline(parsedJson['points']),
    );
  }
}
