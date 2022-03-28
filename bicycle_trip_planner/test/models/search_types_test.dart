import 'package:test/test.dart';
import 'package:bicycle_trip_planner/models/search_types.dart';

main(){
  final current = SearchType.current;

  test('ensure description is current location', (){
    expect(current.description, "My current location");
  });
}