import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/models/station.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test/test.dart';
import 'package:bicycle_trip_planner/managers/MarkerManager.dart';
import 'package:bicycle_trip_planner/models/place.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mockito/annotations.dart';
import 'marker_manager_test.mocks.dart';

@GenerateMocks([ApplicationBloc])
void main(){
  final markerManager = MarkerManager();
  final mockAppBloc = MockApplicationBloc();

  setUp(() {
    markerManager.getMarkers().clear();
  });

  test('ensure that there are no markers at the start', (){
    expect(MarkerManager().getMarkers().length,0);
  });

  test('ensure multiple markers can be added', (){
    expect(markerManager.getMarkers().length,0);
    for (int i = 0; i < 100; i++) {
      markerManager.setMarker(LatLng(51.511448 + i, -0.116414 + i), i.toString());
    }
    expect(markerManager.getMarkers().length,100);
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
  });

  test('ensure marker is added for place requested', (){
    LatLng location = const LatLng(51.511448, -0.116414);
    Place place = Place(latlng: location, name: 'Bush House', placeId: "1", description: "description");
    expect(markerManager.getMarkers().length,0);
    markerManager.setPlaceMarker(place, 1);
    expect(markerManager.getMarkers().length,1);
  });

  test('ensure marker is added for user location', (){
    Position point = Position(
        longitude: 51.511448,
        latitude: -0.116414,
        timestamp: DateTime.now(),
        accuracy: 1,
        altitude: 1,
        heading: 1,
        speed: 1,
        speedAccuracy: 1
    );
    markerManager.setMarker(LatLng(51.511448, -51.511448), 'user');
    expect(markerManager.getMarkers().length,1);
    markerManager.setUserMarker(LatLng(point.latitude, point.longitude));
    expect(markerManager.getMarkers().length,1);
  });

  test('ensure marker for station is correct', (){
      List<Station> station = <Station>[
        Station(
            id: 1,
            name: 'Holborn Station',
            lat: 1.0,
            lng: 2.0,
            bikes: 10,
            emptyDocks: 2,
            totalDocks: 12,
            distanceTo: 1
        ),
        Station(
            id: 2,
            name: 'Maida Vale Station',
            lat: 12.0,
            lng: 23.0,
            bikes: 5,
            emptyDocks: 3,
            totalDocks: 8,
            distanceTo: 4
        )
      ];
    expect(markerManager.getMarkers().length,0);
    markerManager.setStationMarkers(station, mockAppBloc);
    expect(markerManager.getMarkers().length,2);
  });

  test('ensure marker for station is correct', (){
    Station station = Station(
        id: 1,
        name: 'Holborn Station',
        lat: 1.0,
        lng: 2.0,
        bikes: 10,
        emptyDocks: 2,
        totalDocks: 8,
        distanceTo: 1
    );
    expect(markerManager.getMarkers().length,0);
    markerManager.setStationMarker(station, mockAppBloc);
    expect(markerManager.getMarkers().length,1);
  });

  test('ensure marker for station is correct', (){
      List<Station> station = <Station>[
        Station(
            id: 1,
            name: 'Holborn Station',
            lat: 1.0,
            lng: 2.0,
            bikes: 10,
            emptyDocks: 2,
            totalDocks: 12,
            distanceTo: 1
        ),
        Station(
            id: 2,
            name: 'Maida Vale Station',
            lat: 12.0,
            lng: 23.0,
            bikes: 5,
            emptyDocks: 3,
            totalDocks: 8,
            distanceTo: 4
        )
      ];
      markerManager.setStationMarkers(station, mockAppBloc);
      expect(markerManager.getMarkers().length,2);
      markerManager.clearStationMarkers(station);
      expect(markerManager.getMarkers().length,0);
  });

  test('ensure marker for station uid is correct', (){
      Station station = Station(
          id: 1,
          name: 'Holborn Station',
          lat: 1.0,
          lng: 2.0,
          bikes: 10,
          emptyDocks: 2,
          totalDocks: 8,
          distanceTo: 1
      );
      markerManager.setStationMarkerWithUID(station, mockAppBloc);
      expect(markerManager.getMarkers().length,1);
  });

  test('remove existing marker using uid', (){
    LatLng location = const LatLng(51.511448, -0.116414);
    Place place = Place(latlng: location, name: 'Bush House', placeId: "1", description: "description");
    expect(markerManager.getMarkers().length,0);
    markerManager.setPlaceMarker(place, 1);
    expect(markerManager.getMarkers().length,1);
    markerManager.clearMarker(1);
    expect(markerManager.getMarkers().length,0);
  });

  test('remove non-existing marker using uid', (){
    LatLng location = const LatLng(51.511448, -0.116414);
    Place place = Place(latlng: location, name: 'Bush House', placeId: "1", description: "description");
    expect(markerManager.getMarkers().length,0);
    markerManager.setPlaceMarker(place, 1);
    expect(markerManager.getMarkers().length,1);
    markerManager.clearMarker(2); // doesn't exist
    expect(markerManager.getMarkers().length,1);
  });
}