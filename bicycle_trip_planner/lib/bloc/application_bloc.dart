import 'dart:async';
import 'package:bicycle_trip_planner/managers/CameraManager.dart';
import 'package:bicycle_trip_planner/managers/DatabaseManager.dart';
import 'package:bicycle_trip_planner/managers/DialogManager.dart';
import 'package:bicycle_trip_planner/managers/DirectionManager.dart';
import 'package:bicycle_trip_planner/managers/LocationManager.dart';
import 'package:bicycle_trip_planner/managers/MarkerManager.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/managers/StationManager.dart';
import 'package:bicycle_trip_planner/managers/UserSettings.dart';
import 'package:bicycle_trip_planner/models/distance_types.dart';
import 'package:bicycle_trip_planner/models/location.dart' as Loc;
import 'package:bicycle_trip_planner/models/search_types.dart';
import 'package:bicycle_trip_planner/widgets/home/HomeWidgets.dart';
import 'package:bicycle_trip_planner/widgets/navigation/Navigation.dart';
import 'package:bicycle_trip_planner/widgets/routeplanning/RoutePlanning.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  var _placesService = PlacesService();
  var _directionsService = DirectionsService();
  var _stationsService = StationsService();

  Widget selectedScreen = HomeWidgets();
  final screens = <String, Widget>{
    'home': HomeWidgets(),
    'navigation': Navigation(),
    'routePlanning': RoutePlanning(),
  };

  late List<PlaceSearch> searchResults = [];

  StationManager _stationManager = StationManager();
  MarkerManager _markerManager = MarkerManager();
  DirectionManager _directionManager = DirectionManager();
  RouteManager _routeManager = RouteManager();
  LocationManager _locationManager = LocationManager();
  CameraManager _cameraManager = CameraManager.instance;
  DialogManager _dialogManager = DialogManager();
  NavigationManager _navigationManager = NavigationManager();
  late DatabaseManager _databaseManager;
  UserSettings _userSettings = UserSettings();

  late Timer _stationTimer;
  late StreamSubscription<LocationData> _navigationSubscription;

  ApplicationBloc() {
    changeUnits();
    fetchCurrentLocation();
    updateStationsPeriodically();
    _databaseManager = DatabaseManager();
  }

  @visibleForTesting
  ApplicationBloc.forMock(DialogManager dialogManager, PlacesService placesService, LocationManager locationManager, UserSettings userSettings, CameraManager cameraManager, MarkerManager markerManager, RouteManager routeManager,NavigationManager navigationManager, DirectionsService directionsService, StationManager stationManager, StationsService stationsService, DirectionManager directionManager, DatabaseManager databaseManager){
    _dialogManager = dialogManager;
    _placesService = placesService;
    _locationManager = locationManager;
    _userSettings = userSettings;
    _cameraManager = cameraManager;
    _markerManager = markerManager;
    _routeManager = routeManager;
    _navigationManager = navigationManager;
    _directionsService = directionsService;
    _stationManager = stationManager;
    _stationsService = stationsService;
    _directionManager = directionManager;
    _databaseManager = databaseManager;
  }

  @visibleForTesting
  ApplicationBloc.forNavigationMock(
      LocationManager locationManager,
      PlacesService placesService,
      RouteManager routeManager,
      NavigationManager navigationManager,
      DirectionsService directionsService,
      StationManager stationManager,
      CameraManager cameraManager) {
    _locationManager = locationManager;
    _placesService = placesService;
    _routeManager = routeManager;
    _navigationManager = navigationManager;
    _directionsService = directionsService;
    _stationManager = stationManager;
    _cameraManager = cameraManager;

    changeUnits();
    fetchCurrentLocation();
    updateStationsPeriodically();
  }



  // ********** Group Size **********

  Future<void> updateGroupSize(int groupSize) async {
    _routeManager.setGroupSize(groupSize);
    await filterStationMarkers();
    notifyListeners();
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

  @visibleForTesting
  List<PlaceSearch> getSearchResult(){
    return searchResults;
  }

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

    var recentSearches = await _userSettings.getPlace();

    // reverse list to view most recent searches
    var placeIds = recentSearches.keys.toList().reversed.toList();
    var names = recentSearches.values.toList().reversed.toList();

    int noRecentSearches = names.length;

    // Insert recent searches as suggestions in recent results drop down
    if (noRecentSearches > 0) {
      for (int i = 0; i < names.length; i++) {
        searchResults.insert(
            i + 1, PlaceSearch(description: names[i], placeId: placeIds[i]));
      }
    } else {
      // max of 6 recent searches in the drop down
      for (int i = 0; i < 5; i++) {
        searchResults.insert(
            i + 1, PlaceSearch(description: names[i], placeId: placeIds[i]));
      }
    }
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

  setSelectedSearch(int searchIndex, int uid) async {
    Place place = await _placesService.getPlace(
        searchResults[searchIndex].placeId,
        searchResults[searchIndex].description);
    setLocationMarker(place, uid);

    _userSettings.savePlace(place);

    if (uid != -1) {
      setSelectedLocation(place, uid);
    }
  }

  // ********** Location **********

  Future<void> updateLocationLive() async {
    _navigationSubscription = _locationManager
        .onUserLocationChange(5)
        .listen((LocationData currentLocation) async {
      // Print this if you suspect that data is loading more than expected
      //print("I loaded!");
      _cameraManager.viewUser();
      await _updateDirections();
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

  @visibleForTesting
  Future<Station> getStartStation(Place origin, [int groupSize = 1]) async {
    Loc.Location startLocation = origin.geometry.location;
    return await _stationManager.getPickupStationNear(LatLng(startLocation.lat, startLocation.lng), groupSize);
  }

  @visibleForTesting
  Future<Station> getEndStation(Place destination, [int groupSize = 1]) async {
    Loc.Location endLocation = destination.geometry.location;
    return await _stationManager.getPickupStationNear(
        LatLng(endLocation.lat, endLocation.lng), groupSize);
  }

  @visibleForTesting
  setRoutes(
      Place origin, Place destination, Station startStation, Station endStation,
      [List<Place> intermediates = const <Place>[], int groupSize = 1]) async {
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

    _routeManager.setRoutes(startWalkRoute, bikeRoute, endWalkRoute);
    _routeManager.showAllRoutes();
  }

  findRoute(Place origin, Place destination,
      [List<Place> intermediates = const <Place>[], int groupSize = 1]) async {
    _routeManager.setLoading(true);
    Station startStation = await getStartStation(origin);
    Station endStation = await getEndStation(destination);

    await setRoutes(origin, destination, startStation, endStation,
        intermediates, groupSize);
    _routeManager.setLoading(false);
    notifyListeners();
  }

  @visibleForTesting
  Future<int> getDurationFromToStation(
      Station startStation, Station endStation) async {
    Rou.Route route = await _directionsService.getRoutes(
        startStation.place.placeId, endStation.place.placeId);
    int durationSeconds = route.duration;
    int durationMinutes = (durationSeconds / 60).ceil();
    return durationMinutes;
  }

  @visibleForTesting
  double costEfficiencyHeuristic(
      Station curStation, Station intermediaryStation, Station endStation) {
    double startHeuristic = _locationManager.distanceFromTo(
        LatLng(curStation.lat, curStation.lng),
        LatLng(intermediaryStation.lat, intermediaryStation.lng));
    double endHeuristic = _locationManager.distanceFromTo(
        LatLng(intermediaryStation.lat, intermediaryStation.lng),
        LatLng(endStation.lat, endStation.lng));
    return endHeuristic / startHeuristic;
  }

  Future<void> findCostEfficientRoute(Place origin, Place destination,
      [int groupSize = 1]) async {
    _routeManager.clearRouteMarkers();
    _routeManager.removeWaypoints();
    _routeManager.setRouteMarkers();
    _routeManager.setLoading(true);
    Station startStation = await getStartStation(origin);
    Station endStation = await getEndStation(destination);

    Station curStation = startStation;

    List<Station> intermediateStations = <Station>[];

    while (curStation != endStation) {
      if (await getDurationFromToStation(curStation, endStation) <= 25) {
        curStation = endStation;
      } else {
        List<Station> nearbyStations = _stationManager
            .getStationsInRadius(LatLng(curStation.lat, curStation.lng));
        nearbyStations.sort((stationA, stationB) => costEfficiencyHeuristic(
                curStation, stationA, endStation)
            .compareTo(
                costEfficiencyHeuristic(curStation, stationB, endStation)));
        for (int i = 0; i < nearbyStations.length; i++) {
          await _stationManager.cachePlaceId(nearbyStations[i]);
          if ((await getDurationFromToStation(
                  curStation, nearbyStations[i])) <=
              25) {
            intermediateStations.add(nearbyStations[i]);
            curStation = nearbyStations[i];
            break;
          }
        }
      }
    }

    List<Place> intermediates =
        intermediateStations.map((station) => station.place).toList();

    for (Place station in intermediates) {
      setLocationMarker(
          station, _routeManager.addCostWaypoint(station).getUID());
    }
    clearStationMarkersNotInRoute();

    await setRoutes(
        origin, destination, startStation, endStation, intermediates);
    _routeManager.setLoading(false);
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

  @visibleForTesting
  void setNavigationSubscription(){
    updateLocationLive();
  }
  // ********** Stations **********

  @visibleForTesting
  setStationTimer(){
    _stationTimer = Timer.periodic(Duration(seconds: 10), (timer) { });
  }

  @visibleForTesting
  getStationTimer(){
    return _stationTimer;
  }

  cancelStationTimer() {
    _stationTimer.cancel();
  }

  updateStationsPeriodically() async {
    int duration = await _userSettings.stationsRefreshRate();
    _stationTimer = Timer.periodic(Duration(seconds: duration), (timer) {
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
    filterStationMarkers();
    notifyListeners();
  }

  Future<void> filterStationMarkers() async {
    if (_navigationManager.ifNavigating()) {
      return;
    }

    double range = await _userSettings.nearbyStationsRange();
    int groupSize = _routeManager.getGroupSize();

    List<Station> nearbyStations = _stationManager.getNearStations(range);

    List<Station> displayedStations =
        _stationManager.getStationsWithBikes(groupSize, nearbyStations);
    List<Station> notDisplayedStations =
        _stationManager.getStationsCompliment(displayedStations);

    _markerManager.setStationMarkers(displayedStations, this);
    _markerManager.clearStationMarkers(notDisplayedStations);

    notifyListeners();
  }

  viewStationMarker(Station station, [int uid = -1]) {
    // Do this in case station marker is not on the map
    _markerManager.setStationMarkerWithUID(station, this, uid);
    _cameraManager.setCameraPosition(LatLng(station.lat, station.lng));
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
    _routeManager.setLoading(true);
    await fetchCurrentLocation();
    setSelectedScreen('navigation');
    await _navigationManager.start();
    await updateLocationLive();
    _routeManager.showCurrentRoute();
    _userSettings.saveRoute(
        _routeManager.getStart().getStop(),
        _routeManager.getDestination().getStop(),
        _routeManager.getWaypoints().map((e) => e.getStop()).toList());
    Wakelock.enable();
    _routeManager.setLoading(false);
    notifyListeners();
  }

  Future<void> _updateDirections() async {
    // End subscription if not navigating?

    if (!_navigationManager.ifNavigating()) return;

    await fetchCurrentLocation();
    if (await _navigationManager.checkWaypointPassed()) {
      // dialog box informing user that they have arrived at their destination
      _dialogManager.showEndOfRouteDialog();
      endRoute();
      notifyListeners();
      return;
    }

    if (_routeManager.ifWalkToFirstWaypoint() &&
        _routeManager.ifFirstWaypointSet()) {
      await _navigationManager.updateRouteWithWalking();
      await setPartialRoutes(
          [_routeManager.getFirstWaypoint().getStop().placeId],
          _routeManager
              .getWaypoints()
              .sublist(1)
              .map((waypoint) => waypoint.getStop().placeId)
              .toList());
    } else {
      await _navigationManager.updateRoute();
      await setPartialRoutes(
          [],
          _routeManager
              .getWaypoints()
              .map((waypoint) => waypoint.getStop().placeId)
              .toList());
    }
    clearStationMarkersNotInRoute();
  }

  Future<void> setPartialRoutes(
      [List<String> first = const <String>[],
      List<String> intermediates = const <String>[]]) async {
    String originId = _routeManager.getStart().getStop().placeId;
    String destinationId = _routeManager.getDestination().getStop().placeId;

    String startStationId = _navigationManager.getPickupStation().place.placeId;
    String endStationId = _navigationManager.getDropoffStation().place.placeId;
    Rou.Route startWalkRoute = _navigationManager.ifBeginning()
        ? await _directionsService.getWalkingRoutes(
            originId, startStationId, first, false)
        : Rou.Route.routeNotFound();

    Rou.Route bikeRoute = _navigationManager.ifBeginning()
        ? await _directionsService.getRoutes(startStationId, endStationId,
            intermediates, _routeManager.ifOptimised())
        : _navigationManager.ifCycling()
            ? await _directionsService.getRoutes(originId, endStationId,
                intermediates, _routeManager.ifOptimised())
            : Rou.Route.routeNotFound();

    Rou.Route endWalkRoute = _navigationManager.ifEndWalking()
        ? await _directionsService.getWalkingRoutes(originId, destinationId)
        : await _directionsService.getWalkingRoutes(
            endStationId, destinationId);

    _routeManager.setRoutes(startWalkRoute, bikeRoute, endWalkRoute);
    _routeManager.showCurrentRoute(false);
  }

  void clearStationMarkersNotInRoute() {
    _markerManager.clearStationMarkers(_stationManager.getStations());

    Station pickupStation = _navigationManager.getPickupStation();
    Station dropOffStation = _navigationManager.getDropoffStation();

    _markerManager.setStationMarker(pickupStation, this);
    _markerManager.setStationMarker(dropOffStation, this);
  }

  // ********** User Setting Management **********

  bool isUserLogged() {
    return _databaseManager.isUserLogged();
  }

  // Clears selected route and directions
  void clearMap() {
    _routeManager.clear();
    _directionManager.clear();
    _directionManager.clear();
  }

  void changeUnits() async {
    DistanceType units = await _userSettings.distanceUnit();
    _locationManager.setUnits(units);
    updateStations();
    notifyListeners();
  }

  void updateSettings() {
    cancelStationTimer();
    updateStationsPeriodically();
    changeUnits();
    filterStationMarkers();
    notifyListeners();
  }

  void notifyListeningWidgets() {
    notifyListeners();
  }
}
