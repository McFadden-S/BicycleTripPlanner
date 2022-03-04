import 'dart:async';
import 'dart:collection';
import 'package:bicycle_trip_planner/managers/CameraManager.dart';
import 'package:bicycle_trip_planner/managers/DirectionManager.dart';
import 'package:bicycle_trip_planner/managers/LocationManager.dart';
import 'package:bicycle_trip_planner/managers/MarkerManager.dart';
import 'package:bicycle_trip_planner/managers/PolylineManager.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/managers/StationManager.dart';
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

  late List<PlaceSearch> searchResults = [];

  final StationManager _stationManager = StationManager();
  final MarkerManager _markerManager = MarkerManager();
  final PolylineManager _polylineManager = PolylineManager();
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

  updateStationsPeriodically(Duration duration){
    _stationTimer = Timer.periodic(duration, (timer){
      updateStations();
    });
  }

  /*updateCurrentLocationPeriodically(Duration duration) {
    Timer.periodic(duration, (timer){
      _currentLocation = fetchCurrentLocation();
    });
  }*/

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
    //searchResults.insert(0, PlaceSearch(description: _currentLocation.name, placeId: _currentLocation.placeId));
    searchResults.add(PlaceSearch(description: _currentLocation.name, placeId: _currentLocation.placeId));
    notifyListeners();
  }

  searchSelectedStation(Station station) async {
    Place place = await _placesService.getPlaceFromCoordinates(station.lat, station.lng);
    setSelectedLocation(place.placeId, place.name, SearchType.start);

    notifyListeners();
  }

  fetchCurrentLocation() async {
    LatLng latLng = await _locationManager.locate();
    _currentLocation = await _placesService.getPlaceFromCoordinates(latLng.latitude, latLng.longitude);
    searchResults.add(PlaceSearch(description: _currentLocation.name, placeId: _currentLocation.placeId));
    notifyListeners();
  }

  setSelectedCurrentLocation(SearchType searchType) async {
    setSelectedLocation(_currentLocation.placeId, _currentLocation.name, searchType);

    notifyListeners();
  }

  setSelectedLocation(String placeId, String placeDescription, SearchType searchType, [int intermediateIndex = 0]) async {
    Place selected = await _placesService.getPlace(placeId);

    _cameraManager.viewPlace(selected);
    _markerManager.setPlaceMarker(selected, searchType, intermediateIndex);

    switch (searchType){
      case SearchType.start:
        _routeManager.setStart(placeDescription);
        break;
      case SearchType.end:
        _routeManager.setDestination(placeDescription);
        break;
      case SearchType.intermediate:
        _routeManager.setIntermediate(placeDescription, intermediateIndex);
        break;
    }

    searchResults.clear();
    notifyListeners();
  }

  clearSelectedLocation(SearchType searchType, [int intermediateIndex = 0]){
    _markerManager.clearMarker(searchType, intermediateIndex);

    switch (searchType){
      case SearchType.start:
        _routeManager.clearStart();
        break;
      case SearchType.end:
        _routeManager.clearDestination();
        break;
      case SearchType.intermediate:
        _routeManager.removeIntermediate(intermediateIndex);
        break;
    }

    notifyListeners();
  }

  findRoute(String origin, String destination, [List<String> intermediates = const <String>[]]) async {
    Rou.Route route = await _directionsService.getRoutes(origin, destination, intermediates);

    _cameraManager.goToPlace(
        route.legs.first.startLocation.lat,
        route.legs.first.startLocation.lng,
        route.bounds.northeast,
        route.bounds.southwest);

    _polylineManager.setPolyline(route.polyline.points);

    _directionManager.setRoute(route);
    notifyListeners();
  }

  void endRoute(){
    _routeManager.endRoute();
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
