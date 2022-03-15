import 'dart:async';
import 'package:bicycle_trip_planner/managers/LocationManager.dart';
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

  final _locationManager = LocationManager();
  final _stationManager = StationManager();

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

  void start(Place currentLocation) async {
    _isNavigating = true;
    if (RouteManager().ifStartFromCurrentLocation()) {
      await setInitialPickUpDropOffStations();
    } else {
      if (RouteManager().ifWalkToFirstWaypoint()) {
        await setInitialPickUpDropOffStations();
        Place firstStop = RouteManager().getStart().getStop();
        RouteManager().addFirstWaypoint(firstStop);
        updateRouteWithWalking(currentLocation);
      } else {
        Place firstStop = RouteManager().getStart().getStop();
        RouteManager().addFirstWaypoint(firstStop);
        await _updateRoute(currentLocation);
        await setInitialPickUpDropOffStations();
      }
    }
  }

  Future<void> updateRoute(Place currentLocation) async {
    //TODO: Duplicated code here anbd below
    await _changeRouteStartToCurrentLocation(currentLocation);
    checkPassedByPickUpDropOffStations(currentLocation);
    await _updateRoute(
        RouteManager().getStart().getStop(),
        RouteManager()
            .getWaypoints()
            .map((waypoint) => waypoint.getStop())
            .toList(),
        RouteManager().getGroupSize());
  }

  Future<void> updateRouteWithWalking(Place currentLocation) async {
    await _changeRouteStartToCurrentLocation(currentLocation);
    checkPassedByPickUpDropOffStations(currentLocation);
    await walkToFirstLocation(
        RouteManager().getStart().getStop(),
        RouteManager().getFirstWaypoint().getStop(),
        RouteManager()
            .getWaypoints()
            .sublist(1)
            .map((waypoint) => waypoint.getStop())
            .toList(),
        RouteManager().getGroupSize());
  }

  Future<void> _changeRouteStartToCurrentLocation(Place currentLocation) async {
    RouteManager().changeStart(currentLocation);
  }

  bool isWaypointPassed(LatLng waypoint, Place currentLocation) {
    return (_locationManager.distanceFromToInMeters(
            currentLocation.getLatLng(), waypoint) <=
        30);
  }

  void passedStation(Station station, void Function(bool) functionA,
      void Function(bool) functionB, Place currentLocation) {
    if (_stationManager.isStationSet(station) &&
        isWaypointPassed(LatLng(station.lat, station.lng), currentLocation)) {
      _stationManager.passedStation(station);
      _stationManager.clearStation(station);
      functionA(false);
      functionB(true);
    }
  }

  void checkPassedByPickUpDropOffStations(Place currentLocation) {
    Station startStation = _stationManager.getPickupStation();
    Station endStation = _stationManager.getDropOffStation();
    passedStation(startStation, RouteManager().setIfBeginning,
        RouteManager().setIfCycling, currentLocation);
    passedStation(endStation, RouteManager().setIfCycling,
        RouteManager().setIfEndWalking, currentLocation);
  }

  //remove waypoint once passed by it, return true if we reached the destination
  Future<bool> checkWaypointPassed(Place currentLocation) async {
    if (RouteManager().getWaypoints().isNotEmpty &&
        isWaypointPassed(
            RouteManager().getWaypoints().first.getStop().getLatLng(),
            currentLocation)) {
      RouteManager().removeStop(RouteManager().getWaypoints().first.getUID());
    }
    return (RouteManager().getStops().length <= 1);
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
  _updateRoute(Place origin,
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

  //TODO: Move pick up and drop off station variables in stationManager here...

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
