import 'package:bicycle_trip_planner/models/search_types.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test/test.dart';
import 'package:bicycle_trip_planner/managers/MarkerManager.dart';
import 'package:bicycle_trip_planner/models/place.dart';
import 'package:bicycle_trip_planner/models/geometry.dart';
import 'package:bicycle_trip_planner/models/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:bicycle_trip_planner/models/station.dart';


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
    Place place = Place(geometry: geometry, name: 'Bush House');
    expect(markerManager.getMarkers().length,0);
    markerManager.setPlaceMarker(place, SearchType.start);
    expect(markerManager.getMarkers().length,1);
    markerManager.getMarkers().clear();
  });

  test('ensure marker is added for user location', (){
    Position point = Position(longitude: 51.511448, latitude: -0.116414, timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1);
    expect(markerManager.getMarkers().length,0);
    markerManager.setUserMarker(LatLng(point.latitude, point.longitude));
    expect(markerManager.getMarkers().length,1);
    markerManager.getMarkers().clear();
  });

  /*test('ensure marker for station is correct', (){
    List<Station> station = <Station>[Station(id: 1, name: 'Holborn Station', lat: 0.0, lng: 0.0, bikes: 10, emptyDocks: 2, totalDocks: 8)];
    markerManager.setStationMarkers(station);
    expect(markerManager.getMarkers().first.markerId, MarkerId("Holborn Station"));
  });*/

}