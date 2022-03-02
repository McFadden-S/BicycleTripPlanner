import 'package:test/test.dart';
import 'package:bicycle_trip_planner/models/place_search.dart';

void main(){
  final placeSearch = PlaceSearch(description: "place", placeId: "user");
  test('ensure description is a String', (){
    expect(placeSearch.description.runtimeType, String);
  });

  test('ensure placeId is a String', (){
    expect(placeSearch.placeId.runtimeType, String);
  });
}