import 'package:test/test.dart';
import 'package:bicycle_trip_planner/managers/DirectionManager.dart';
import 'package:bicycle_trip_planner/models/route.dart';
import 'package:bicycle_trip_planner/models/bounds.dart';
import 'package:bicycle_trip_planner/models/legs.dart';
import 'package:bicycle_trip_planner/models/location.dart';
import 'package:bicycle_trip_planner/models/steps.dart';
import 'package:bicycle_trip_planner/models/overview_polyline.dart';

void main(){
  final directionManager = DirectionManager();

  test('ensure isCycling is false when initialized', (){
    expect(directionManager.ifCycling(), false);
  });

  test('ensure duration is no data when initialized', (){
    expect(directionManager.getDuration(), "No data");
  });

  test('ensure distance is no data when initialized', (){
    expect(directionManager.getDistance(), "No data");
  });

  test('ensure directions is empty when initialized', (){
    expect(directionManager.getDirections().length, 0);
  });

  test('ensure currentDirection is empty when initialized', (){
    expect(directionManager.getCurrentDirection().instruction, "");
    expect(directionManager.getCurrentDirection().duration, 0);
    expect(directionManager.getCurrentDirection().distance, 0);
  });

  test('test calculation conversion for duration is correct', (){
    directionManager.setDuration(60);
    expect(directionManager.getDuration(), '1 min');
  });

  test('test calculation conversion for distance is correct', (){
    directionManager.setDistance(1000);
    expect(directionManager.getDistance(), '1 km');
  });

  test('ensure that dummy directions are created', (){
    expect(directionManager.createDummyDirections().length, 5);
  });

  test('ensure that first direction and be removed and return next direction', (){
    final bounds = Bounds(northeast: {"a": 1}, southwest: {"b": 2});
    final startLocation = Location(lat: 155.1, lng: -12.3);
    final endLocation = Location(lat: 234.2, lng: -24.3);
    final steps = Steps(instruction: "right", distance: 1, duration: 1);
    final polyline = OverviewPolyline(points: []);
    final legs = [Legs(startLocation: startLocation, endLocation: endLocation, steps: [steps], distance: 1, duration: 1), Legs(startLocation: startLocation, endLocation: endLocation, steps: [steps], distance: 2, duration: 2), Legs(startLocation: startLocation, endLocation: endLocation, steps: [steps], distance: 2, duration: 2)];
    final route = Route(bounds: bounds, legs: legs, polyline: polyline);
    directionManager.setCurrentRoute(route);
    expect(directionManager.getNumberOfDirections(),2);
    final currentDirection = directionManager.getDirections()[0];
    expect(directionManager.popDirection().instruction, currentDirection.instruction);
    expect(directionManager.getNumberOfDirections(), 1);
  });



}