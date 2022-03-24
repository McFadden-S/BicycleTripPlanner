

import 'package:bicycle_trip_planner/managers/LocationManager.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/managers/StationManager.dart';
import 'package:bicycle_trip_planner/models/geometry.dart';
import 'package:bicycle_trip_planner/models/location.dart';
import 'package:bicycle_trip_planner/models/locator.dart';
import 'package:bicycle_trip_planner/models/place.dart';
import 'package:bicycle_trip_planner/models/route.dart';
import 'package:bicycle_trip_planner/models/station.dart';
import 'package:bicycle_trip_planner/services/directions_service.dart';
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
        geometry: Geometry(location: Location(lng: lng, lat: lat))));
  }

  void expectWalkingBikingEnd(bool walk, bool bike, bool end) {
    expect(navigationManager.ifBeginning(), walk);
    expect(navigationManager.ifCycling(), bike);
    expect(navigationManager.ifEndWalking(), end);
  }

  setRoute(Place origin, Place destination,
      [List<Place> intermediates = const <Place>[], int groupSize = 1]) async {
    Location startLocation = origin.geometry.location;
    Location endLocation = destination.geometry.location;

    Station startStation = await StationManager().getPickupStationNear(
        LatLng(startLocation.lat, startLocation.lng), groupSize);
    Station endStation = await StationManager().getDropoffStationNear(
        LatLng(endLocation.lat, endLocation.lng), groupSize);

    List<String> intermediatePlaceId =
    intermediates.map((place) => place.placeId).toList();

    Route startWalkRoute = await DirectionsService().getWalkingRoutes(
        origin.placeId, startStation.place.placeId);
    Route bikeRoute = await DirectionsService().getRoutes(
        startStation.place.placeId,
        endStation.place.placeId,
        intermediatePlaceId,
        RouteManager().ifOptimised());
    Route endWalkRoute = await DirectionsService().getWalkingRoutes(
        endStation.place.placeId, destination.placeId);
    RouteManager().setRoutes(startWalkRoute, bikeRoute, endWalkRoute);
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
            geometry: Geometry(location: Location(lng: lng, lat: lat))));
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

  test("Ensure isWaypointPassed is true when user is in 30m radius", () {
    LatLng waypoint = const LatLng(51.511589, -0.118960);
    setCurrentLocation(51.5118, -0.118960);

    expect(navigationManager.isWaypointPassed(waypoint), true);
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

    //Setting pickup and dropoff stations
    navigationManager.setPickupStation(station_1);
    navigationManager.setDropoffStation(station_2);

    setCurrentLocation(51.511805, -0.118960);
    navigationManager.checkPassedByPickUpDropOffStations();

    expectWalkingBikingEnd(false, false, true);
  });

  test(
      "Pass waypoints when user is not within 30 meters of both at the same time",
      () {
    final station_1 = createStation(1, "station_1", 51.511800, -0.118960);
    final station_2 = createStation(2, "station_2", 60.5120, -0.128800);

    //Setting pickup and dropoff stations
    navigationManager.setPickupStation(station_1);
    navigationManager.setDropoffStation(station_2);

    setCurrentLocation(51.511805, -0.118960);
    navigationManager.checkPassedByPickUpDropOffStations();

    expectWalkingBikingEnd(false, true, false);

    setCurrentLocation(60.5120, -0.128800);
    navigationManager.checkPassedByPickUpDropOffStations();

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

    //Setting pickup and dropoff stations
    RouteManager().setStartFromCurrentLocation(true);
    setRoute(locationManager.getCurrentLocation(), station_1.place);

    expect(navigationManager.ifNavigating(), false);

    navigationManager.start();

    expect(navigationManager.ifNavigating(), true);
    expect(navigationManager.ifBeginning(), true);
    expect(navigationManager.ifCycling(), false);
  });

  test("Test start navigation from defined location with one waypoint", () {
    final start = Place(geometry: Geometry(location: Location(lat: 1, lng:1)), description: "Start", name: "Start", placeId: "12345");
    final middle = Place(geometry: Geometry(location: Location(lat: 1, lng:1)), description: "Middle", name: "Middle", placeId: "67890");
    final end = createStation(1, "station_1", 51.511800, -0.118960);

    setRoute(start, end.place, [middle]);

    expect(navigationManager.ifNavigating(), false);
    RouteManager().setStartFromCurrentLocation(false);
    RouteManager().setWalkToFirstWaypoint(true);

    navigationManager.start();

    expectWalkingBikingEnd(true, false, false);
  });

  test("Test update navigation", () async {
    final station_1 = createStation(1, "station_1", 51.511800, -0.118960);
    final station_2 = createStation(2, "station_2", 60.5120, -0.128800);

    navigationManager.setPickupStation(station_1);
    navigationManager.setDropoffStation(station_2);

    expect(navigationManager.ifNavigating(), false);

    navigationManager.start();

    expectWalkingBikingEnd(true, false, false);

    setCurrentLocation(51.511800, -0.118960);
    await navigationManager.updateRoute();

    expectWalkingBikingEnd(false, true, false);

    setCurrentLocation(60.5120, -0.128800);
    await navigationManager.updateRoute();

    expectWalkingBikingEnd(false, false, true);
  });

  test("Test route start to end", () async {
    final start = Place(geometry: Geometry(location: Location(lat: 41.511800, lng:-0.118960)), description: "Start", name: "Start", placeId: "12345");
    final station_1 = createStation(1, "station_1", 51.511800, -0.118960);
    final middle = Place(geometry: Geometry(location: Location(lat: 60.5120, lng:-0.118960)), description: "Middle", name: "Middle", placeId: "67890");
    final station_2 = createStation(1, "station_1", 100.511800, -0.118960);

    setRoute(start, station_2.place, [middle]);
    navigationManager.setPickupStation(station_1);
    navigationManager.setDropoffStation(station_2);

    setCurrentLocation(41.511800, -0.118960);
    RouteManager().setWalkToFirstWaypoint(true);
    RouteManager().setStartFromCurrentLocation(true);
    navigationManager.start();
    expectWalkingBikingEnd(true, false, false);
    setCurrentLocation(51.511800, -0.118960);
    await navigationManager.updateRoute();

    expectWalkingBikingEnd(false, true, false);

    setCurrentLocation(60.5120, -0.118960);
    await navigationManager.updateRoute();

    expectWalkingBikingEnd(false, true, false);

    setCurrentLocation(100.511800, -0.118960);
    await navigationManager.updateRoute();

    expectWalkingBikingEnd(false, false, true);

    setCurrentLocation(110.511800, -0.128800);
    await navigationManager.updateRoute();

    navigationManager.clear();
    expect(navigationManager.ifNavigating(), false);
  });
}
