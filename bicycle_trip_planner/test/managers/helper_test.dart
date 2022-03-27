import 'package:bicycle_trip_planner/models/location.dart';
import 'package:bicycle_trip_planner/models/geometry.dart';
import 'package:bicycle_trip_planner/models/pathway.dart';
import 'package:bicycle_trip_planner/models/place.dart';
import 'package:bicycle_trip_planner/models/stop.dart';
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

  test('ensure map to pathway function works with just start and end stops', (){
    Map<String, dynamic> startMap = {
      "name": "Bush House",
      "description": "the start description",
      "id": "1",
      "lng": -0.116414,
      "lat": 51.511448
    };

    Map<String, dynamic> endMap = {
      "name": "Maida Vale",
      "description": "the end description",
      "id": "2",
      "lng": -0.138209,
      "lat": 51.400520
    };

    Map<String, dynamic> pathwayMap = {
      "start": startMap,
      "end": endMap
    };

    Pathway pathway = Helper.mapToPathway(pathwayMap);

    expect(pathway.getStart().getStop().name, "Bush House");
    expect(pathway.getStart().getStop().description, "the start description");
    expect(pathway.getStart().getStop().placeId, "1");
    expect(pathway.getStart().getStop().getLatLng(), const LatLng(51.511448, -0.116414));

    expect(pathway.getDestination().getStop().name, "Maida Vale");
    expect(pathway.getDestination().getStop().description, "the end description");
    expect(pathway.getDestination().getStop().placeId, "2");
    expect(pathway.getDestination().getStop().getLatLng(), const LatLng(51.400520, -0.138209));
  });

  test('ensure map to pathway function works with start, middle and end stops', (){
    Map<String, dynamic> startMap = {
      "name": "Bush House",
      "description": "the start description",
      "id": "1",
      "lng": -0.116414,
      "lat": 51.511448
    };

    Map<String, dynamic> middleStop1 = {
      "name": "St. John's Wood Road",
      "description": "the first middle stop description",
      "id": "3",
      "lng": -0.115543,
      "lat": 51.345439
    };

    Map<String, dynamic> middleStop2 = {
      "name": "Caven Street, Strand",
      "description": "the second middle stop description",
      "id": "4",
      "lng": -0.125942,
      "lat": 51.678345
    };

    Map<String, dynamic> middleStop3 = {
      "name": "Southampton Street, Strand",
      "description": "the third and final middle stop description",
      "id": "5",
      "lng": -0.104998,
      "lat": 51.576023
    };

    Map<String, dynamic> endMap = {
      "name": "Maida Vale",
      "description": "the end description",
      "id": "2",
      "lng": -0.138209,
      "lat": 51.400520
    };

    List<Map> stopMaps = [middleStop1, middleStop2, middleStop3];

    Map<String, dynamic> pathwayMap = {
      "start": startMap,
      "stops": stopMaps,
      "end": endMap
    };

    Pathway pathway = Helper.mapToPathway(pathwayMap);

    expect(pathway.getStart().getStop().name, "Bush House");
    expect(pathway.getStart().getStop().description, "the start description");
    expect(pathway.getStart().getStop().placeId, "1");
    expect(pathway.getStart().getStop().getLatLng(), const LatLng(51.511448, -0.116414));

    // 5 stops in total including start and end stops
    expect(pathway.getStops().length, 5);
    // expect(pathway.getWaypoints().length, 3);

    print("number of stops ${pathway.getStops().length}");
    print("number of waypoints ${pathway.getWaypoints().length}");

    expect(pathway.getDestination().getStop().name, "Maida Vale");
    expect(pathway.getDestination().getStop().description, "the end description");
    expect(pathway.getDestination().getStop().placeId, "2");
    expect(pathway.getDestination().getStop().getLatLng(), const LatLng(51.400520, -0.138209));
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

  // use place to map in pathway stuff with start, middle and end stops
  // ensure types .runtimeType
}
