import 'package:test/test.dart';
import 'package:bicycle_trip_planner/managers/TimeManager.dart';

main(){
  final timeManager = CurrentTime();

  test('ensure current time is initialised as current time', (){
    expect(timeManager.currentTime.difference(DateTime.now()).inSeconds < 1, true);
  });

  test('ensure can get the correct current hour', (){
    expect(timeManager.getCurrentHour(), DateTime.now().hour);
  });

  test('ensure isDark is false if time is after sunrise and before sunset', (){
    timeManager.currentTime = DateTime.parse('2020-07-20 11:18:04Z');
    expect(timeManager.isDark(), false);
  });

}