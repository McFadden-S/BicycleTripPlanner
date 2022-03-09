import 'package:bicycle_trip_planner/managers/LocationManager.dart';
import 'package:bicycle_trip_planner/models/station.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StationManager {
  //********** Fields **********

  List<Station> _stations = <Station>[];

  // Used only for O(1) look up times for efficiency
  Set<Station> _stationsLookUp = <Station>{};

  // List of dead stations from the PREVIOUS update
  // TODO: ONLY USED FOR UPDATING MARKERS SO FAR
  List<Station> _deadStations = [];

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
    List<Station> nearPos = _getOrderedToFromStationList(pos);
    return nearPos.firstWhere((station) => station.bikes >= groupSize,
        orElse: Station.stationNotFound);
  }

  Station getDropoffStationNear(LatLng pos, [int groupSize = 1]) {
    List<Station> nearPos = _getOrderedToFromStationList(pos);
    return nearPos.firstWhere((station) => station.emptyDocks >= groupSize,
        orElse: Station.stationNotFound);
  }

  // TODO: Find a better method name
  List<Station> getStationsWithAtLeastXBikes(int bikes) {
    return _stations.where((station) => station.bikes >= bikes).toList();
  }

  List<Station> getStationsWithNoBikes(List<Station> filteredStations) {
    return filteredStations.where((station) => station.bikes <= 0).toList();
  }

  // Retrieves a list of stations that previously had 0 bikes but just got bikes
  List<Station> getDeadStationsWhichNowHaveBikes(
      List<Station> filteredStations) {
    List<Station> deadStations = getStationsWithNoBikes(filteredStations);
    List<Station> newStations =
        _deadStations.toSet().difference(deadStations.toSet()).toList();
    return newStations;
  }

  void setDeadStations(List<Station> deadStations) {
    _deadStations = deadStations;
  }

  Future<List<Station>> getFarStations() async {
    List<Station> _farStations = [];
    LatLng currentPos = await _locationManager.locate();
    double distance;

    for (var station in _stations) {
      distance = _locationManager.distanceFromTo(
          currentPos, LatLng(station.lat, station.lng));
      if (distance > 0.5) {
        _farStations.add(station);
      }
    }

    return _farStations;
  }

  Future<List<Station>> getNearStations() async {
    List<Station> _nearbyStations = [];
    LatLng currentPos = await _locationManager.locate();
    double distance;

    for (var station in _stations) {
      distance = _locationManager.distanceFromTo(
          currentPos, LatLng(station.lat, station.lng));
      if (distance < 0.5) {
        _nearbyStations.add(station);
      }
    }
    return _nearbyStations;
  }

  Future<void> setStations(List<Station> newStations) async {
    LatLng currentPos = await _locationManager.locate();

    //Add any new stations to list if they are not in the list
    List<Station> refreshedStations =
        newStations.toSet().difference(_stations.toSet()).toList();

    _stations.addAll(refreshedStations);
    _stationsLookUp.addAll(refreshedStations);

    for (Station newStation in newStations) {
      Station? station = _stationsLookUp.lookup(newStation);
      if (station != null) {
        double distance = _locationManager.distanceFromTo(
            currentPos, LatLng(station.lat, station.lng));
        station.update(newStation, distance);
      }
    }

    _stations.sort((stationA, stationB) =>
        stationA.distanceTo.compareTo(stationB.distanceTo));
  }
}
