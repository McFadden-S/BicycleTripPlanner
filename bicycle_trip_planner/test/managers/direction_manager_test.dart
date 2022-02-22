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

  test('test calculation conversion for duration is correct', (){
    directionManager.setDuration(60);
    expect(directionManager.duration, '1 min');
  });

  test('test calculation conversion for distance is correct', (){
    directionManager.setDistance(1000);
    expect(directionManager.distance, '1 km');
  });

  test('ensure that dummy directions are created', (){
    expect(directionManager.createDummyDirections().length, 5);
  });

  test('ensure that first direction and be removed and return next direction', (){
    directionManager.directions = directionManager.createDummyDirections();
    expect(directionManager.directions.length, 5);
    final currentDirection = directionManager.directions[1];
    expect(directionManager.popDirection().instruction, currentDirection.instruction);
    expect(directionManager.directions.length, 4);
  });



}