
import 'package:bicycle_trip_planner/managers/LocationManager.dart';
import 'package:bicycle_trip_planner/models/station.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StationManager {

  //********** Fields **********

  List<Station> _stations = <Station>[];

  LocationManager _locationManager = LocationManager();

  //********** Singleton **********

  static final StationManager _stationManager = StationManager._internal();

  factory StationManager() {return _stationManager;}

  StationManager._internal();

  //********** Private **********

  //********** Public **********

  List<Station> getStations(){
    return _stations;
  }

  Station getStation(String stationName){
    return _stations.singleWhere((station) =>
      station.name == stationName, orElse: Station.stationNotFound);
  }

  Future<void> setStations(List<Station> stations) async {
    _stations = stations;
    for (var station in _stations) {
      station.distanceTo = await _locationManager.distanceTo(LatLng(station.lat, station.lng));
    }
  }

}