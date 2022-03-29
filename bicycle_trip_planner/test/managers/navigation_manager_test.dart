import 'package:bicycle_trip_planner/managers/LocationManager.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/models/locator.dart';
import 'package:bicycle_trip_planner/models/place.dart';
import 'package:bicycle_trip_planner/models/station.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:bicycle_trip_planner/managers/NavigationManager.dart';

@GenerateMocks([Locator])
void main() {
  final navigationManager = NavigationManager();
  final locationManager = LocationManager();

  // ************ Helper functions ***************

  void setCurrentLocation(double lat, double lng) {
    locationManager.setCurrentLocation(Place(
        placeId: 'place',
        name: 'name',
        description: 'description',
        latlng: LatLng(lng, lat)));
  }

  void expectWalkingBikingEnd(bool walk, bool bike, bool end) {
    expect(navigationManager.ifBeginning(), walk);
    expect(navigationManager.ifCycling(), bike);
    expect(navigationManager.ifEndWalking(), end);
  }

  Station createStation(int id, String name, double lat, double lng) {
    return Station(
        id: id,
        name: name,
        lat: lat,
        lng: lng,
        bikes: 10,
        emptyDocks: 0,
        totalDocks: 10,
        distanceTo: 0,
        place: Place(
            placeId: 'place',
            name: 'name',
            description: 'description',
            latlng: LatLng(lng, lat)));
  }

  // ************ SetUp ***************

  // Resets navigation manager
  setUp(() {
    setCurrentLocation(0, 0);
    navigationManager.reset();
  });

  // ************ Tests ***************

  test("Ensure navigation initialises correctly", () {
    expect(navigationManager.getPickupStation(), Station.stationNotFound());
    expect(navigationManager.getDropoffStation(), Station.stationNotFound());
    expect(navigationManager.ifNavigating(), false);
    expect(navigationManager.ifBeginning(), true);
    expect(navigationManager.ifCycling(), false);
    expect(navigationManager.ifEndWalking(), false);
  });

  test("Ensure navigation setters work correctly", () {
    final station = createStation(1, "station_1", 51.511800, -0.118960);

    navigationManager.setDropoffStation(station);
    navigationManager.setPickupStation(station);
    navigationManager.setIfEndWalking(true);
    navigationManager.setIfCycling(true);
    navigationManager.setIfBeginning(false);

    expect(navigationManager.getPickupStation(), station);
    expect(navigationManager.getDropoffStation(), station);
    expectWalkingBikingEnd(false, true, true);
  });

  test(
      "Ensure that boolean's don't change when user is not within 30 meters radius",
      () {
    final station_1 = createStation(1, "station_1", 51.511800, -0.118960);
    final station_2 = createStation(2, "station_2", 51.5120, -0.118800);

    navigationManager.setPickupStation(station_1);
    navigationManager.setDropoffStation(station_2);

    expectWalkingBikingEnd(true, false, false);

    //Checks if current location indicates if first stop has been passed, should return no change
    navigationManager.checkPassedByPickUpDropOffStations();

    expectWalkingBikingEnd(true, false, false);
  });

  test("Ensure isWaypointPassed is false when user is not in 30m radius", () {
    LatLng waypoint = const LatLng(50, -0.118960);
    setCurrentLocation(51.5118, -0.118960);

    expect(navigationManager.isWaypointPassed(waypoint), false);
  });

  //This test shows that there is a bug where you will skip the cycling section when the stops are within 30 meters of each other
  //Stations could be a maximum of 60 meters away, however both will disappear once the user is within the radius for both
  test("Pass waypoints when user is within 30 meters of both at the same time",
      () {
    //Creating start and end stations
    final station_1 = createStation(1, "station_1", 51.511800, -0.118960);
    final station_2 = createStation(2, "station_2", 51.5120, -0.118800);

    //Setting pickup and drop off stations
    navigationManager.setPickupStation(station_1);
    navigationManager.setDropoffStation(station_2);

    setCurrentLocation(51.511805, -0.118960);
    navigationManager.checkPassedByPickUpDropOffStations();
    navigationManager.setIfBeginning(false);
    navigationManager.setIfEndWalking(true);

    expectWalkingBikingEnd(false, false, true);
  });

  test(
      "Pass waypoints when user is not within 30 meters of both at the same time",
      () {
    final station_1 = createStation(1, "station_1", 51.511800, -0.118960);
    final station_2 = createStation(2, "station_2", 60.5120, -0.128800);

    //Setting pickup and drop off stations
    navigationManager.setPickupStation(station_1);
    navigationManager.setDropoffStation(station_2);

    setCurrentLocation(51.511805, -0.118960);
    navigationManager.checkPassedByPickUpDropOffStations();

    navigationManager.setIfBeginning(false);
    navigationManager.setIfCycling(true);
    expectWalkingBikingEnd(false, true, false);

    setCurrentLocation(60.5120, -0.128800);
    navigationManager.checkPassedByPickUpDropOffStations();
    navigationManager.setIfCycling(false);
    navigationManager.setIfEndWalking(true);

    expectWalkingBikingEnd(false, false, true);
  });

  test("Test start navigation from station", () {
    final station_1 = createStation(1, "station_1", 51.511800, -0.118960);
    final station_2 = createStation(2, "station_2", 60.5120, -0.128800);

    navigationManager.setPickupStation(station_1);
    navigationManager.setDropoffStation(station_2);

    expect(navigationManager.ifNavigating(), false);

    navigationManager.start();

    expect(navigationManager.ifNavigating(), true);
    expect(navigationManager.ifBeginning(), true);
    expect(navigationManager.ifCycling(), false);
    expect(navigationManager.getPickupStation(), station_1);
    expect(navigationManager.getDropoffStation(), station_2);
  });

  test("Test start navigation from current location", () {
    setCurrentLocation(1, 2);
    final station_1 = createStation(1, "station_1", 51.511800, -0.118960);

    //Setting pickup and drop off stations
    RouteManager().setStartFromCurrentLocation(true);

    expect(navigationManager.ifNavigating(), false);

    navigationManager.start();

    expect(navigationManager.ifNavigating(), true);
    expect(navigationManager.ifBeginning(), true);
    expect(navigationManager.ifCycling(), false);
  });

  test("Test start navigation from defined location with one waypoint", () {
    final start = Place(
        latlng: const LatLng(1, 1),
        description: "Start",
        name: "Start",
        placeId: "12345");
    final middle = Place(
        latlng: const LatLng(1, 1),
        description: "Middle",
        name: "Middle",
        placeId: "67890");
    final end = createStation(1, "station_1", 51.511800, -0.118960);

    expect(navigationManager.ifNavigating(), false);
    RouteManager().setStartFromCurrentLocation(false);
    RouteManager().setWalkToFirstWaypoint(true);

    navigationManager.start();

    expectWalkingBikingEnd(true, false, false);
  });

  test("Test update navigation", () async {
    final station_1 = createStation(1, "station_1", 51.511800, -0.118960);
    final station_2 = createStation(2, "station_2", 60.5120, -0.128800);

    expect(navigationManager.ifNavigating(), false);

    await navigationManager.start();

    navigationManager.setPickupStation(station_1);
    navigationManager.setDropoffStation(station_2);

    expectWalkingBikingEnd(true, false, false);

    setCurrentLocation(51.511800, -0.118960);
    await navigationManager.updateRoute();
    navigationManager.setIfCycling(true);
    navigationManager.setIfBeginning(false);

    expectWalkingBikingEnd(false, true, false);

    setCurrentLocation(60.5120, -0.128800);
    await navigationManager.updateRoute();
    navigationManager.setIfCycling(false);
    navigationManager.setIfEndWalking(true);

    expectWalkingBikingEnd(false, false, true);
  });

  test("Test route start to end", () async {
    final start = Place(
        latlng: const LatLng(41.511800, -0.118960),
        description: "Start",
        name: "Start",
        placeId: "12345");
    final station_1 = createStation(1, "station_1", 51.511800, -0.118960);
    final middle = Place(
        latlng: const LatLng(60.5120, -0.118960),
        description: "Middle",
        name: "Middle",
        placeId: "67890");
    final station_2 = createStation(1, "station_1", 100.511800, -0.118960);

    setCurrentLocation(41.511800, -0.118960);
    RouteManager().setWalkToFirstWaypoint(true);
    RouteManager().setStartFromCurrentLocation(true);
    await navigationManager.start();

    navigationManager.setPickupStation(station_1);
    navigationManager.setDropoffStation(station_2);

    expectWalkingBikingEnd(true, false, false);
    setCurrentLocation(51.511800, -0.118960);
    await navigationManager.updateRoute();

    navigationManager.setIfCycling(true);
    navigationManager.setIfBeginning(false);
    expectWalkingBikingEnd(false, true, false);

    setCurrentLocation(60.5120, -0.118960);
    await navigationManager.updateRoute();
    expectWalkingBikingEnd(false, true, false);

    setCurrentLocation(100.511800, -0.118960);
    await navigationManager.updateRoute();

    navigationManager.setIfCycling(false);
    navigationManager.setIfEndWalking(true);
    expect(await navigationManager.checkWaypointPassed(),false);

    expectWalkingBikingEnd(false, false, true);

    setCurrentLocation(110.511800, -0.128800);
    await navigationManager.updateRoute();

    navigationManager.clear();
    expect(navigationManager.ifNavigating(), false);
  });

  test("ensure can clear all fields", () {
    navigationManager.clear();
    expect(navigationManager.ifBeginning(), true);
    expect(navigationManager.ifCycling(), false);
    expect(navigationManager.ifEndWalking(), false);
    expect(navigationManager.ifNavigating(), false);
  });
}
