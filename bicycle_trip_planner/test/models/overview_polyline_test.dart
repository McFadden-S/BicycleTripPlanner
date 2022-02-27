import 'package:test/test.dart';
import 'package:bicycle_trip_planner/models/overview_polyline.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

main(){
  final overviewPolyline = OverviewPolyline(points: []);
  test('ensure points is a list of PointLatLng', (){
    expect(overviewPolyline.points.runtimeType, List<PointLatLng>);
  });
}
