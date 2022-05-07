import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class OverviewPolyline {
  final List<PointLatLng> points;

  /// constructor with specified required inputs
  OverviewPolyline({required this.points});

  /// constructor default assignments when overview polyline is not found
  const OverviewPolyline.overviewPolylineNotFound(
      {this.points = const <PointLatLng>[]});

  /// factory constructor when data is passed from Json
  /// @param Map<String, dynamic> parsed Json
  factory OverviewPolyline.fromJson(Map<String, dynamic> parsedJson) {
    return OverviewPolyline(
      points: PolylinePoints().decodePolyline(parsedJson['points']),
    );
  }

  /// method override the == operator
  /// @return bool of whether the object is same or not
  @override
  bool operator ==(Object other) {
    return other is OverviewPolyline && other.points == points;
  }
}
