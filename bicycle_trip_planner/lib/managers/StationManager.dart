
import 'package:bicycle_trip_planner/managers/LocationManager.dart';
import 'package:bicycle_trip_planner/models/station.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StationManager {

  //********** Fields **********

  List<Station> _stations = <Station>[];

  //TODO currently maintains a distance list to have a value when stations are
  //TODO updated but new distance values arent calculated
  List<double> _stationDistances = <double>[];

  final LocationManager _locationManager = LocationManager();

  //********** Singleton **********

  static final StationManager _stationManager = StationManager._internal();

  factory StationManager() {return _stationManager;}

  StationManager._internal();

  //********** Private **********

  List<Station> _getOrderedToFromStationList(LatLng pos){
    List<Station> nearPos = List.castFrom(_stations);

    nearPos.sort((stationA, stationB) =>
        _locationManager.distanceFromTo(LatLng(stationA.lat, stationA.lng), pos)
            .compareTo(
            _locationManager.distanceFromTo(LatLng(stationB.lat, stationB.lng), pos)));

    return nearPos;
  }

  //********** Public **********

  int getNumberOfStations(){
    return _stations.length;
  }

  List<Station> getStations(){
    return _stations;
  }

  Station getStationByIndex(int stationIndex){
    return _stations[stationIndex];
  }

  Station getStationByName(String stationName){
    return _stations.singleWhere((station) =>
      station.name == stationName, orElse: Station.stationNotFound);
  }

  Station getPickupStationNear(LatLng pos, [int groupSize = 1]){
    List<Station> orderedStations = _getOrderedToFromStationList(pos);
    return orderedStations.firstWhere((station) => station.bikes >= groupSize, orElse: Station.stationNotFound);
  }

  Station getDropoffStationNear(LatLng pos, [int groupSize = 1]){
    List<Station> orderedStations = _getOrderedToFromStationList(pos);
    return orderedStations.firstWhere((station) => station.emptyDocks >= groupSize, orElse: Station.stationNotFound);
  }

  //TODO Refactor so that no longer have to maintain distances list
  Future<void> setStations(List<Station> stations) async {
    if(_stationDistances.isEmpty){
      _stationDistances = List.filled(stations.length, 0, growable: true);
    }
    _stations = stations;

    //Sets stations with intermediate distance values while waiting for new
    //values to be calculated async
    for(int i = 0; i<_stations.length; i++){
      _stations[i].distanceTo = _stationDistances[i];
    }

    await setStationDistances();

    _stations.sort((stationA, stationB) => stationA.distanceTo.compareTo(stationB.distanceTo));
  }

  //TODO Refactor so that no longer have to maintain distances list
  Future<void> setStationDistances() async {
    LatLng currentPos = await _locationManager.locate();

    // for (var station in _stations) {
    //   station.distanceTo = _locationManager.distanceFromTo(currentPos, LatLng(station.lat, station.lng));
    // }

    for(int i = 0; i < _stations.length; i++){
      _stations[i].distanceTo = _locationManager.distanceFromTo(currentPos, LatLng(_stations[i].lat, _stations[i].lng));
      _stationDistances[i] = _stations[i].distanceTo;
    }
  }

}