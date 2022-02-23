import 'package:test/test.dart';
import 'package:bicycle_trip_planner/managers/DirectionManager.dart';

void main(){
  final directionManager = DirectionManager();

  test('ensure isCycling is false when initialized', (){
    expect(directionManager.isCycling, false);
  });

  test('ensure duration is no data when initialized', (){
    expect(directionManager.duration, "No data");
  });

  test('ensure distance is no data when initialized', (){
    expect(directionManager.distance, "No data");
  });

  test('ensure directions is empty when initialized', (){
    expect(directionManager.directions.length, 0);
  });

  test('ensure currentDirection is empty when initialized', (){
    expect(directionManager.currentDirection.instruction, "");
    expect(directionManager.currentDirection.duration, 0);
    expect(directionManager.currentDirection.distance, 0);
  });

}