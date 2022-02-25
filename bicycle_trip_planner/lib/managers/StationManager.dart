
import 'package:bicycle_trip_planner/managers/LocationManager.dart';
import 'package:bicycle_trip_planner/models/station.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StationManager {

  //********** Fields **********

  List<Station> _stations = <Station>[];

  //TODO currently maintains a distance list to have a value when stations are
  //TODO updated but new distance values arent calculated
  List<double> _stationDistances = <double>[];

  // Maximum filter distance to a station in miles  
  double _maxFilterDistance = 1; 

  // Maximum number of stations on the page
  int _stationsPerPage = 10; 

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

  int getNumberOfStationsPerPage(){
    return _stationsPerPage; 
  }

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

  List<Station> getClosestStationsNear(LatLng pos) {
    List<Station> orderedStations = _getOrderedToFromStationList(pos);
    List<Station> closestStations = orderedStations.where((station) => !isStationTooFar(pos, station)).toList(); 
    if(closestStations.length <= _stationsPerPage){
      return closestStations; 
    }
    return closestStations.take(10).toList(); 
  }

  Station getPickupStationNear(LatLng pos, [int groupSize = 1]){
    List<Station> orderedStations = _getOrderedToFromStationList(pos);
    return orderedStations.firstWhere((station) => station.bikes >= groupSize, orElse: Station.stationNotFound);
  }

  Station getDropoffStationNear(LatLng pos, [int groupSize = 1]){
    List<Station> orderedStations = _getOrderedToFromStationList(pos);
    return orderedStations.firstWhere((station) => station.emptyDocks >= groupSize, orElse: Station.stationNotFound);
  }

  bool isStationTooFar(LatLng pos, Station station){
    if(station.isStationNotFound()){return false;}
    LatLng stationPos = LatLng(station.lat, station.lng);
    double distance = _locationManager.distanceFromTo(pos, stationPos);
    return distance >= _maxFilterDistance; 
  } 

  void setMaxFilterDistance(double distance){
    _maxFilterDistance = distance;
  }

  void setMaxNumberOfStationMarkers(int noOfStations){
    _stationsPerPage = noOfStations;
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
      _stations[i].distanceToUser = _stationDistances[i];
    }

    await setStationDistances();

    _stations.sort((stationA, stationB) => stationA.distanceToUser.compareTo(stationB.distanceToUser));
  }

  //TODO Refactor so that no longer have to maintain distances list
  Future<void> setStationDistances() async {
    LatLng currentPos = await _locationManager.locate();

    // for (var station in _stations) {
    //   station.distanceTo = _locationManager.distanceFromTo(currentPos, LatLng(station.lat, station.lng));
    // }

    for(int i = 0; i < _stations.length; i++){
      _stations[i].distanceToUser = _locationManager.distanceFromTo(currentPos, LatLng(_stations[i].lat, _stations[i].lng));
      _stationDistances[i] = _stations[i].distanceToUser;
    }
  }

}