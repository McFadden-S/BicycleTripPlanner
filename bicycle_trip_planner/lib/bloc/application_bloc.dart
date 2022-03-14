import 'dart:async';
import 'package:bicycle_trip_planner/managers/CameraManager.dart';
import 'package:bicycle_trip_planner/managers/DirectionManager.dart';
import 'package:bicycle_trip_planner/managers/LocationManager.dart';
import 'package:bicycle_trip_planner/managers/MarkerManager.dart';
import 'package:bicycle_trip_planner/managers/PolylineManager.dart';
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

  late Timer _stationTimer;
  late Place _currentLocation;

  ApplicationBloc() {
    fetchCurrentLocation();
    updateStationsPeriodically(Duration(seconds: 30));
  }

  cancelStationTimer(){
    _stationTimer.cancel();
  }

  updateStationsPeriodically(Duration duration) {
    _stationTimer = Timer.periodic(duration, (timer) {
      updateStations();
      updateStationMarkers();
    });
  }

  setupStations() async {
    List<Station> stations = await _stationsService.getStations();
    _stationManager.setStations(stations);
    _markerManager.setStationMarkers(stations, this);
    updateStations();
    updateStationMarkers();
    notifyListeners();
  }

  updateStations() async {
    await _stationManager.setStations(await _stationsService.getStations());
    notifyListeners();
  }

  updateStationMarkers() {
    List<Station> newStations =
        _stationManager.getDeadStationsWhichNowHaveBikes();
    //print("New stations $newStations");
    _markerManager.setStationMarkers(newStations, this);
    List<Station> deadStations = _stationManager.getStationsWithNoBikes();
    //print("Dead stations $deadStations");
    _markerManager.clearStationMarkers(deadStations);
    // Sets the new dead stations AFTER checking for previous dead stations that now have bikes
    _stationManager.setDeadStations(deadStations);
    notifyListeners();
  }

  bool ifSearchResult() {
    return searchResults.isNotEmpty;
  }

  searchPlaces(String searchTerm) async {
    searchResults = await _placesService.getAutocomplete(searchTerm);
    searchResults.insert(0, PlaceSearch(description: "My current location", placeId: _currentLocation.placeId));
    notifyListeners();
  }

  getDefaultSearchResult() async {
    searchResults = [];
    searchResults.insert(0, PlaceSearch(description: "My current location", placeId: _currentLocation.placeId));
    notifyListeners();
  }

  searchSelectedStation(Station station) async {
    Place place =
        await _placesService.getPlaceFromCoordinates(station.lat, station.lng);
    setLocationMarker(place.placeId, _routeManager.getStart().getUID());

    // TODO: Currently will always set station as a destination
    // Check if station.name and place.name is different (ideally should be placeSearch.description)
    setSelectedLocation(place.name, _routeManager.getStart().getUID());
    notifyListeners();
  }


  fetchCurrentLocation() async {
    LatLng latLng = await _locationManager.locate();
    _currentLocation = await _placesService.getPlaceFromCoordinates(latLng.latitude, latLng.longitude);
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

  Future<String> _getStationName(Station station) async{
    String stationName = (await _placesService.getPlaceFromCoordinates(station.lat, station.lng)).name;
    return stationName;
  }

  Future<int> _getDurationFromToStation(Station startStation, Station endStation) async{
    String startStationName = await _getStationName(startStation);
    String endStationName = await _getStationName(endStation);
    Rou.Route route = await _directionsService.getRoutes(startStationName, endStationName);
    int durationSeconds = _directionManager.getRouteDuration(route);
    int durationMinutes = (durationSeconds / 60).ceil();
    return durationMinutes;
  }

  double _costEfficiencyHeuristic(Station curStation, Station intermediaryStation, Station endStation) {
    double startHeuristic = _locationManager.distanceFromTo(LatLng(curStation.lat, curStation.lng), LatLng(intermediaryStation.lat, intermediaryStation.lng));
    double endHeuristic = _locationManager.distanceFromTo(LatLng(intermediaryStation.lat, intermediaryStation.lng), LatLng(endStation.lat, endStation.lng));
    return endHeuristic/startHeuristic;
  }

  findCostEfficientRoute(String origin, String destination,
      [int groupSize = 1]) async {

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

    String startStationName = await _getStationName(startStation);
    String endStationName = await _getStationName(endStation);

    Station curStation = startStation;

    List<String> intermediateStations = <String>[];

    while(curStation != endStation) {
      if (await _getDurationFromToStation(curStation, endStation) <= 25) {
        curStation = endStation;
      }
      else {
        List<Station> nearbyStations = _stationManager.getStationsInRadius(LatLng(curStation.lat, curStation.lng));
        nearbyStations.sort((stationA, stationB) => _costEfficiencyHeuristic(curStation, stationA, endStation)
            .compareTo(_costEfficiencyHeuristic(curStation, stationB, endStation)));
        for (int i = 0; i < nearbyStations.length; i++) {
          if (await _getDurationFromToStation(curStation, nearbyStations[i]) <= 25) {
            intermediateStations.add(await _getStationName(nearbyStations[i]));
            curStation = nearbyStations[i];
            setLocationMarker(await _getStationName(nearbyStations[i]), i + 77);
            break;
          }
        }
      }
    }

    Rou.Route route =
      await _directionsService.getRoutes(origin, destination, intermediateStations);

    Rou.Route startWalkRoute =
    await _directionsService.getRoutes(origin, startStationName);
    Rou.Route bikeRoute = await _directionsService.getRoutes(startStationName,
        endStationName, intermediateStations, _routeManager.ifOptimised());
    Rou.Route endWalkRoute =
    await _directionsService.getRoutes(endStationName, destination);

    _directionManager.setRoutes(startWalkRoute, bikeRoute, endWalkRoute);
    notifyListeners();
  }

  void endRoute() {
    Wakelock.disable();
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

  // Clears selected route and directions
  void clearMap(){
    _routeManager.clear();
    _directionManager.clear();
  }
}
