import 'package:test/test.dart';
import 'package:bicycle_trip_planner/models/location.dart';

main(){
  final location = Location(lat: 1, lng: -1);

  test('ensure lat is a double', (){
    expect(location.lat.runtimeType, double);
  });

  test('ensure lng is a double', (){
    expect(location.lng.runtimeType, double);
  });
}