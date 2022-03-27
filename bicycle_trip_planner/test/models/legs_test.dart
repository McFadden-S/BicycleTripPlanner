import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test/test.dart';
import 'package:bicycle_trip_planner/models/steps.dart';
import 'package:bicycle_trip_planner/models/legs.dart';

main(){
  const startLocation = LatLng(1, -1);
  const endLocation = LatLng(2, -2);
  final steps = Steps(instruction: "right", distance: 1, duration: 1);
  final legs = Legs(startLocation: startLocation, endLocation: endLocation, steps: [steps], distance: 1, duration: 1);
  final legs2 = Legs(startLocation: startLocation, endLocation: endLocation, steps: [steps], distance: 2, duration: 1);

  test('ensure startLocation is Location', (){
    expect(legs.startLocation.runtimeType, LatLng);
  });

  test('ensure endLocation is Location', (){
    expect(legs.endLocation.runtimeType, LatLng);
  });

  test('ensure steps is List<Steps>', (){
    expect(legs.steps.runtimeType, List<Steps>);
  });

  test('ensure distance is an int', (){
    expect(legs.distance.runtimeType, int);
  });

  test('ensure duration is an int', (){
    expect(legs.duration.runtimeType, int);
  });

  test('ensure overridden == operator is functioning properly', (){
    expect(legs == legs, true);
  });

  test('ensure overridden == operator is functioning properly when compare with different legs', (){
    expect(legs == legs2, false);
  });

  test('ensure overridden toString is correct', (){
    expect(legs.toString(), legs.steps.toString());
  });

  test('ensure legs return the correct hashCode', (){
    expect(legs.hashCode, Object.hash(legs.steps, legs.startLocation, legs.endLocation, legs.duration, legs.distance));
  });

}