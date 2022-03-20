import 'package:test/test.dart';
import 'package:bicycle_trip_planner/managers/IDManager.dart';

main(){
  final idManager = IDManager();

  test('ensure the manager can generate a UID when requested', (){
    expect(idManager.generateUID(), 1);
  });
}