import 'package:bicycle_trip_planner/managers/LocationManager.dart';
import 'package:bicycle_trip_planner/managers/StationManager.dart';
import 'package:bicycle_trip_planner/models/locator.dart';
import 'package:bicycle_trip_planner/models/place.dart';
import 'package:bicycle_trip_planner/models/station.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
        latlng: LatLng(lat, lng)
    ));
  }

  List<Station> createDummyStations() {
    List<Station> stations = [];
    for (int i = 1; i <= 10; i++) {
      stations.add(
          Station(
              name: "Station "+i.toString(),
              lat: i.toDouble(),
              lng: i.toDouble(),
              bikes: i-1,
              emptyDocks: 10-i-1,
              id: i,
              totalDocks: 20,
              distanceTo: i.toDouble(),
              place: Place(
                  name: "P" + i.toString(),
                  placeId: i.toString(),
                  description: "Desc " + i.toString(),
                  latlng: LatLng(i.toDouble(), i.toDouble())
                 )));
    }
    return stations;
  }

  setUp((){
    WidgetsFlutterBinding.ensureInitialized();
    setCurrentLocation(1, 1);
    List<Station> stations = createDummyStations();
    stationManager.setStations(stations);
  });

  test('Test station manager return correct number of stations', () {
    expect(stationManager.getNumberOfStations(), 10);
  });

  test('Test return correct station by index', () {
    Station s = stationManager.getStationByIndex(5);
    List<Station> dummyStation = createDummyStations();
    expect(s.id, dummyStation[5].id);
  });

  test('Test return no station by invalid index', () {
    Station s = stationManager.getStationByIndex(9);
    //TODO Check exceptions
    /*expect(s.name, Station.stationNotFound().name);
    expect(s.lat, Station.stationNotFound().lat);
    expect(s.lng, Station.stationNotFound().lng);
    expect(s.id, Station.stationNotFound().id);
    expect(s.bikes, Station.stationNotFound().bikes);
    expect(s.emptyDocks, Station.stationNotFound().emptyDocks);
    expect(s.totalDocks, Station.stationNotFound().totalDocks);
    expect(s.distanceTo, Station.stationNotFound().distanceTo);*/

  });

  test('Test return correct station by id', () {
    Station s = stationManager.getStationById(5);
    List<Station> dummyStation = createDummyStations();
    expect(s.id, dummyStation[4].id);
  });

  test('Test return no station by invalid id', () {
    Station s = stationManager.getStationById(100);
    expect(s.name, Station.stationNotFound().name);
    expect(s.lat, Station.stationNotFound().lat);
    expect(s.lng, Station.stationNotFound().lng);
    expect(s.id, Station.stationNotFound().id);
    expect(s.bikes, Station.stationNotFound().bikes);
    expect(s.emptyDocks, Station.stationNotFound().emptyDocks);
    expect(s.totalDocks, Station.stationNotFound().totalDocks);
    expect(s.distanceTo, Station.stationNotFound().distanceTo);
  });

  test('Test getStations', () {
    List<Station> s = stationManager.getStations();
    List<Station> dummyStation = createDummyStations();
    expect(ListEquality().equals(s, dummyStation), true);
  });

  test('Test getStationsInRadius returns the correct station', () {
    List<Station> s = stationManager.getStationsInRadius(LatLng(3,3));
    List<Station> dummyStation = createDummyStations();
    expect(s.length, 1);
    expect(s.first.id, 3);
  });

  test('Test return correct station by name', () {
    Station s = stationManager.getStationByName("Station 4");
    List<Station> dummyStation = createDummyStations();
    expect(s.id, dummyStation[3].id);
  });

  test('Test return no station by invalid name', () {
    Station s = stationManager.getStationByName("Bike 4");
    expect(s.name, Station.stationNotFound().name);
    expect(s.lat, Station.stationNotFound().lat);
    expect(s.lng, Station.stationNotFound().lng);
    expect(s.id, Station.stationNotFound().id);
    expect(s.bikes, Station.stationNotFound().bikes);
    expect(s.emptyDocks, Station.stationNotFound().emptyDocks);
    expect(s.totalDocks, Station.stationNotFound().totalDocks);
    expect(s.distanceTo, Station.stationNotFound().distanceTo);
  });

  test('Test return correct stations with bikes', () {
    List<Station> dummyStation = createDummyStations();
    List<Station> s = stationManager.getStationsWithBikes(1, dummyStation);
    expect(s.length, 9);
    for(int i=0; i<s.length; i++){
      expect(s[i].bikes, greaterThanOrEqualTo(1));
    }
  });

  test('Test getNearStations returns the correct stationa', () {
    List<Station> s = stationManager.getNearStations(500.0);

    expect(s.length, 6);
    for(int i=0; i<s.length; i++){
      expect(s[i].distanceTo, lessThanOrEqualTo(500.0));
    }
  });

  test('Test getStationsCompliment of itself returns no station', () {
    List<Station> s = stationManager.getStationsCompliment(stationManager.getStations());

    expect(s.length, 0);
  });

  test('Test getStationsCompliment of 0 returns all stations', () {
    List<Station> s = stationManager.getStationsCompliment([]);

    expect(s.length, stationManager.getNumberOfStations());
  });

  test('Test getStationsCompliment of half list of station returns other half', () {
    List<Station> s = stationManager.getStationsCompliment(stationManager.getStations().take(5).toList());
    List<Station> dummyStation = createDummyStations();
    expect(s.length, 5);
    for(int i = (stationManager.getNumberOfStations()/2).toInt(); i < stationManager.getNumberOfStations(); i++){
      expect(stationManager.getStationByIndex(i).id, dummyStation[i].id);
      expect(stationManager.getStationByIndex(i).name, dummyStation[i].name);
      expect(stationManager.getStationByIndex(i).lat, dummyStation[i].lat);
      expect(stationManager.getStationByIndex(i).lng, dummyStation[i].lng);
      expect(stationManager.getStationByIndex(i).id, dummyStation[i].id);
      expect(stationManager.getStationByIndex(i).bikes, dummyStation[i].bikes);
      expect(stationManager.getStationByIndex(i).emptyDocks, dummyStation[i].emptyDocks);
      expect(stationManager.getStationByIndex(i).totalDocks, dummyStation[i].totalDocks);
    }
  });

  test('Test getDropOffStationNear return correct station', () async {
    Station s = await stationManager.getDropoffStationNear(LatLng(3,3));
    List<Station> dummyStation = createDummyStations();
    expect(s.name, dummyStation[2].name);
    expect(s.lat, dummyStation[2].lat);
    expect(s.lng, dummyStation[2].lng);
    expect(s.id, dummyStation[2].id);
    expect(s.bikes, dummyStation[2].bikes);
    expect(s.emptyDocks, dummyStation[2].emptyDocks);
    expect(s.totalDocks, dummyStation[2].totalDocks);

  });

  test('Test getPickUpStationNear return correct station', () async {
    Station s = await stationManager.getPickupStationNear(LatLng(3,3));
    List<Station> dummyStation = createDummyStations();
    expect(s.name, dummyStation[2].name);
    expect(s.lat, dummyStation[2].lat);
    expect(s.lng, dummyStation[2].lng);
    expect(s.id, dummyStation[2].id);
    expect(s.bikes, dummyStation[2].bikes);
    expect(s.emptyDocks, dummyStation[2].emptyDocks);
    expect(s.totalDocks, dummyStation[2].totalDocks);

  });

  test('ensure can cache PlaceId', () async {
    final station = Station(id: 1, name: 'Holborn Station', lat: 0.0, lng: 0.0, bikes: 10, emptyDocks: 2, totalDocks: 8);
    stationManager.cachePlaceId(station);
    expect(station.place.toString(), "");
  });
}