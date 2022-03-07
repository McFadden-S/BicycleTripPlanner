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
    _stationManager.clearDropOffStation();
    _stationManager.clearPickUpStation();
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

  //TODO refactor whole navigation management block
  //TODO check with more waypoints

  updateDirectionsPeriodically(Duration duration){
    Timer.periodic(duration, (timer) async {
      if(_isNavigating) {
        if (await checkWaypointPassed()) {
            endRoute();
            timer.cancel();
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

  Future<void> setNavigating(bool value) async {
    _isNavigating = value;
    if (value && RouteManager().getStartFromCurrentLocation()) {
      await setInitialPickUpDropOffStations();
      updateDirectionsPeriodically(Duration(seconds: 20));
    }
    else if(value) {
      if (RouteManager().getWalkToFirstWaypoint()) {
        await setInitialPickUpDropOffStations();
        String firstStop = RouteManager().getStart().getStop();
        RouteManager().addFirstWaypoint(firstStop);
        //TODO implement walk to first waypoint
        _updateRouteWithWalking();
        updateDirectionsPeriodically(Duration(seconds: 20));
      }
      else {
        //await setInitialPickUpDropOffStations();
        String firstStop = RouteManager().getStart().getStop();
        RouteManager().addFirstWaypoint(firstStop);
        await _updateRoute();
        //TODO: stop zoom in/out each time map gets reloaded
        updateDirectionsPeriodically(Duration(seconds: 20));
      }
    }
  }

  Future<void> _changeRouteStartToCurrentLocation() async {
    await fetchCurrentLocation();
    RouteManager().changeStart(_currentLocation.name);
  }

  Future<void> _updateRoute() async {
    await _changeRouteStartToCurrentLocation();
    await updateRoute(
        RouteManager().getStart().getStop(),
        RouteManager().getDestination().getStop(),
        RouteManager().getWaypointsWithFirstWaypoint().map((waypoint) => waypoint.getStop()).toList(),
        RouteManager().getGroupSize()
    );
  }

  Future<void> _updateRouteWithWalking() async {
    await _changeRouteStartToCurrentLocation();
    await walkToFirstLocation(
        RouteManager().getStart().getStop(),
        RouteManager().getDestination().getStop(),
        RouteManager().getFirstWaypoint().getStop(),
        RouteManager().getWaypoints().map((waypoint) => waypoint.getStop()).toList(),
        RouteManager().getGroupSize()
    );
  }

  bool isWaypointPassed(LatLng waypoint) {
    return (_locationManager.distanceFromToInMeters(_currentLocation.getLatLng(), waypoint) <= 10);
  }

  walkToFirstLocation(String origin, String destination, String first, [List<String> intermediates = const <String>[], int groupSize = 1]) async {
    Location firstLocation = (await _placesService.getPlaceFromAddress(first)).geometry.location;
    Location endLocation = (await _placesService.getPlaceFromAddress(destination)).geometry.location;

    setNewPickUpStation(firstLocation, groupSize);
    setNewDropOffStation(endLocation, groupSize);
    Station startStation = _stationManager.getPickupStation();
    Station endStation = _stationManager.getDropOffStation();

    String startStationName = await getStationPlaceName(startStation);
    String endStationName = await getStationPlaceName(endStation);

    Rou.Route startWalkRoute;
    Rou.Route bikeRoute;
    Rou.Route endWalkRoute;
    //TODO: once removes station it will skip this if statement and go back to original route with errors
    //TODO: make 3 methods each for different stage of route and switch between them instead
    if (_stationManager.getPickupStation().name != "" && isWaypointPassed(LatLng(startStation.lat, startStation.lng))) {
      _stationManager.clearPickUpStation();
      startWalkRoute = Rou.Route.routeNotFound();
      bikeRoute = await _directionsService.getRoutes(_currentLocation.name, endStationName, intermediates, true);
      endWalkRoute = await _directionsService.getRoutes(endStationName, destination);
    }
    else if (_stationManager.getDropOffStation().name != "" && isWaypointPassed(LatLng(endStation.lat, endStation.lng))) {
      _stationManager.clearDropOffStation();
      startWalkRoute = Rou.Route.routeNotFound();
      bikeRoute = Rou.Route.routeNotFound();
      endWalkRoute = await _directionsService.getRoutes(_currentLocation.name, destination);
    }
    else {
      startWalkRoute = await _directionsService.getWalkingRoutes(origin, startStationName, [first], false);
      bikeRoute = await _directionsService.getRoutes(startStationName, endStationName, intermediates, true);
      endWalkRoute = await _directionsService.getWalkingRoutes(endStationName, destination);
    }

    setNewRoute(startWalkRoute, bikeRoute, endWalkRoute);
  }


  updateRoute(String origin, String destination, [List<String> intermediates = const <String>[], int groupSize = 1]) async {
    Location startLocation = (await _placesService.getPlaceFromAddress(origin)).geometry.location;
    Location endLocation = (await _placesService.getPlaceFromAddress(destination)).geometry.location;

    setNewPickUpStation(startLocation, groupSize);
    setNewDropOffStation(endLocation, groupSize);
    Station startStation = _stationManager.getPickupStation();
    Station endStation = _stationManager.getDropOffStation();

    String startStationName = await getStationPlaceName(startStation);
    String endStationName = await getStationPlaceName(endStation);

    Rou.Route startWalkRoute;
    Rou.Route bikeRoute;
    Rou.Route endWalkRoute;
    if (_stationManager.getPickupStation().name != "" && isWaypointPassed(LatLng(startStation.lat, startStation.lng))) {
      _stationManager.clearPickUpStation();
      startWalkRoute = Rou.Route.routeNotFound();
      if (RouteManager().ifFirstWaypointSet()) {
        bikeRoute = await _directionsService.getRoutes(_currentLocation.name, endStationName, [RouteManager().getFirstWaypoint().getStop()] + intermediates, true);
      }
      else {
        bikeRoute = await _directionsService.getRoutes(_currentLocation.name, endStationName, intermediates, true);
      }
      endWalkRoute = await _directionsService.getWalkingRoutes(endStationName, destination);
    }
    else if (_stationManager.getDropOffStation().name != "" && isWaypointPassed(LatLng(endStation.lat, endStation.lng))) {
      _stationManager.clearDropOffStation();
      startWalkRoute = Rou.Route.routeNotFound();
      bikeRoute = Rou.Route.routeNotFound();
      endWalkRoute = await _directionsService.getRoutes(_currentLocation.name, destination);
    }
    else {
      startWalkRoute = await _directionsService.getRoutes(origin, startStationName);
      //if (RouteManager().ifFirstWaypointSet()) {
      //  bikeRoute = await _directionsService.getRoutes(startStationName, endStationName, intermediates, true);
      //}
      //else {
        bikeRoute = await _directionsService.getRoutes(startStationName, endStationName, intermediates, true);
      //}
      endWalkRoute = await _directionsService.getRoutes(endStationName, destination);
    }

    setNewRoute(startWalkRoute, bikeRoute, endWalkRoute);
  }

  setNewRoute(Rou.Route startWalkRoute, Rou.Route bikeRoute, Rou.Route endWalkRoute) {
    _directionManager.setRoutes(startWalkRoute, bikeRoute, endWalkRoute, false);
    notifyListeners();
  }

  void setPartialRoutes() {
    //TODO implement easier way to set routes
  }

  Station setNewPickUpStation(Location location, [int groupSize = 1]) {
    return _stationManager.getPickupStationNear(LatLng(location.lat, location.lng), groupSize);
  }

  Station setNewDropOffStation(Location location, [int groupSize = 1]) {
    return _stationManager.getDropoffStationNear(LatLng(location.lat, location.lng), groupSize);
  }

  Future<String> getStationPlaceName(Station station) async {
    return (await _placesService.getPlaceFromCoordinates(station.lat, station.lng)).name;
  }

  Future<void> setInitialPickUpDropOffStations() async {
    setNewPickUpStation((await _placesService.getPlaceFromAddress(RouteManager().getStart().getStop())).geometry.location, RouteManager().getGroupSize());
    setNewDropOffStation((await _placesService.getPlaceFromAddress(RouteManager().getDestination().getStop())).geometry.location, RouteManager().getGroupSize());
  }

  //remove waypoint once passed by it, return true if we reached the destination
  Future<bool> checkWaypointPassed() async {
    if (isWaypointPassed((await _placesService.getPlaceFromAddress(RouteManager().getWaypointsWithFirstWaypoint().first.getStop())).getLatLng())) {
      RouteManager().removeStop(RouteManager().getWaypointsWithFirstWaypoint().first.getUID());
    }
    return (RouteManager().getStops().length <= 1);
    }

  // Clears selected route and directions
  void clearMap() {
    _routeManager.clear();
    _directionManager.clear();
  }
}
