import 'package:test/test.dart';
import 'package:bicycle_trip_planner/models/location.dart';
import 'package:bicycle_trip_planner/models/steps.dart';
import 'package:bicycle_trip_planner/models/legs.dart';

main(){
  final startLocation = Location(lat: 1, lng: -1);
  final endLocation = Location(lat: 2, lng: -2);
  final steps = Steps(instruction: "right", distance: 1, duration: 1);
  final legs = Legs(startLocation: startLocation, endLocation: endLocation, steps: [steps], distance: 1, duration: 1);

  test('ensure startLocation is Location', (){
    expect(legs.startLocation.runtimeType, Location);
  });

  test('ensure endLocation is Location', (){
    expect(legs.endLocation.runtimeType, Location);
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

}