import 'package:bicycle_trip_planner/models/place.dart';
import 'package:test/test.dart';
import 'package:bicycle_trip_planner/models/stop.dart';
import 'package:bicycle_trip_planner/models/location.dart';
import 'package:bicycle_trip_planner/models/geometry.dart';

main(){
  final stop = Stop();

  test('ensure uid is an int', (){
    expect(stop.getUID().runtimeType, int);
  });

  test('ensure stop is a Place', (){
    expect(stop.getStop().runtimeType, Place);
  });

  test('ensure initial uid is 1', (){
    expect(stop.getUID(), 1);
  });

  test('ensure can set a stop', (){
    final location = Location(lat: 1, lng: -1);
    final geometry = Geometry(location: location);
    final place = Place(geometry: geometry, name: "Bush House", placeId: "1", description: "");
    stop.setStop(place);
    expect(stop.getStop().name, "Bush House");
  });

}