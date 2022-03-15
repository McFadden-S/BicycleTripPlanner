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

  bool _isNavigating = false;

  //********** Singleton **********

  static final NavigationManager _navigationManager =
      NavigationManager._internal();

  factory NavigationManager() => _navigationManager;

  NavigationManager._internal();

  //********** Public **********

  bool ifNavigating() {
    return _isNavigating;
  }

  //TODO: Temporary fix, should be refactored
  void setNavigating(bool isNavigating) {
    _isNavigating = isNavigating;
  }

  walkToFirstLocation(Place origin, Place first,
      [List<Place> intermediates = const <Place>[], int groupSize = 1]) async {
    Location firstLocation = first.geometry.location;
    Location endLocation = RouteManager().getDestinationLocation();

    updatePickUpDropOffStations(firstLocation, endLocation, groupSize);

    await setPartialRoutes([first.name],
        (intermediates.map((intermediate) => intermediate.placeId)).toList());
  }

//TODO get rid of parameters since they are from ROUTEMANAGER()
  updateRoute(Place origin,
      [List<Place> intermediates = const <Place>[], int groupSize = 1]) async {
    Location startLocation = origin.geometry.location;
    Location endLocation = RouteManager().getDestinationLocation();

    updatePickUpDropOffStations(startLocation, endLocation, groupSize);

    await setPartialRoutes([],
        (intermediates.map((intermediate) => intermediate.placeId)).toList());
  }

  setNewRoute(
      Rou.Route startWalkRoute, Rou.Route bikeRoute, Rou.Route endWalkRoute) {
    DirectionManager()
        .setRoutes(startWalkRoute, bikeRoute, endWalkRoute, false);
  }

  Future<void> setPartialRoutes(
      [List<String> first = const <String>[],
      List<String> intermediates = const <String>[]]) async {
    String originId = RouteManager().getStart().getStop().placeId;
    String destinationId = RouteManager().getDestination().getStop().placeId;

    String startStationId = StationManager().getPickupStation().place.placeId;
    String endStationId = StationManager().getDropOffStation().place.placeId;

    Rou.Route startWalkRoute = RouteManager().ifBeginning()
        ? await _directionsService.getWalkingRoutes(
            originId, startStationId, first, false)
        : Rou.Route.routeNotFound();

    Rou.Route bikeRoute = RouteManager().ifBeginning()
        ? await _directionsService.getRoutes(startStationId, endStationId,
            intermediates, RouteManager().ifOptimised())
        : RouteManager().ifCycling()
            ? await _directionsService.getRoutes(originId, endStationId,
                intermediates, RouteManager().ifOptimised())
            : Rou.Route.routeNotFound();

    Rou.Route endWalkRoute = RouteManager().ifEndWalking()
        ? await _directionsService.getWalkingRoutes(originId, destinationId)
        : await _directionsService.getWalkingRoutes(
            endStationId, destinationId);

    setNewRoute(startWalkRoute, bikeRoute, endWalkRoute);
  }

  Future<void> updatePickUpDropOffStations(
      Location startLocation, Location endLocation, int groupSize) async {
    if (!StationManager().checkPickUpStationHasBikes(groupSize) &&
        !StationManager().passedPickUpStation()) {
      await setNewPickUpStation(startLocation, groupSize);
    }
    if (!StationManager().checkDropOffStationHasEmptyDocks(groupSize) &&
        !StationManager().passedDropOffStation()) {
      await setNewDropOffStation(endLocation, groupSize);
    }
  }

  Future<Station> setNewPickUpStation(Location location,
      [int groupSize = 1]) async {
    return await StationManager()
        .getPickupStationNear(LatLng(location.lat, location.lng), groupSize);
  }

  Future<Station> setNewDropOffStation(Location location,
      [int groupSize = 1]) async {
    return await StationManager()
        .getDropoffStationNear(LatLng(location.lat, location.lng), groupSize);
  }

  Future<void> setInitialPickUpDropOffStations() async {
    setNewPickUpStation(RouteManager().getStart().getStop().geometry.location,
        RouteManager().getGroupSize());
    setNewDropOffStation(
        RouteManager().getDestination().getStop().geometry.location,
        RouteManager().getGroupSize());
  }

  // TODO: Include in relevant places and clear up any left behidn variables
  void clear() {
    _isNavigating = false;
  }
}
