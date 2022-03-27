import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test/test.dart';
import 'package:bicycle_trip_planner/models/place.dart';

main(){
  const location = LatLng(1, -1);
  final place = Place(latlng: location, name: "Bush House", placeId: "1", description: "");

  test('ensure geometry is Geometry', (){
    expect(place.latlng.runtimeType, LatLng);
  });

  test('ensure name is String', (){
    expect(place.name.runtimeType, String);
  });

  test('ensure placeId is String', (){
    expect(place.placeId.runtimeType, String);
  });

  test('ensure can get LatLng of place', (){
    expect(place.getLatLng().latitude, location.latitude);
    expect(place.getLatLng().longitude, location.longitude);
  });

  test('ensure overridden toString is correct', (){
    expect(place.toString(), place.description);
  });

  test('ensure overridden toString is correct', (){
    const notFound = Place.placeNotFound();
    expect(notFound.name, "");
    expect(notFound.placeId, "");
    expect(notFound.description, "");
  });

  test('build Place from Json', (){
    String placeJSON = '{"geometry": {"location": {"lat": 1.0 ,"lng": -1.0 }}, "formatted_address": "Bush House", "place_id": "1"}';
    expect(Place.fromJson(jsonDecode(placeJSON), "").latlng.toString(), place.latlng.toString());
    expect(Place.fromJson(jsonDecode(placeJSON), "").placeId, place.placeId);
    expect(Place.fromJson(jsonDecode(placeJSON), "").name, place.name);
    expect(Place.fromJson(jsonDecode(placeJSON), "").description, "");
  });
}