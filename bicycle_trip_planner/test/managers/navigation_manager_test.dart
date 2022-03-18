import 'package:bicycle_trip_planner/managers/LocationManager.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/models/geometry.dart';
import 'package:bicycle_trip_planner/models/location.dart';
import 'package:bicycle_trip_planner/models/locator.dart';
import 'package:bicycle_trip_planner/models/pathway.dart';
import 'package:bicycle_trip_planner/models/place.dart';
import 'package:bicycle_trip_planner/models/station.dart';
import 'package:bicycle_trip_planner/models/stop.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bicycle_trip_planner/managers/NavigationManager.dart';

import 'navigation_manager_test.mocks.dart';

@GenerateMocks([Locator])
void main(){
  final navigationManager =  NavigationManager();
  final locationManager = LocationManager();

  
  test("Navigation Start",(){

    expect(navigationManager.getPickupStation(), Station.stationNotFound());
    expect(navigationManager.getDropoffStation(), Station.stationNotFound());
    expect(navigationManager.ifNavigating(), false);
    expect(navigationManager.ifBeginning(), true);
    expect(navigationManager.ifCycling(), false);
    expect(navigationManager.ifEndWalking(), false);

    final station = Station(id: 1,name: "station_1", lat:  51.511800, lng: -0.118960,bikes: 10,emptyDocks: 0,totalDocks: 10,distanceTo: 0, place:Place(placeId: 'start', name: 'Start', description: 'start', geometry: Geometry(location: Location(lng: -0.118960, lat: 51.511800))));
    navigationManager.setDropoffStation(station);
    navigationManager.setPickupStation(station);
    navigationManager.setIfEndWalking(true);
    navigationManager.setIfCycling(true);
    navigationManager.setIfBeginning(false);

    expect(navigationManager.getPickupStation(), station);
    expect(navigationManager.getDropoffStation(), station);
    expect(navigationManager.ifNavigating(), false);
    expect(navigationManager.ifBeginning(), false);
    expect(navigationManager.ifCycling(), true);
    expect(navigationManager.ifEndWalking(), true);

  });

  test("Is waypoint passed",(){
    LatLng waypoint = const LatLng(51.511589, -0.118960);
    locationManager.setCurrentLocation(Place(placeId: 'destination', name: 'Destination', description: 'destination', geometry: Geometry(location: Location(lng: -0.118960, lat: 51.5118))));

    expect(navigationManager.isWaypointPassed(waypoint),true);


    waypoint = const LatLng(50, -0.118960);
    locationManager.setCurrentLocation(Place(placeId: 'destination', name: 'Destination', description: 'destination', geometry: Geometry(location: Location(lng: -0.118960, lat: 51.5118))));

    expect(navigationManager.isWaypointPassed(waypoint),false);

  });

  //This test shows that there is a bug where you will skip the cycling section when the stops are within 30 meters of each other
  //Stations could be a maximum of 60 meters away, however both will disappear once the user is within the radius for both
  test("Pass waypoints when user is within 30 meters of both at the same time",(){

    locationManager.setCurrentLocation(Place(placeId: 'destination', name: 'Destination', description: 'destination', geometry: Geometry(location: Location(lng: 0, lat: 0))));

    //Creating start and end stations
    final station_1 = Station(id: 1,name: "station_1", lat:  51.511800, lng: -0.118960,bikes: 10,emptyDocks: 0,totalDocks: 10,distanceTo: 0, place:Place(placeId: 'start', name: 'Start', description: 'start', geometry: Geometry(location: Location(lng: -0.118960, lat: 51.511800))));

    final station_2 = Station(id: 2,name: "station_2", lat: 51.5120, lng: -0.118800,bikes: 10,emptyDocks: 0,totalDocks: 10,distanceTo: 0, place:Place(placeId: 'destination', name: 'Destination', description: 'destination', geometry: Geometry(location: Location(lng: -0.128800, lat: 51.5120))));

    //Setting the beginning to be true at first, the rest are false
    navigationManager.setIfBeginning(true);
    navigationManager.setIfCycling(false);
    navigationManager.setIfEndWalking(false);

    //Setting pickup and dropoff stations
    navigationManager.setPickupStation(station_1);
    navigationManager.setDropoffStation(station_2);

    expect(navigationManager.ifBeginning(), true);
    expect(navigationManager.ifCycling(), false);
    expect(navigationManager.ifEndWalking(), false);

    locationManager.setCurrentLocation(Place(placeId: 'currentLocation', name: 'currentLocation', description: 'currentLocation', geometry: Geometry(location: Location(lng: -0.118960, lat: 51.511805))));
    navigationManager.checkPassedByPickUpDropOffStations();

    expect(navigationManager.ifBeginning(), false);
    expect(navigationManager.ifCycling(), false);
    expect(navigationManager.ifEndWalking(), true);
  });

  test("Pass waypoints when user is not within 30 meters of both at the same time", (){

    locationManager.setCurrentLocation(Place(placeId: 'destination', name: 'Destination', description: 'destination', geometry: Geometry(location: Location(lng: 0, lat: 0))));

    //Creating start and end stations
    final station_1 = Station(id: 1,name: "station_1", lat:  51.511800, lng: -0.118960,bikes: 10,emptyDocks: 0,totalDocks: 10,distanceTo: 0, place:Place(placeId: 'start', name: 'Start', description: 'start', geometry: Geometry(location: Location(lng: -0.118960, lat: 51.511800))));

    final station_3 = Station(id: 2,name: "station_2", lat: 60.5120, lng: -0.128800,bikes: 10,emptyDocks: 0,totalDocks: 10,distanceTo: 0, place:Place(placeId: 'destination', name: 'Destination', description: 'destination', geometry: Geometry(location: Location(lng: -0.128800, lat: 60.5120))));

        //Setting the beginning to be true at first, the rest are false
    navigationManager.setIfBeginning(true);
    navigationManager.setIfCycling(false);
    navigationManager.setIfEndWalking(false);

    //Setting pickup and dropoff stations
    navigationManager.setPickupStation(station_1);
    navigationManager.setDropoffStation(station_3);

    expect(navigationManager.ifBeginning(), true);
    expect(navigationManager.ifCycling(), false);
    expect(navigationManager.ifEndWalking(), false);

    locationManager.setCurrentLocation(Place(placeId: 'currentLocation', name: 'currentLocation', description: 'currentLocation', geometry: Geometry(location: Location(lng: -0.118960, lat: 51.511805))));
    navigationManager.checkPassedByPickUpDropOffStations();

    expect(navigationManager.ifBeginning(), false);
    expect(navigationManager.ifCycling(), true);
    expect(navigationManager.ifEndWalking(), false);

    locationManager.setCurrentLocation(Place(placeId: 'currentLocation', name: 'currentLocation', description: 'currentLocation', geometry: Geometry(location: Location(lng: -0.128800, lat: 60.5120))));
    navigationManager.checkPassedByPickUpDropOffStations();

    expect(navigationManager.ifBeginning(), false);
    expect(navigationManager.ifCycling(), false);
    expect(navigationManager.ifEndWalking(), true);
   });

  test("Ensure that boolean's don't change when user is not within 30 meters radius", (){
    expect(navigationManager.ifBeginning(), true);
    expect(navigationManager.ifCycling(), false);
    expect(navigationManager.ifEndWalking(), false);

    //Checks if current location indicates if first stop has been passed, should return no change
    navigationManager.checkPassedByPickUpDropOffStations();

    expect(navigationManager.ifBeginning(), true);
    expect(navigationManager.ifCycling(), false);
    expect(navigationManager.ifEndWalking(), false);
  });


}

