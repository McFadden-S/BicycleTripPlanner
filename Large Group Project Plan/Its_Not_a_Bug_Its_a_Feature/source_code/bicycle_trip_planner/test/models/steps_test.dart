import 'package:test/test.dart';
import 'package:bicycle_trip_planner/models/steps.dart';

void main() {
  final steps = Steps(instruction: "right", distance: 10, duration: 30);
  test('ensure instruction is a string', (){
    expect(steps.instruction.runtimeType, String);
  });

  test('ensure distance is an int', (){
    expect(steps.distance.runtimeType, int);
  });

  test('ensure duration is an int', (){
    expect(steps.duration.runtimeType, int);
  });

  test('ensure returns correct hashCode', (){
    expect(steps.hashCode, Object.hash(steps.instruction, steps.distance, steps.duration));
  });

}