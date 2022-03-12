import 'dart:async';
import 'package:bicycle_trip_planner/models/location.dart';
import 'package:bicycle_trip_planner/models/route.dart' as Rou;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/place.dart';
import '../models/station.dart';
import '../services/directions_service.dart';
import 'DirectionManager.dart';
import 'RouteManager.dart';
import 'StationManager.dart';

class NavigationManager {

  final _directionsService = DirectionsService();
  final StationManager _stationManager = StationManager();
  final DirectionManager _directionManager = DirectionManager();

  //********** Singleton **********

  static final NavigationManager _navigationManager = NavigationManager._internal();

  factory NavigationManager() => _navigationManager;

  NavigationManager._internal();

  walkToFirstLocation(Place origin, Place first, [List<Place> intermediates = const <Place>[], int groupSize = 1]) async {
    Location firstLocation = first.geometry.location;
    Location endLocation = RouteManager().getDestinationLocation();

    updatePickUpDropOffStations(firstLocation, endLocation, groupSize);

    await setPartialRoutes([first.name], (intermediates.map((intermediate) => intermediate.name)).toList());
  }

//TODO get rid of parameters since they are from ROUTEMANAGER()
  updateRoute(Place origin, [List<Place> intermediates = const <Place>[], int groupSize = 1]) async {
    Location startLocation = origin.geometry.location;
    Location endLocation = RouteManager().getDestinationLocation();

    updatePickUpDropOffStations(startLocation, endLocation, groupSize);

    await setPartialRoutes([], (intermediates.map((intermediate) => intermediate.name)).toList());
  }

  setNewRoute(Rou.Route startWalkRoute, Rou.Route bikeRoute, Rou.Route endWalkRoute) {
    _directionManager.setRoutes(startWalkRoute, bikeRoute, endWalkRoute, false);
  }

  Future<void> setPartialRoutes([List<String> first = const <String>[], List<String> intermediates = const <String>[]]) async {
    String origin = RouteManager().getStart().getStop().name;
    String destination = RouteManager().getDestination().getStop().name;

    String startStationName = getStationPlaceName(_stationManager.getPickupStation());
    String endStationName = getStationPlaceName(_stationManager.getDropOffStation());

    Rou.Route startWalkRoute = RouteManager().ifBeginning()
        ? await _directionsService.getWalkingRoutes(origin, startStationName, first, false)
        : Rou.Route.routeNotFound();

    Rou.Route bikeRoute = RouteManager().ifBeginning()
        ? await _directionsService.getRoutes(startStationName, endStationName, intermediates, RouteManager().ifOptimised())
        : RouteManager().ifCycling()
        ? await _directionsService.getRoutes(origin, endStationName, intermediates, RouteManager().ifOptimised())
        : Rou.Route.routeNotFound();

    Rou.Route endWalkRoute = RouteManager().ifEndWalking()
        ? await _directionsService.getWalkingRoutes(origin, destination)
        : await _directionsService.getWalkingRoutes(endStationName, destination);

    setNewRoute(startWalkRoute, bikeRoute, endWalkRoute);
  }

  void updatePickUpDropOffStations(Location startLocation, Location endLocation, int groupSize) {
    if (!StationManager().checkPickUpStationHasBikes(groupSize) && !StationManager().passedPickUpStation()) {
      setNewPickUpStation(startLocation, groupSize);
    }
    if (!StationManager().checkDropOffStationHasEmptyDocks(groupSize) && !StationManager().passedDropOffStation()) {
      setNewDropOffStation(endLocation, groupSize);
    }
  }

  Station setNewPickUpStation(Location location, [int groupSize = 1]) {
    return _stationManager.getPickupStationNear(LatLng(location.lat, location.lng), groupSize);
  }

  Station setNewDropOffStation(Location location, [int groupSize = 1]) {
    return _stationManager.getDropoffStationNear(LatLng(location.lat, location.lng), groupSize);
  }

  String getStationPlaceName(Station station) => station.place.name;

  Future<void> setInitialPickUpDropOffStations() async {
    setNewPickUpStation(RouteManager().getStart().getStop().geometry.location, RouteManager().getGroupSize());
    setNewDropOffStation(RouteManager().getDestination().getStop().geometry.location, RouteManager().getGroupSize());
  }

}