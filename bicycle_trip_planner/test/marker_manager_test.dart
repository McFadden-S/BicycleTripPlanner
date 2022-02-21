import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test/test.dart';
import 'package:bicycle_trip_planner/managers/MarkerManager.dart';
import 'package:bicycle_trip_planner/models/place.dart';
import 'package:bicycle_trip_planner/models/geometry.dart';
import 'package:bicycle_trip_planner/models/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:bicycle_trip_planner/models/station.dart';


void main(){
  final marker = MarkerManager();
  test('ensure that there are no markers at the start', (){
    expect(MarkerManager().getMarkers().length,0);
  });

  test('ensure marker is added when requested', (){
    expect(marker.getMarkers().length,0);
    marker.setMarker(LatLng(51.511448, -0.116414));
    expect(marker.getMarkers().length,1);
    marker.getMarkers().clear();
  });

  test('ensure marker is added for place requested', (){
    Location location = Location(lat: 51.511448, lng: -0.116414);
    Geometry geometry = Geometry(location: location);
    Place place = Place(geometry: geometry, name: 'Bush House');
    expect(marker.getMarkers().length,0);
    marker.setPlaceMarker(place);
    expect(marker.getMarkers().length,1);
    marker.getMarkers().clear();
  });

  test('ensure marker is added for user location', (){
    final marker = MarkerManager();
    Position point = Position(longitude: 51.511448, latitude: -0.116414, timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1);
    expect(marker.getMarkers().length,0);
    marker.setUserMarker(point);
    expect(marker.getMarkers().length,1);
    marker.getMarkers().clear();
  });

  test('ensure marker for station is correct', (){
    final marker = MarkerManager();
    Station station = Station(id: 1, name: 'Holborn Station', lat: 0.0, long: 0.0, bikes: 10, emptyDocks: 2, totalDocks: 8);
    expect(marker.getStationMarker(station).markerId, MarkerId("Holborn Station"));
  });

}