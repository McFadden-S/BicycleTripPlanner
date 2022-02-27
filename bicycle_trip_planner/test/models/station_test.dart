import 'package:test/test.dart';
import 'package:bicycle_trip_planner/models/station.dart';

void main() {
  final station = Station(id: 1, name: 'Holborn Station', lat: 0.0, lng: 0.0, bikes: 10, emptyDocks: 2, totalDocks: 8);

  test('ensure id is an int', (){
    expect(station.id.runtimeType, int);
  });

  test('ensure name is an int', (){
    expect(station.name.runtimeType, String);
  });

  test('ensure lat is a double', (){
    expect(station.lat.runtimeType, double);
  });

  test('ensure lng is a double', (){
    expect(station.lng.runtimeType, double);
  });

  test('ensure bikes is an int', (){
    expect(station.bikes.runtimeType, int);
  });

  test('ensure emptyFocks is an int', (){
    expect(station.emptyDocks.runtimeType, int);
  });

  test('ensure totalDocks is an int', (){
    expect(station.totalDocks.runtimeType, int);
  });

  test('ensure distanceTo is a string', (){
    expect(station.distanceTo.runtimeType, double);
  });
}