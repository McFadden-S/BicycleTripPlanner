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
import 'package:bicycle_trip_planner/models/route_types.dart';
import 'package:bicycle_trip_planner/models/search_types.dart';
import 'package:bicycle_trip_planner/models/stop.dart';
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
  LocationManager _locationManager = LocationManager();
  final CameraManager _cameraManager = CameraManager.instance;
  final DialogManager _dialogManager = DialogManager();
  final NavigationManager _navigationManager = NavigationManager();
  final UserSettings _userSettings = UserSettings();

  late Timer _stationTimer;
  late StreamSubscription<LocationData> _navigationSubscription;

  ApplicationBloc() {
    // Note: not async
    changeUnits();
    fetchCurrentLocation();
    updateStationsPeriodically();
  }

  @visibleForTesting
  ApplicationBloc.forMock(
      LocationManager locationManager, PlacesService placesService) {
    _locationManager = locationManager;
    _placesService = placesService;

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

  bool ifSearchResult() {
    return searchResults.isNotEmpty;
  }

  searchPlaces(String searchTerm) async {
    final client = http.Client();
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
      var client = http.Client();
      Place place = await _placesService.getPlaceFromCoordinates(
          station.lat, station.lng, "Santander Cycles: ${station.name}");
      station.place = place;
    }

    setSelectedLocation(station.place, uid);

    notifyListeners();
  }

  Future<void> updateLocationLive() async {
    _navigationSubscription = _locationManager
        .onUserLocationChange(5)
        .listen((LocationData currentLocation) async {
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
    _routeManager.setLoading(true);
    Station startStation = await _getStartStation(origin);
    Station endStation = await _getEndStation(destination);

    await _setRoutes(origin, destination, startStation, endStation,
        intermediates, groupSize);
    _routeManager.setLoading(false);
    notifyListeners();
  }

  _setRoutes(
      Place origin, Place destination, Station startStation, Station endStation,
      [List<Place> intermediates = const <Place>[], int groupSize = 1]) async {
    List<String> intermediatePlaceId =
        intermediates.map((place) => place.placeId).toList();

    Rou.Route startWalkRoute = await _directionsService.getRoutes(
        origin.placeId, startStation.place.placeId, RouteType.walk);
    Rou.Route bikeRoute = await _directionsService.getRoutes(
        startStation.place.placeId,
        endStation.place.placeId,
        RouteType.bike,
        intermediatePlaceId,
        _routeManager.ifOptimised());
    Rou.Route endWalkRoute = await _directionsService.getRoutes(
        endStation.place.placeId, destination.placeId, RouteType.walk);

    _routeManager.setRoutes(startWalkRoute, bikeRoute, endWalkRoute);
    _routeManager.showAllRoutes();
  }

  Future<int> _getDurationFromToStation(
      Station startStation, Station endStation) async {
    Rou.Route route = await _directionsService.getRoutes(
        startStation.place.placeId, endStation.place.placeId, RouteType.bike);
    int durationSeconds = route.duration;
    int durationMinutes = (durationSeconds / 60).ceil();
    return durationMinutes;
  }

  double _costEfficiencyHeuristic(
      Station curStation, Station intermediaryStation, Station endStation) {
    double startHeuristic = _locationManager.distanceFromTo(
        LatLng(curStation.lat, curStation.lng),
        LatLng(intermediaryStation.lat, intermediaryStation.lng));
    double endHeuristic = _locationManager.distanceFromTo(
        LatLng(intermediaryStation.lat, intermediaryStation.lng),
        LatLng(endStation.lat, endStation.lng));
    return endHeuristic / startHeuristic;
  }

  Future<Station> _getStartStation(Place origin, [int groupSize = 1]) async {
    return await _stationManager.getPickupStationNear(origin.latlng, groupSize);
  }

  Future<Station> _getEndStation(Place destination, [int groupSize = 1]) async {
    return await _stationManager.getPickupStationNear(
        destination.latlng, groupSize);
  }

  Future<void> findCostEfficientRoute(Place origin, Place destination,
      [int groupSize = 1]) async {
    _routeManager.clearRouteMarkers();
    _routeManager.clearPathwayMarkers();
    _routeManager.removeWaypoints();
    _routeManager.setLoading(true);
    Station startStation = await _getStartStation(origin);
    Station endStation = await _getEndStation(destination);

    Station curStation = startStation;

    List<Station> intermediateStations = <Station>[];

    while (curStation != endStation) {
      if (await _getDurationFromToStation(curStation, endStation) <= 25) {
        curStation = endStation;
      } else {
        List<Station> nearbyStations = _stationManager
            .getStationsInRadius(LatLng(curStation.lat, curStation.lng));
        nearbyStations.sort((stationA, stationB) => _costEfficiencyHeuristic(
                curStation, stationA, endStation)
            .compareTo(
                _costEfficiencyHeuristic(curStation, stationB, endStation)));
        for (int i = 0; i < nearbyStations.length; i++) {
          await _stationManager.cachePlaceId(nearbyStations[i]);
          if ((await _getDurationFromToStation(
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

    _markerManager.setPlaceMarker(
        _routeManager.getStart().getStop(), _routeManager.getStart().getUID());
    _markerManager.setPlaceMarker(_routeManager.getDestination().getStop(),
        _routeManager.getDestination().getUID());

    for (Place station in intermediates) {
      Stop stop = _routeManager.addCostWaypoint(station);
      _markerManager.setPlaceMarker(stop.getStop(), stop.getUID());
    }
    await _setRoutes(
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

  // ********** Stations **********

  cancelStationTimer() {
    _stationTimer.cancel();
  }

  updateStationsPeriodically() async {
    int duration = await UserSettings().stationsRefreshRate();
    _stationTimer = Timer.periodic(Duration(seconds: duration), (timer) {
      updateStations();
    });
  }

  setupStations() async {
    await updateStations();
    notifyListeners();
  }

  updateStations() async {
    await fetchCurrentLocation();

    http.Client client = new http.Client();
    await _stationManager.setStations(
      await _stationsService.getStations(client),
    );
    filterStationMarkers();
    notifyListeners();
  }

  Future<void> filterStationMarkers() async {
    if (_navigationManager.ifNavigating()) {
      return;
    }

    double range = await UserSettings().nearbyStationsRange();
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
    _userSettings.saveRoute(
        _routeManager.getStart().getStop(),
        _routeManager.getDestination().getStop(),
        _routeManager.getWaypoints().map((e) => e.getStop()).toList());
    await _navigationManager.start();
    await updateLocationLive();
    _routeManager.showCurrentRoute();
    Wakelock.enable();
    _routeManager.setLoading(false);
    _navigationManager.setLoading(false);

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
  }

  Future<void> setPartialRoutes(
      [List<String> first = const <String>[],
      List<String> intermediates = const <String>[]]) async {
    String originId = _routeManager.getStart().getStop().placeId;
    String destinationId = _routeManager.getDestination().getStop().placeId;

    String startStationId = _navigationManager.getPickupStation().place.placeId;
    String endStationId = _navigationManager.getDropoffStation().place.placeId;

    Rou.Route startWalkRoute = _navigationManager.ifBeginning()
        ? await _directionsService.getRoutes(
            originId, startStationId, RouteType.walk, first, false)
        : Rou.Route.routeNotFound();

    Rou.Route bikeRoute = _navigationManager.ifBeginning()
        ? await _directionsService.getRoutes(startStationId, endStationId,
            RouteType.bike, intermediates, _routeManager.ifOptimised())
        : _navigationManager.ifCycling()
            ? await _directionsService.getRoutes(originId, endStationId,
                RouteType.bike, intermediates, _routeManager.ifOptimised())
            : Rou.Route.routeNotFound();

    Rou.Route endWalkRoute = _navigationManager.ifEndWalking()
        ? await _directionsService.getRoutes(
            originId, destinationId, RouteType.walk)
        : await _directionsService.getRoutes(
            endStationId, destinationId, RouteType.walk);

    _routeManager.setRoutes(startWalkRoute, bikeRoute, endWalkRoute);
    _routeManager.showCurrentRoute(false);
  }

  // ********** User Setting Management **********

  bool isUserLogged() {
    return DatabaseManager().isUserLogged();
  }

  // Clears selected route and directions
  void clearMap() {
    _routeManager.clear();
    _directionManager.clear();
  }

  void changeUnits() async {
    DistanceType units = await UserSettings().distanceUnit();
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

  void loadFavouriteRoutes() {
    DatabaseManager().getFavouriteRoutes();
  }

  void notifyListeningWidgets() {
    notifyListeners();
  }
}
