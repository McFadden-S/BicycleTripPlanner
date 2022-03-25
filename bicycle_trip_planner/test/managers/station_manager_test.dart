import 'package:bicycle_trip_planner/managers/LocationManager.dart';
import 'package:bicycle_trip_planner/managers/StationManager.dart';
import 'package:bicycle_trip_planner/models/geometry.dart';
import 'package:bicycle_trip_planner/models/location.dart';
import 'package:bicycle_trip_planner/models/locator.dart';
import 'package:bicycle_trip_planner/models/place.dart';
import 'package:bicycle_trip_planner/models/station.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([Locator])
void main() {
  final stationManager = StationManager();
  final locationManager = LocationManager();

  // ************ Helper functions ***************

  void setCurrentLocation(double lat, double lng) {
    locationManager.setCurrentLocation(Place(
        placeId: 'place',
        name: 'name',
        description: 'description',
        geometry: Geometry(location: Location(lng: lng, lat: lat))));
  }

  List<Station> createDummyStations() {
    List<Station> stations = [];
    for (int i = 1; i <= 10; i++) {
      stations.add(
          Station(
              name: "Station 1",
              lat: i.toDouble(),
              lng: i.toDouble(),
              bikes: 10,
              emptyDocks: 10,
              id: i,
              totalDocks: 20,
              distanceTo: 20,
              place: Place(
                  name: "P" + i.toString(),
                  placeId: i.toString(),
                  description: "Desc " + i.toString(),
                  geometry: Geometry(location: Location(
                      lng: i.toDouble(), lat: i.toDouble())))));
    }
    return stations;
  }

  setUp((){
    WidgetsFlutterBinding.ensureInitialized();
    setCurrentLocation(5, 5);
    List<Station> stations = createDummyStations();
    stationManager.setStations(stations);
  });

  test('Test station manager return correct number of stations', () {
    List<Station> stations = createDummyStations();
    stationManager.setStations(stations);
    expect(stationManager.getNumberOfStations(), 10);
  });
}