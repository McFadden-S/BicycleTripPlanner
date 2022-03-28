import 'dart:convert';

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

  test('test build PlaceSearch from Json', (){
    String placeSearchJson = '{"description": "place", "place_id": "user"}';
    expect(PlaceSearch.fromJson(jsonDecode(placeSearchJson)).description, placeSearch.description);
    expect(PlaceSearch.fromJson(jsonDecode(placeSearchJson)).placeId, placeSearch.placeId);
  });
}