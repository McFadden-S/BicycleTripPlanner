import 'package:bicycle_trip_planner/models/location.dart';
import 'package:test/test.dart';
import 'package:bicycle_trip_planner/models/geometry.dart';

main(){
  final location = Location(lat: 1, lng: -1);
  final geometry = Geometry(location: location);

  test('ensure location is a Location', (){
    expect(geometry.location.runtimeType, Location);
  });
}