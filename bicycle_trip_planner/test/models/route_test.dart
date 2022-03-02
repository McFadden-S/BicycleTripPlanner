import 'package:test/test.dart';
import 'package:bicycle_trip_planner/models/route.dart';
import 'package:bicycle_trip_planner/models/bounds.dart';
import 'package:bicycle_trip_planner/models/legs.dart';
import 'package:bicycle_trip_planner/models/location.dart';
import 'package:bicycle_trip_planner/models/steps.dart';
import 'package:bicycle_trip_planner/models/overview_polyline.dart';


main(){
  final bounds = Bounds(northeast: Map<String, dynamic>(), southwest: Map<String, dynamic>());
  final startLocation = Location(lat: 1, lng: -1);
  final endLocation = Location(lat: 2, lng: -2);
  final steps = Steps(instruction: "right", distance: 1, duration: 1);
  final polyline = OverviewPolyline(points: []);
  final legs = Legs(startLocation: startLocation, endLocation: endLocation, steps: [steps], distance: 1, duration: 1);
  final route = Route(bounds: bounds, legs: [legs], polyline: polyline);


  test('ensure bounds is Bounds', (){
    expect(route.bounds.runtimeType, Bounds);
  });

  test('ensure legs is list of Legs', (){
    expect(route.legs.runtimeType, List<Legs>);
  });

  test('ensure polyline is OverviewPolyline', (){
    expect(route.polyline.runtimeType, OverviewPolyline);
  });
}