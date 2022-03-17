import 'dart:async';
import 'package:bicycle_trip_planner/managers/CameraManager.dart';
import 'package:bicycle_trip_planner/managers/DialogManager.dart';
import 'package:bicycle_trip_planner/managers/DirectionManager.dart';
import 'package:bicycle_trip_planner/managers/LocationManager.dart';
import 'package:bicycle_trip_planner/managers/MarkerManager.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/managers/StationManager.dart';
import 'package:bicycle_trip_planner/models/location.dart' as Loc;
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
import 'package:location/location.dart';
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
  final NavigationManager _navigationManager = NavigationManager();

  // TODO: Add calls to isNavigation from GUI

  late Timer _stationTimer;
  late StreamSubscription<LocationData> _navigationSubscription;

  // TODO: CurrentLocation should be in LocationManager
  //late Place _currentLocation;

  ApplicationBloc() {
    fetchCurrentLocation();
    updateStationsPeriodically(const Duration(seconds: 30));
  }

  // ********** Dialog **********

  void showBinaryDialog() {
    _dialogManager.showBinaryChoice();
    notifyListeners();
  }

  void showSelectedStationDialog(Station station) {
    _dialogManager.setSelectedStation(station);
    _dialogManager.showSelectedStation();
    notifyListeners();
  }

  void clearBinaryDialog() {
    _dialogManager.clearBinaryChoice();
    notifyListeners();
  }

  void clearSelectedStationDialog() {
    _dialogManager.clearSelectedStation();
    notifyListeners();
  }

  // ********** Search **********

  bool ifSearchResult() {
    return searchResults.isNotEmpty;
  }

  searchPlaces(String searchTerm) async {
    searchResults = await _placesService.getAutocomplete(searchTerm);
    searchResults.insert(
        0,
        PlaceSearch(
            description: SearchType.current.description,
            placeId: _locationManager.getCurrentLocation().placeId));
    notifyListeners();
  }

  getDefaultSearchResult() async {
    searchResults = [];
    searchResults.insert(
        0,
        PlaceSearch(
            description: SearchType.current.description,
            placeId: _locationManager.getCurrentLocation().placeId));
    notifyListeners();
  }

  searchSelectedStation(Station station, int uid) async {
    // Do not set new location marker. Use the station marker
    viewStationMarker(station, uid);

    if (station.place == const Place.placeNotFound()) {
      Place place = await _placesService.getPlaceFromCoordinates(
          station.lat, station.lng, "Santander Cycles: ${station.name}");
      station.place = place;
    }

    setSelectedLocation(station.place, uid);

    notifyListeners();
  }

  updateLocationLive() {
    _navigationSubscription = _locationManager
        .onUserLocationChange(5)
        .listen((LocationData currentLocation) {
      // Print this if you suspect that data is loading more than expected
      //print("I loaded!");
      CameraManager.instance.viewUser();
      _updateDirections();
    });
  }

  fetchCurrentLocation() async {
    LatLng latLng = await _locationManager.locate();
    Place currentPlace = await _placesService.getPlaceFromCoordinates(
        latLng.latitude, latLng.longitude, SearchType.current.description);
    _locationManager.setCurrentLocation(currentPlace);
    notifyListeners();
  }

  setSelectedCurrentLocation() async {
    await fetchCurrentLocation();

    setLocationMarker(_locationManager.getCurrentLocation(),
        _routeManager.getStart().getUID());
    setSelectedLocation(_locationManager.getCurrentLocation(),
        _routeManager.getStart().getUID());

    notifyListeners();
  }

  setSelectedSearch(int searchIndex, int uid) async {
    Place place = await _placesService.getPlace(
        searchResults[searchIndex].placeId,
        searchResults[searchIndex].description);
    setLocationMarker(place, uid);
    if (uid != -1) {
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

  findRoute(Place origin, Place destination,
      [List<Place> intermediates = const <Place>[], int groupSize = 1]) async {
    Loc.Location startLocation = origin.geometry.location;
    Loc.Location endLocation = destination.geometry.location;

    Station startStation = await _stationManager.getPickupStationNear(
        LatLng(startLocation.lat, startLocation.lng), groupSize);
    Station endStation = await _stationManager.getDropoffStationNear(
        LatLng(endLocation.lat, endLocation.lng), groupSize);

    List<String> intermediatePlaceId =
        intermediates.map((place) => place.placeId).toList();

    Rou.Route startWalkRoute = await _directionsService.getWalkingRoutes(
        origin.placeId, startStation.place.placeId);
    Rou.Route bikeRoute = await _directionsService.getRoutes(
        startStation.place.placeId,
        endStation.place.placeId,
        intermediatePlaceId,
        _routeManager.ifOptimised());
    Rou.Route endWalkRoute = await _directionsService.getWalkingRoutes(
        endStation.place.placeId, destination.placeId);

    _directionManager.setRoutes(startWalkRoute, bikeRoute, endWalkRoute);
    notifyListeners();
  }

  void endRoute() {
    _navigationSubscription.cancel();
    Wakelock.disable();
    _navigationManager.clear();
    clearMap();
    setSelectedScreen('home');
    notifyListeners();
  }

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
    if (_navigationManager.ifNavigating()) {
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

  Future<void> startNavigation() async {
    await fetchCurrentLocation();
    setSelectedScreen('navigation');
    await _navigationManager.start();
    _updateDirections();
    updateLocationLive();
    _directionManager.showStartRoute();
    Wakelock.enable();
    notifyListeners();
  }

  _updateDirections() async {
    // End subscription if not navigating?
    if (!_navigationManager.ifNavigating()) return;

    await fetchCurrentLocation();
    if (await _navigationManager.checkWaypointPassed()) {
      endRoute();
      return;
    }

    if (_routeManager.ifWalkToFirstWaypoint() &&
        _routeManager.ifFirstWaypointSet()) {
      await _navigationManager.updateRouteWithWalking();
    } else {
      await _navigationManager.updateRoute();
    }
  }

  void toggleCycling() {
    _directionManager.toggleCycling();
    print("Notifying listeners");
    notifyListeners();
  }

  // Clears selected route and directions
  void clearMap() {
    _routeManager.clear();
    _directionManager.clear();
  }
}
