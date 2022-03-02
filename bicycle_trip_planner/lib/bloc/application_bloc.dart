import 'dart:async';
import 'dart:collection';
import 'package:bicycle_trip_planner/managers/CameraManager.dart';
import 'package:bicycle_trip_planner/managers/DirectionManager.dart';
import 'package:bicycle_trip_planner/managers/LocationManager.dart';
import 'package:bicycle_trip_planner/managers/MarkerManager.dart';
import 'package:bicycle_trip_planner/managers/PolylineManager.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/managers/StationManager.dart';
import 'package:bicycle_trip_planner/models/location.dart';
import 'package:bicycle_trip_planner/models/search_types.dart';
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

  Queue<String> prevScreens = Queue();
  Widget selectedScreen = HomeWidgets();
  final screens = <String, Widget>{
    'home': HomeWidgets(),
    'navigation': Navigation(),
    'routePlanning': RoutePlanning(),
  };

  List<PlaceSearch> searchResults = [];

  final StationManager _stationManager = StationManager();
  final MarkerManager _markerManager = MarkerManager();
  final PolylineManager _polylineManager = PolylineManager();
  final DirectionManager _directionManager = DirectionManager();
  final RouteManager _routeManager = RouteManager();
  final LocationManager _locationManager = LocationManager();
  final CameraManager _cameraManager = CameraManager.instance;

  late Timer _stationTimer;

  cancelStationTimer(){
    _stationTimer.cancel();
  }

  updateStationsPeriodically(Duration duration){
    _stationTimer = Timer.periodic(duration, (timer){
      updateStations();
    });
  }

  setupStations() async{
    List<Station> stations = await _stationsService.getStations();
    _stationManager.setStations(stations);
    _markerManager.setStationMarkers(stations, this);
    updateStations();
    notifyListeners();
  }

  updateStations() async {
    await _stationManager.setStations(await _stationsService.getStations());
    notifyListeners();
  }

  bool ifSearchResult(){
    return searchResults.isNotEmpty;
  }

  searchPlaces(String searchTerm) async {
    searchResults = await _placesService.getAutocomplete(searchTerm);
    notifyListeners();
  }

  searchSelectedStation(Station station) async {
    Place place = await _placesService.getPlaceFromCoordinates(station.lat, station.lng);
    setLocationMarker(place.placeId);
    // Currently will always set station as a destination
    // Check if station.name and place.name is different (ideally should be placeSearch.description)
    print(station.name);
    print(place.name);
    setSelectedLocation(place.name, _routeManager.getStart().getUID());
    notifyListeners();
  }

  setSelectedCurrentLocation() async {
    LatLng latLng = await _locationManager.locate();
    Place place = await _placesService.getPlaceFromCoordinates(latLng.latitude, latLng.longitude);
     // Currently will always set station as a start
    setLocationMarker(place.placeId);
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

  clearSelectedLocation(int uid){
    _routeManager.clearStop(uid);
    notifyListeners();
  }

  removeSelectedLocation(int uid){
    _routeManager.removeStop(uid);
    notifyListeners();
  }

  findRoute(String origin, String destination, [List<String> intermediates = const <String>[], int groupSize = 1]) async {
    Rou.Route route = await _directionsService.getRoutes(origin, destination, intermediates);

    Location startLocation = (await _placesService.getPlaceFromAddress(origin)).geometry.location;
    Location endLocation = (await _placesService.getPlaceFromAddress(destination)).geometry.location;

    Station startStation = _stationManager.getPickupStationNear(LatLng(startLocation.lat, startLocation.lng), groupSize);
    Station endStation = _stationManager.getDropoffStationNear(LatLng(endLocation.lat, endLocation.lng), groupSize);

    String startStationName = (await _placesService.getPlaceFromCoordinates(startStation.lat, startStation.lng)).name;
    String endStationName = (await _placesService.getPlaceFromCoordinates(endStation.lat, endStation.lng)).name;

    Rou.Route startWalkRoute = await _directionsService.getRoutes(origin, startStationName);
    Rou.Route bikeRoute = await _directionsService.getRoutes(startStationName, endStationName, intermediates, _routeManager.ifOptimised());
    Rou.Route endWalkRoute = await _directionsService.getRoutes(endStationName, destination);

    _directionManager.setRoutes(startWalkRoute, bikeRoute, endWalkRoute);
    notifyListeners();
  }

  void endRoute(){
    Wakelock.disable();
    selectedScreen = screens['home']!;
    _routeManager.endRoute();
    _directionManager.clear();
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

  void pushPrevScreen(String screenName) {
    prevScreens.addFirst(screenName);
  }

  void goBack() {
    if(prevScreens.isNotEmpty){
      endRoute();
      selectedScreen = screens[prevScreens.removeFirst()]!;
      notifyListeners();
    }
  }
}
