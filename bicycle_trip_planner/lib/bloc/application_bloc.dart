import 'dart:async';
import 'package:bicycle_trip_planner/managers/CameraManager.dart';
import 'package:bicycle_trip_planner/managers/DirectionManager.dart';
import 'package:bicycle_trip_planner/managers/LocationManager.dart';
import 'package:bicycle_trip_planner/managers/MarkerManager.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/managers/StationManager.dart';
import 'package:bicycle_trip_planner/models/location.dart';
import 'package:bicycle_trip_planner/widgets/home/HomeWidgets.dart';
import 'package:bicycle_trip_planner/widgets/navigation/Navigation.dart';
import 'package:bicycle_trip_planner/widgets/routeplanning/RoutePlanning.dart';
import 'package:flutter/material.dart';

import 'package:bicycle_trip_planner/models/station.dart';
import 'package:bicycle_trip_planner/models/route.dart' as Rou;
import 'package:bicycle_trip_planner/models/place.dart';
import 'package:bicycle_trip_planner/models/place_search.dart';
import 'package:bicycle_trip_planner/services/directions_service.dart';
import 'package:bicycle_trip_planner/services/places_service.dart';
import 'package:bicycle_trip_planner/services/stations_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wakelock/wakelock.dart';

import '../managers/NavigationManager.dart';

class ApplicationBloc with ChangeNotifier {
  final _placesService = PlacesService();
  final _directionsService = DirectionsService();
  final _stationsService = StationsService();

  Widget selectedScreen = HomeWidgets();
  final screens = <String, Widget>{
    'home': HomeWidgets(),
    'navigation': Navigation(),
    'routePlanning': RoutePlanning(),
  };

  late List<PlaceSearch> searchResults = [];

  final StationManager _stationManager = StationManager();
  final MarkerManager _markerManager = MarkerManager();
  final DirectionManager _directionManager = DirectionManager();
  final RouteManager _routeManager = RouteManager();
  final LocationManager _locationManager = LocationManager();
  final CameraManager _cameraManager = CameraManager.instance;

  // TODO: Add calls to isNavigation from GUI
  bool _isNavigating = false;

  late Timer _stationTimer;
  late Place _currentLocation;

  ApplicationBloc() {
    fetchCurrentLocation();
    updateStationsPeriodically(Duration(seconds: 30));
  }

  cancelStationTimer() {
    _stationTimer.cancel();
  }

  updateStationsPeriodically(Duration duration) {
    _stationTimer = Timer.periodic(duration, (timer) {
      updateStations();
      filterStationMarkers();
      updateStationMarkers();
    });
  }

  setupStations() async {
    List<Station> stations = await _stationsService.getStations();
    _stationManager.setStations(stations);
    _markerManager.setStationMarkers(stations, this);

    updateStations();
    filterStationMarkers();
    updateStationMarkers();
    notifyListeners();
  }

  // fetchCurrentLocation() async {
  //   LatLng latLng = await _locationManager.locate();
  //   _currentLocation = await _placesService.getPlaceFromCoordinates(latLng.latitude, latLng.longitude);
  // }

  updateStations() async {
    await _stationManager.setStations(await _stationsService.getStations());
    notifyListeners();
  }

  updateStationMarkers() {
    // Does not update markers during navigation
    if (_directionManager.ifNavigating()) {
      return;
    }
    List<Station> newStations =
        _stationManager.getDeadStationsWhichNowHaveBikes();
    _markerManager.setStationMarkers(newStations, this);
    List<Station> deadStations = _stationManager.getStationsWithNoBikes();
    _markerManager.clearStationMarkers(deadStations);
    // Sets the new dead stations AFTER checking for previous dead stations that now have bikes
    _stationManager.setDeadStations(deadStations);

    notifyListeners();
  }

  filterStationMarkers() async{
    List<Station> notNearbyStations = await _stationManager.getFarStations();
    _markerManager.clearStationMarkers(notNearbyStations);
  }

  bool ifSearchResult() {
    return searchResults.isNotEmpty;
  }

  searchPlaces(String searchTerm) async {
    searchResults = await _placesService.getAutocomplete(searchTerm);
    searchResults.insert(
        0,
        PlaceSearch(
            description: "My current location",
            placeId: _currentLocation.placeId));
    notifyListeners();
  }

  getDefaultSearchResult() async {
    searchResults = [];
    searchResults.insert(
        0,
        PlaceSearch(
            description: "My current location",
            placeId: _currentLocation.placeId));
    notifyListeners();
  }

  searchSelectedStation(Station station) async {
    // Do not set new location marker. Use the station marker
    viewStationMarker(station, _routeManager.getStart().getUID());

    // TODO: Currently will always set station as a destination
    // TODO: Will break if search results can't find the right place
    // Use the google maps location name for stations (Santander Cycles: [station name])
    await searchPlaces("Santander Cycles: ${station.name}");
    setSelectedLocation(
        searchResults[1].description, _routeManager.getStart().getUID());
    notifyListeners();
  }

  fetchCurrentLocation() async {
    LatLng latLng = await _locationManager.locate();
    _currentLocation = await _placesService.getPlaceFromCoordinates(
        latLng.latitude, latLng.longitude);
    notifyListeners();
  }

  setSelectedCurrentLocation() async {
    LatLng latLng = await _locationManager.locate();
    Place place = await _placesService.getPlaceFromCoordinates(
        latLng.latitude, latLng.longitude);

    // Currently will always set station as a start
    setLocationMarker(place.placeId, _routeManager.getStart().getUID());
    setSelectedLocation(place.name, _routeManager.getStart().getUID());

    notifyListeners();
  }

  viewStationMarker(Station station, [int uid = -1]) {
    // Do this in case station marker is not on the map
    _markerManager.setStationMarkerWithUID(station, this, uid);
    _cameraManager.setCameraPosition(LatLng(station.lat, station.lng));
  }

  clearStationMarkersWithoutUID() {
    _markerManager.clearStationMarkers(_stationManager.getStations());
  }

  setStationMarkersWithoutUID() {
    _markerManager.setStationMarkers(_stationManager.getStations(), this);
  }

  setLocationMarker(String placeID, [int uid = -1]) async {
    Place selected = await _placesService.getPlace(placeID);
    _cameraManager.viewPlace(selected);
    _markerManager.setPlaceMarker(selected, uid);
    notifyListeners();
  }

  setSelectedLocation(String stop, int uid) {
    _routeManager.changeStop(uid, stop);
    notifyListeners();
  }

  clearLocationMarker(int uid) {
    _markerManager.clearMarker(uid);
    notifyListeners();
  }

  clearSelectedLocation(int uid) {
    _routeManager.clearStop(uid);
    notifyListeners();
  }

  removeSelectedLocation(int uid) {
    _routeManager.removeStop(uid);
    notifyListeners();
  }

  findRoute(String origin, String destination,
      [List<String> intermediates = const <String>[],
      int groupSize = 1]) async {
    Rou.Route route =
        await _directionsService.getRoutes(origin, destination, intermediates);

    Location startLocation =
        (await _placesService.getPlaceFromAddress(origin)).geometry.location;
    Location endLocation =
        (await _placesService.getPlaceFromAddress(destination))
            .geometry
            .location;

    Station startStation = _stationManager.getPickupStationNear(
        LatLng(startLocation.lat, startLocation.lng), groupSize);
    Station endStation = _stationManager.getDropoffStationNear(
        LatLng(endLocation.lat, endLocation.lng), groupSize);

    String startStationName = (await _placesService.getPlaceFromCoordinates(
            startStation.lat, startStation.lng))
        .name;
    String endStationName = (await _placesService.getPlaceFromCoordinates(
            endStation.lat, endStation.lng))
        .name;

    Rou.Route startWalkRoute =
        await _directionsService.getRoutes(origin, startStationName);
    Rou.Route bikeRoute = await _directionsService.getRoutes(startStationName,
        endStationName, intermediates, _routeManager.ifOptimised());
    Rou.Route endWalkRoute =
        await _directionsService.getRoutes(endStationName, destination);

    _directionManager.setRoutes(startWalkRoute, bikeRoute, endWalkRoute);
    notifyListeners();
  }

  void endRoute() {
    Wakelock.disable();
    _stationManager.clear();
    clearMap();
    setSelectedScreen('home');
    notifyListeners();
  }

  // ********** Screen Management **********

  Widget getSelectedScreen() {
    return selectedScreen;
  }

  void setSelectedScreen(String screenName) {
    selectedScreen = screens[screenName] ?? HomeWidgets();
    notifyListeners();
  }

  void goBack(String backTo) {
    clearMap();

    // this will also invoke notifyListeners()
    setSelectedScreen(backTo);
  }

  // ********** Navigation Management **********

  //TODO refactor whole navigation management block -- move to new file

  updateDirectionsPeriodically(Duration duration){
    Timer.periodic(duration, (timer) async {
      if(_isNavigating) {
        if (await checkWaypointPassed()) {
          //TODO implement what happens once destination reached
            endRoute();
            timer.cancel();
            setSelectedScreen('home');
          }
        if (RouteManager().getWalkToFirstWaypoint() && RouteManager().ifFirstWaypointSet()) {
          await _updateRouteWithWalking();
        }
        else {
          await _updateRoute();
        }
        notifyListeners();
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> startNavigation() async {
    await RouteManager().setDestinationLocation();
    if (RouteManager().getStartFromCurrentLocation()) {
      await NavigationManager().setInitialPickUpDropOffStations();
      updateDirectionsPeriodically(Duration(seconds: 20));
    }
    else {
      if (RouteManager().getWalkToFirstWaypoint()) {
        await NavigationManager().setInitialPickUpDropOffStations();
        String firstStop = RouteManager().getStart().getStop();
        RouteManager().addFirstWaypoint(firstStop);
        _updateRouteWithWalking();
        updateDirectionsPeriodically(Duration(seconds: 20));
      }
      else {
        String firstStop = RouteManager().getStart().getStop();
        RouteManager().addFirstWaypoint(firstStop);
        await _updateRoute();
        await NavigationManager().setInitialPickUpDropOffStations();
        updateDirectionsPeriodically(Duration(seconds: 20));
      }
    }
  }

  Future<void> setNavigating(bool value) async {
    _isNavigating = value;
    if (_isNavigating) {
      startNavigation();
    }
  }

  Future<void> _changeRouteStartToCurrentLocation() async {
    await fetchCurrentLocation();
    RouteManager().changeStart(_currentLocation.name);
  }

  Future<void> _updateRoute() async {
    await _changeRouteStartToCurrentLocation();
    checkPassedByPickUpDropOffStations();
    await NavigationManager().updateRoute(
        RouteManager().getStart().getStop(),
        RouteManager().getWaypoints().map((waypoint) => waypoint.getStop()).toList(),
        RouteManager().getGroupSize()
    );
    notifyListeners();
  }

  Future<void> _updateRouteWithWalking() async {
    await _changeRouteStartToCurrentLocation();
    checkPassedByPickUpDropOffStations();
    await NavigationManager().walkToFirstLocation(
        RouteManager().getStart().getStop(),
        RouteManager().getFirstWaypoint().getStop(),
        RouteManager().getWaypoints().sublist(1).map((waypoint) => waypoint.getStop()).toList(),
        RouteManager().getGroupSize()
    );
    notifyListeners();
  }
//
  bool isWaypointPassed(LatLng waypoint) {
    return (_locationManager.distanceFromToInMeters(_currentLocation.getLatLng(), waypoint) <= 30);
  }

  void passedStation(Station station, void Function(bool) functionA, void Function(bool) functionB) {
    if (_stationManager.isStationSet(station) && isWaypointPassed(LatLng(station.lat, station.lng))) {
      _stationManager.passedStation(station);
      _stationManager.clearStation(station);
      functionA(false);
      functionB(true);
    }
  }

  void checkPassedByPickUpDropOffStations() {
    Station startStation = _stationManager.getPickupStation();
    Station endStation = _stationManager.getDropOffStation();
    passedStation(startStation, RouteManager().setIfBeginning, RouteManager().setIfCycling);
    passedStation(endStation, RouteManager().setIfCycling, RouteManager().setIfEndWalking);
  }

   //remove waypoint once passed by it, return true if we reached the destination
  Future<bool> checkWaypointPassed() async {
    if (RouteManager().getWaypoints().isNotEmpty && isWaypointPassed((await _placesService.getPlaceFromAddress(RouteManager().getWaypoints().first.getStop())).getLatLng())) {
      RouteManager().removeStop(RouteManager().getWaypoints().first.getUID());
    }
    return (RouteManager().getStops().length <= 1);
    }

  // Clears selected route and directions
  void clearMap() {
    _routeManager.clear();
    _directionManager.clear();
  }
}
