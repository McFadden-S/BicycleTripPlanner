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
  //List<Station> _deadStations = [];

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

  Station? getStationById(int stationId) {
    Station? output;
    for (var station in _stations) {
      if(station.id == stationId){
        output = station;
      }
    }
    return output;
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
  List<Station> getStationsWithAtLeastXBikes(
      int bikes, List<Station> filteredStations) {
    return filteredStations.where((station) => station.bikes >= bikes).toList();
  }

  List<Station> getStationsWithNoBikes(List<Station> filteredStations) {
    return filteredStations.where((station) => station.bikes <= 0).toList();
  }

  List<Station> getFarStations() {
    List<Station> farStations = [];

    farStations =
        _stationsLookUp.difference(getNearStations().toSet()).toList();
    //print(farStations);

    return farStations;
  }

  List<Station> getNearStations() {
    List<Station> nearbyStations = [];

    int lastIndex = _stations.lastIndexWhere((station) {
      return station.distanceTo < 0.5;
    });
    nearbyStations = _stations.take(lastIndex + 1).toList();
    //print(nearbyStations);

    return nearbyStations;
  }

  Future<void> setStations(List<Station> newStations) async {
    LatLng currentPos = await _locationManager.locate();

    for (Station newStation in newStations) {
      Station? station = _stationsLookUp.lookup(newStation);
      double distance = _locationManager.distanceFromTo(
          currentPos, LatLng(newStation.lat, newStation.lng));
      if (station != null) {
        station.update(newStation, distance);
      } else {
        _stations.add(newStation);
        _stationsLookUp.add(newStation);
        newStation.update(newStation, distance);
      }
    }

    _stations.sort((stationA, stationB) =>
        stationA.distanceTo.compareTo(stationB.distanceTo));
  }

}
