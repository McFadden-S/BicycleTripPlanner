import 'package:bicycle_trip_planner/models/location.dart';
import 'package:bicycle_trip_planner/models/geometry.dart';
import 'package:bicycle_trip_planner/models/place.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test/test.dart';
import 'package:bicycle_trip_planner/managers/Helper.dart';

void main() {
  test('ensure place to map function works', (){
    Location location = Location(lat: 51.511448, lng: -0.116414);
    Geometry geometry = Geometry(location: location);
    Place place = Place(geometry: geometry, name: 'Bush House', placeId: "1", description: "the description");

    Map<String, dynamic> map = Helper.place2Map(place);

    expect(map.length, 5);
    // checking all in the map are correct
    expect(map["name"], "Bush House");
    expect(map["description"], "the description");
    expect(map["id"], "1");
    expect(map["lat"], 51.511448);
    expect(map["lng"], -0.116414);
  });

  test('ensure map to place function works', (){
    Map<String, dynamic> map = {
      "name": "Bush House",
      "description": "the description",
      "id": "1",
      "lng": -0.116414,
      "lat": 51.511448
    };
    expect(map.length, 5);

    Place place = Helper.mapToPlace(map);

    // check correct place details are correct
    expect(place.name, "Bush House");
    expect(place.description, "the description");
    expect(place.placeId, "1");
    expect(place.getLatLng(), const LatLng(51.511448, -0.116414));
  });

  test('ensure map to pathway function works', (){
    Location location = Location(lat: 51.511448, lng: -0.116414);
    Geometry geometry = Geometry(location: location);
    Place place = Place(geometry: geometry, name: 'Bush House', placeId: "1", description: "the description");
    Map<String, dynamic> map = Helper.place2Map(place);
    expect(map.length, 5);
    // to finish


  });
  
  test('ensure place to map and map to place work interchangably', (){
    Location location = Location(lat: 51.511448, lng: -0.116414);
    Geometry geometry = Geometry(location: location);
    Place place = Place(geometry: geometry, name: 'Bush House', placeId: "1", description: "the description");

    Map<String, dynamic> map = Helper.place2Map(place);
    expect(map.length, 5);

    Place place2 = Helper.mapToPlace(map);
    expect(place.name, place2.name);
    expect(place.placeId, place2.placeId);
    expect(place.description, place2.description);
    expect(place.geometry.toString(), place2.geometry.toString());
    expect(place.getLatLng(), place2.getLatLng());
  });

  test('ensure map to place and place to map work interchangably', (){
    Map<String, dynamic> map = {
      "name": "Bush House",
      "description": "the description",
      "id": "1",
      "lng": -0.116414,
      "lat": 51.511448
    };
    expect(map.length, 5);

    Place place = Helper.mapToPlace(map);

    Map<String, dynamic> map2 = Helper.place2Map(place);
    expect(map2["name"], map["name"]);
    expect(map2["description"], map["description"]);
    expect(map2["id"], map["id"]);
    expect(map2["lat"], map["lat"]);
    expect(map2["lng"], map["lng"]);
  });

  // use Map to Place (or place to map) in pathway stuff
}
