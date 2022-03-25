import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/models/station.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test/test.dart';
import 'package:bicycle_trip_planner/managers/MarkerManager.dart';
import 'package:bicycle_trip_planner/models/place.dart';
import 'package:bicycle_trip_planner/models/geometry.dart';
import 'package:bicycle_trip_planner/models/location.dart';
import 'package:geolocator/geolocator.dart';

void main(){
  final markerManager = MarkerManager();

  test('ensure that there are no markers at the start', (){
    expect(MarkerManager().getMarkers().length,0);
  });

  test('ensure multiple markers can be added', (){
    expect(markerManager.getMarkers().length,0);
    for (int i = 0; i < 100; i++) {
      markerManager.setMarker(const LatLng(51.511448, -0.116414), i.toString());
    }
    expect(markerManager.getMarkers().length,100);
    markerManager.getMarkers().clear();
  });

  test('ensure multiple markers can be removed', (){
    expect(markerManager.getMarkers().length,0);
    for (int i = 0; i < 100; i++) {
      markerManager.setMarker(const LatLng(51.511448, -0.116414), i.toString());
    }
    expect(markerManager.getMarkers().length,100);
    markerManager.getMarkers().clear();
    expect(markerManager.getMarkers().length,0);
  });

  test('ensure marker is added when requested', (){
    expect(markerManager.getMarkers().length,0);
    markerManager.setMarker(const LatLng(51.511448, -0.116414), "test marker");
    expect(markerManager.getMarkers().length,1);
    markerManager.getMarkers().clear();
  });

  test('ensure marker is added for place requested', (){
    Location location = Location(lat: 51.511448, lng: -0.116414);
    Geometry geometry = Geometry(location: location);
    Place place = Place(geometry: geometry, name: 'Bush House', placeId: "1", description: "");
    expect(markerManager.getMarkers().length,0);
    markerManager.setPlaceMarker(place, 1);
    expect(markerManager.getMarkers().length,1);
    markerManager.getMarkers().clear();
  });

  test('ensure marker is added for user location', (){
    Position point = Position(longitude: 51.511448, latitude: -0.116414, timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1);
    markerManager.setMarker(LatLng(51.511448, -51.511448), 'user');
    expect(markerManager.getMarkers().length,1);
    markerManager.setUserMarker(LatLng(point.latitude, point.longitude));
    expect(markerManager.getMarkers().length,1);
    markerManager.getMarkers().clear();
  });

  // issue with ApplicationBloc()
  // test('ensure marker for station is correct', (){
  //   markerManager.getMarkers().clear();
  //     List<Station> station = <Station>[
  //       Station(id: 1, name: 'Holborn Station', lat: 1.0, lng: 2.0, bikes: 10, emptyDocks: 2, totalDocks: 12, distanceTo: 1),
  //       Station(id: 2, name: 'Maida Vale Station', lat: 12.0, lng: 23.0, bikes: 5, emptyDocks: 3, totalDocks: 8, distanceTo: 4)
  //     ];
  //   expect(markerManager.getMarkers().length,0);
  //   markerManager.setStationMarkers(station, ApplicationBloc());
  //   expect(markerManager.getMarkers().length,2);
  //   markerManager.getMarkers().clear();
  // });

  // same issue
  // test('ensure marker for station is correct', (){
  //   markerManager.getMarkers().clear();
  //   Station station = Station(id: 1, name: 'Holborn Station', lat: 1.0, lng: 2.0, bikes: 10, emptyDocks: 2, totalDocks: 8, distanceTo: 1);
  //   expect(markerManager.getMarkers().length,0);
  //   markerManager.setStationMarker(station, ApplicationBloc());
  //   expect(markerManager.getMarkers().length,1);
  //   markerManager.getMarkers().clear();
  // });

  // same issue
  // test('ensure marker for station is correct', (){
  //     markerManager.getMarkers().clear();
  //     List<Station> station = <Station>[
  //       Station(id: 1, name: 'Holborn Station', lat: 1.0, lng: 2.0, bikes: 10, emptyDocks: 2, totalDocks: 12, distanceTo: 1),
  //       Station(id: 2, name: 'Maida Vale Station', lat: 12.0, lng: 23.0, bikes: 5, emptyDocks: 3, totalDocks: 8, distanceTo: 4)
  //     ];
  //     markerManager.setStationMarkers(station, ApplicationBloc());
  //     expect(markerManager.getMarkers().length,2);
  //     markerManager.clearStationMarkers(station);
  //     expect(markerManager.getMarkers().length,0);
  // });

  // same issue
  // test('ensure marker for station uid is correct', (){
  //     markerManager.getMarkers().clear();
  //     Station station = Station(id: 1, name: 'Holborn Station', lat: 1.0, lng: 2.0, bikes: 10, emptyDocks: 2, totalDocks: 8, distanceTo: 1);
  //     markerManager.setStationMarkerWithUID(station, ApplicationBloc());
  //     expect(markerManager.getMarkers().length,1);
  //     markerManager.getMarkers().clear();
  // });

  test('remove existing marker', (){
    markerManager.getMarkers().clear();
    expect(markerManager.getMarkers().length,0);
    markerManager.setMarker(const LatLng(51.511448, -0.116414), "test marker");
    expect(markerManager.getMarkers().length,1);
    markerManager.removeMarker("test marker");
    expect(markerManager.getMarkers().length,0);
    markerManager.getMarkers().clear();
  });

  test('remove non-existant marker', (){
    markerManager.getMarkers().clear();
    expect(markerManager.getMarkers().length,0);
    markerManager.removeMarker("non-existant marker");
    expect(markerManager.getMarkers().length,0);
    markerManager.getMarkers().clear();
  });

  test('remove existing marker using uid', (){
    markerManager.getMarkers().clear();
    Location location = Location(lat: 51.511448, lng: -0.116414);
    Geometry geometry = Geometry(location: location);
    Place place = Place(geometry: geometry, name: 'Bush House', placeId: "1", description: "");
    expect(markerManager.getMarkers().length,0);
    markerManager.setPlaceMarker(place, 1);
    expect(markerManager.getMarkers().length,1);
    markerManager.clearMarker(1);
    expect(markerManager.getMarkers().length,0);
    markerManager.getMarkers().clear();
  });

  test('remove non-existing marker using uid', (){
    markerManager.getMarkers().clear();
    Location location = Location(lat: 51.511448, lng: -0.116414);
    Geometry geometry = Geometry(location: location);
    Place place = Place(geometry: geometry, name: 'Bush House', placeId: "1", description: "");
    expect(markerManager.getMarkers().length,0);
    markerManager.setPlaceMarker(place, 1);
    expect(markerManager.getMarkers().length,1);
    markerManager.clearMarker(2); // doesn't exist
    expect(markerManager.getMarkers().length,1);
    markerManager.getMarkers().clear();
  });
}