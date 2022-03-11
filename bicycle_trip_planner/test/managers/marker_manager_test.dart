import 'package:bicycle_trip_planner/models/search_types.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test/test.dart';
import 'package:bicycle_trip_planner/managers/MarkerManager.dart';
import 'package:bicycle_trip_planner/models/place.dart';
import 'package:bicycle_trip_planner/models/geometry.dart';
import 'package:bicycle_trip_planner/models/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:bicycle_trip_planner/models/station.dart';
import 'package:bicycle_trip_planner/bloc/application_bloc.dart';


void main(){
  final markerManager = MarkerManager();
  test('ensure that there are no markers at the start', (){
    expect(MarkerManager().getMarkers().length,0);
  });

  test('ensure marker is added when requested', (){
    expect(markerManager.getMarkers().length,0);
    markerManager.setMarker(const LatLng(51.511448, -0.116414), "test");
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

  // need exact station details available on web for it to work
  // test('ensure marker for station is correct', (){
  //   List<Station> station = <Station>[Station(id: 1, name: 'Holborn Station', lat: 1.0, lng: 2.0, bikes: 10, emptyDocks: 2, totalDocks: 8, distanceTo: 1)];
  //   markerManager.setStationMarkers(station, ApplicationBloc());
  //   expect(markerManager.getMarkers().first.markerId, MarkerId("user"));
  // });

}