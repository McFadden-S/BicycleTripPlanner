import 'dart:async';
import 'package:bicycle_trip_planner/managers/CameraManager.dart';
import 'package:bicycle_trip_planner/managers/DialogManager.dart';
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
  final DialogManager _dialogManager = DialogManager();

  // TODO: Add calls to isNavigation from GUI
  bool _isNavigating = false;
  bool _isDestinationReached = true;

  late Timer _stationTimer;
  late Place _currentLocation;


  ApplicationBloc() {
    fetchCurrentLocation();
    updateStationsPeriodically(const Duration(seconds: 30));
  }

  // ********** Dialog **********

  void showBinaryDialog(){
    _dialogManager.showBinaryChoice();
    notifyListeners();
  }

  void showSelectedStationDialog(Station station){
    _dialogManager.setSelectedStation(station);
    _dialogManager.showSelectedStation();
    notifyListeners();
  }

  void clearBinaryDialog(){
    _dialogManager.clearBinaryChoice();
    notifyListeners();
  }

  void clearSelectedStationDialog(){
    _dialogManager.clearSelectedStation();
    notifyListeners();
  }

  // ********** Search **********

  bool ifSearchResult() {
    return searchResults.isNotEmpty;
  }

  searchPlaces(String searchTerm) async {
    searchResults = await _placesService.getAutocomplete(searchTerm);
    searchResults.insert(0,
        PlaceSearch(
            description: "My current location",
            placeId: _currentLocation.placeId));
    notifyListeners();
  }

  getDefaultSearchResult() async {
    searchResults = [];
    searchResults.insert(0,
        PlaceSearch(
            description: "My current location",
            placeId: _currentLocation.placeId));
    notifyListeners();
  }

  searchSelectedStation(Station station, int uid) async {
    // Do not set new location marker. Use the station marker
    viewStationMarker(station, uid);

    if(station.place == const Place.placeNotFound()){
      Place place = await _placesService.getPlaceFromCoordinates(station.lat, station.lng, "Santander Cycles: ${station.name}");
      station.place = place;
    }

    setSelectedLocation(station.place, uid);

    notifyListeners();
  }

  fetchCurrentLocation() async {
    LatLng latLng = await _locationManager.locate();
    _currentLocation = await _placesService.getPlaceFromCoordinates(
        latLng.latitude, latLng.longitude, "My current location");
    notifyListeners();
  }

  setSelectedCurrentLocation() async {
    await fetchCurrentLocation();

    // Currently will always set station as a start
    setLocationMarker(_currentLocation, _routeManager.getStart().getUID());
    setSelectedLocation(_currentLocation, _routeManager.getStart().getUID());

    notifyListeners();
  }

  setSelectedSearch(int searchIndex, int uid) async{
    Place place = await _placesService.getPlace(searchResults[searchIndex].placeId, searchResults[searchIndex].description);
    setLocationMarker(place, uid);
    if(uid != -1){
      setSelectedLocation(place, uid);
    }
  }

  setLocationMarker(Place place, [int uid = -1]) async {
    _cameraManager.viewPlace(place);
    _markerManager.setPlaceMarker(place, uid);
    notifyListeners();
  }

  setSelectedLocation(Place stop, int uid) {
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

  // ********** Routes **********

  findRoute(Place origin, Place destination, [List<Place> intermediates = const <Place>[], int groupSize = 1]) async {

    Location startLocation = origin.geometry.location;
    Location endLocation = destination.geometry.location;

    Station startStation = await _stationManager.getPickupStationNear(
        LatLng(startLocation.lat, startLocation.lng), groupSize);
    Station endStation = await _stationManager.getDropoffStationNear(
        LatLng(endLocation.lat, endLocation.lng), groupSize);

    List<String> intermediateNames = intermediates.map((place) => place.name).toList();

    Rou.Route startWalkRoute = await _directionsService.getWalkingRoutes(origin.name, startStation.place.name);
    Rou.Route bikeRoute = await _directionsService.getRoutes(startStation.place.name,
        endStation.place.name, intermediateNames, _routeManager.ifOptimised());
    Rou.Route endWalkRoute = await _directionsService.getWalkingRoutes(endStation.place.name, destination.name);

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

  bool getIsDestinationReached() { return _isDestinationReached; }

  // ********** Stations **********

  cancelStationTimer() {
    _stationTimer.cancel();
  }

  updateStationsPeriodically(Duration duration) {
    _stationTimer = Timer.periodic(duration, (timer) {
      updateStations();
      filterStationMarkers();
    });
  }

  setupStations() async {
    await updateStations();
    filterStationMarkers();
    notifyListeners();
  }

  updateStations() async {
    await _stationManager.setStations(await _stationsService.getStations());
    notifyListeners();
  }

  List<Station> filterNearbyStations() {
    List<Station> notNearbyStations = _stationManager.getFarStations();
    List<Station> nearbyStations = _stationManager.getNearStations();
    _markerManager.setStationMarkers(nearbyStations, this);
    _markerManager.clearStationMarkers(notNearbyStations);
    return nearbyStations;
  }

  filterStationsWithBikes(List<Station> filteredStations) {
    List<Station> stationsWithBikes =
    _stationManager.getStationsWithAtLeastXBikes(1, filteredStations);
    _markerManager.setStationMarkers(stationsWithBikes, this);
    List<Station> bikelessStations =
    _stationManager.getStationsWithNoBikes(filteredStations);
    _markerManager.clearStationMarkers(bikelessStations);
  }

  void filterStationMarkers() {
    if (_directionManager.ifNavigating()) {
      return;
    }
    List<Station> nearbyStations = filterNearbyStations();
    filterStationsWithBikes(nearbyStations);
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

  updateDirectionsPeriodically(Duration duration){
    Timer.periodic(duration, (timer) async {
      if(_isNavigating) {
        if (await checkWaypointPassed()) {
          //TODO implement what happens once destination reached
            _isDestinationReached = true;
            endRoute();
            //_isDestinationReached = false;
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
        _isDestinationReached = true;
        timer.cancel();
        //_isDestinationReached = false;
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
        Place firstStop = RouteManager().getStart().getStop();
        RouteManager().addFirstWaypoint(firstStop);
        _updateRouteWithWalking();
        updateDirectionsPeriodically(Duration(seconds: 20));
      }
      else {
        Place firstStop = RouteManager().getStart().getStop();
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
    RouteManager().changeStart(_currentLocation);
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
    if (RouteManager().getWaypoints().isNotEmpty && isWaypointPassed(RouteManager().getWaypoints().first.getStop().getLatLng())) {
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
