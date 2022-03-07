import 'package:bicycle_trip_planner/managers/LocationManager.dart';
import 'package:bicycle_trip_planner/models/station.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StationManager {
  //********** Fields **********

  List<Station> _stations = <Station>[];
  Station _pickUpStation = Station(id: -1, name: "", lat: -1, lng: -1, bikes: -1, emptyDocks: -1, totalDocks: -1);
  Station _dropOffStation = Station(id: -1, name: "", lat: -1, lng: -1, bikes: -1, emptyDocks: -1, totalDocks: -1);

  // List of dead stations from the PREVIOUS update
  // TODO: ONLY USED FOR UPDATING MARKERS SO FAR
  List<Station> _deadStations = [];

  //TODO currently maintains a distance list to have a value when stations are
  //TODO updated but new distance values arent calculated
  List<double> _stationDistances = <double>[];

  final LocationManager _locationManager = LocationManager();

  //********** Singleton **********

  static final StationManager _stationManager = StationManager._internal();

  factory StationManager() {
    return _stationManager;
  }

  StationManager._internal();

  //********** Private **********

  List<Station> _getOrderedToFromStationList(LatLng pos) {
    List<Station> nearPos = List.castFrom(_stations);

    nearPos.sort((stationA, stationB) => _locationManager
        .distanceFromTo(LatLng(stationA.lat, stationA.lng), pos)
        .compareTo(_locationManager.distanceFromTo(
            LatLng(stationB.lat, stationB.lng), pos)));

    return nearPos;
  }

  //********** Public **********

  int getNumberOfStations() {
    return _stations.length;
  }

  List<Station> getStations() {
    return _stations;
  }

  Station getStationByIndex(int stationIndex) {
    return _stations[stationIndex];
  }

  Station getStationByName(String stationName) {
    return _stations.singleWhere((station) => station.name == stationName,
        orElse: Station.stationNotFound);
  }

  Station getPickupStationNear(LatLng pos, [int groupSize = 1]) {
    List<Station> orderedStations = _getOrderedToFromStationList(pos);
    _pickUpStation = orderedStations.firstWhere(
            (station) => station.bikes >= groupSize,
            orElse: Station.stationNotFound);
    return _pickUpStation;
  }

  Station getPickupStation() {
    return _pickUpStation;
  }

  bool isPickUpStationSet() {
    return _pickUpStation.id != -1;
  }

  void clearPickUpStation() {
    _pickUpStation = Station(id: -1, name: "", lat: -1, lng: -1, bikes: -1, emptyDocks: -1, totalDocks: -1);
  }

  bool checkPickUpStationHasBikes(int groupSize) {
    return _pickUpStation.bikes >= groupSize;
  }

  Station getDropOffStation() {
    return _dropOffStation;
  }

  bool isDropOffStationSet() {
    return _dropOffStation.id != -1;
  }

  void clearDropOffStation() {
    _dropOffStation = Station(id: -1, name: "", lat: -1, lng: -1, bikes: -1, emptyDocks: -1, totalDocks: -1);
  }

  bool checkDropOffStationHasEmptyDocks(int groupSize) {
    return _dropOffStation.emptyDocks >= groupSize;
  }

  Station getDropoffStationNear(LatLng pos, [int groupSize = 1]) {
    List<Station> orderedStations = _getOrderedToFromStationList(pos);
    _dropOffStation = orderedStations.firstWhere(
            (station) => station.emptyDocks >= groupSize,
            orElse: Station.stationNotFound);
    return _dropOffStation;
  }

  bool isStationSet(Station station) {
    return (_dropOffStation == station || _pickUpStation == station);
  }

  void clearStation(Station station) {
    if (_dropOffStation == station) {
      clearDropOffStation();
    }
    else if (_pickUpStation == station) {
      clearPickUpStation();
    }
  }

  // TODO: Find a better method name
  List<Station> getStationsWithAtLeastXBikes(int bikes) {
    return _stations.where((station) => station.bikes >= bikes).toList();
  }

  List<Station> getStationsWithNoBikes() {
    return _stations.where((station) => station.bikes <= 0).toList();
  }

  // Retrieves a list of stations that previously had 0 bikes but just got bikes
  List<Station> getDeadStationsWhichNowHaveBikes() {
    List<Station> deadStations = getStationsWithNoBikes();
    List<Station> newStations =
        _deadStations.toSet().difference(deadStations.toSet()).toList();
    return newStations;
  }

  void setDeadStations(List<Station> deadStations) {
    _deadStations = deadStations;
  }

  Future<List<Station>> getFarStations() async {
    List<Station> _nearbyStations = [];
    LatLng currentPos = await _locationManager.locate();
    double distance;

    for (var station in _stations) {
      distance = _locationManager.distanceFromTo(currentPos, LatLng(station.lat, station.lng));
      if (distance > 0.5) {
        _nearbyStations.add(station);
      }
    }

    return _nearbyStations;
  }

  //TODO Refactor so that no longer have to maintain distances list
  Future<void> setStations(List<Station> stations) async {
    if (_stationDistances.isEmpty) {
      _stationDistances = List.filled(stations.length, 0, growable: true);
    }
    _stations = stations;

    //Sets stations with intermediate distance values while waiting for new
    //values to be calculated async
    for (int i = 0; i < _stations.length; i++) {
      _stations[i].distanceTo = _stationDistances[i];
    }

    await setStationDistances();

    _stations.sort((stationA, stationB) =>
        stationA.distanceTo.compareTo(stationB.distanceTo));
  }

  //TODO Refactor so that no longer have to maintain distances list
  Future<void> setStationDistances() async {
    LatLng currentPos = await _locationManager.locate();

    // Set distance from current pos to each station, for each station
    for (int i = 0; i < _stations.length; i++) {
      _stations[i].distanceTo = _locationManager.distanceFromTo(
          currentPos, LatLng(_stations[i].lat, _stations[i].lng));
      _stationDistances[i] = _stations[i].distanceTo;
    }
  }
}
