
import 'package:bicycle_trip_planner/managers/LocationManager.dart';
import 'package:bicycle_trip_planner/models/station.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StationManager {

  //********** Fields **********

  List<Station> _stations = <Station>[];

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

  Future<void> setStations(List<Station> stations) async {
    _stations = stations;
    setStationDistances();
  }

  Future<void> setStationDistances() async {
    for (var station in _stations) {
      station.distanceTo = await _locationManager.distanceTo(LatLng(station.lat, station.lng));
    }
  }

}