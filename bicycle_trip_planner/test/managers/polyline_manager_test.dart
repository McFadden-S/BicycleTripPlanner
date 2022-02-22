import 'package:test/test.dart';
import 'package:bicycle_trip_planner/managers/PolylineManager.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

void main(){
  test('ensure that there are no polylines at the start', (){
    expect(PolylineManager().getPolyLines().length,0);
  });

  test('ensure polyline is added when requested', (){
    final poly = PolylineManager();
    List<PointLatLng> points = [PointLatLng(51.511448, -0.116414)];
    expect(poly.getPolyLines().length,0);
    poly.setPolyline(points);
    expect(poly.getPolyLines().length,1);
  });


}