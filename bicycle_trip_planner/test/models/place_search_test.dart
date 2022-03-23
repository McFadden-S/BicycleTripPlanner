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

  test('build placeSearch from json', (){
    String placeSearchJSON = '{"description": "place", "place_id": "user"}';
    expect(PlaceSearch.fromJson(jsonDecode(placeSearchJSON)).placeId, placeSearch.placeId);
    expect(PlaceSearch.fromJson(jsonDecode(placeSearchJSON)).description, placeSearch.description);
  });

}