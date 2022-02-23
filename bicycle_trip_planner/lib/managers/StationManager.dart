
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