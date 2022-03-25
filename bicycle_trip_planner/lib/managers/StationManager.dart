import 'package:bicycle_trip_planner/managers/DatabaseManager.dart';
import 'package:bicycle_trip_planner/managers/LocationManager.dart';
import 'package:bicycle_trip_planner/models/station.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../models/place.dart';
import '../services/places_service.dart';

class StationManager {
  //********** Fields **********

  List<Station> _stations = <Station>[];

  // Used only for O(1) look up times for efficiency
  Set<Station> _stationsLookUp = <Station>{};

  List<Station> _displayedStations = <Station>[];

  final LocationManager _locationManager = LocationManager();

  //********** Singleton **********

  static final StationManager _stationManager = StationManager._internal();

  factory StationManager() {
    return _stationManager;
  }

  StationManager._internal();

  //********** Private **********

  List<Station> _getOrderedToFromStationList(LatLng pos) {
    List<Station> nearPos = List.from(_stations);

    nearPos.sort((stationA, stationB) => _locationManager
        .distanceFromTo(LatLng(stationA.lat, stationA.lng), pos)
        .compareTo(_locationManager.distanceFromTo(
            LatLng(stationB.lat, stationB.lng), pos)));

    return nearPos;
  }

  //********** Stations **********

  int getNumberOfStations() {
    return _stations.length;
  }

  List<Station> getStations() {
    return _stations;
  }

  List<Station> getStationsInRadius(LatLng pos, [double distance = 4.0]) {
    List<Station> allStations = List.castFrom(_stations);

    List<Station> nearbyStations = allStations
        .where((s) =>
            _locationManager.distanceFromTo(pos, LatLng(s.lat, s.lng)) <=
            distance)
        .toList();

    return nearbyStations;
  }

  Future<void> cachePlaceId(Station station) async {
    if (station == Station.stationNotFound()) return;
    if (station.place == const Place.placeNotFound()) {
      Place place = await PlacesService().getPlaceFromCoordinates(
          station.lat, station.lng, "Santander Cycles: ${station.name}");
      station.place = place;
    }
  }

  Station getStationByIndex(int stationIndex) {
    cachePlaceId(_stations[stationIndex]);
    return _stations[stationIndex];
  }

  Station getStationById(int stationId) {
    Station station = _stations.firstWhere((station) => station.id == stationId,
        orElse: Station.stationNotFound);
    cachePlaceId(station);
    return station;
  }

  Station getStationByName(String stationName) {
    Station station = _stations.singleWhere(
        (station) => station.name == stationName,
        orElse: Station.stationNotFound);
    cachePlaceId(station);
    return station;
  }

  Future<Station> getPickupStationNear(LatLng pos, [int groupSize = 1]) async {
    List<Station> nearPos = _getOrderedToFromStationList(pos);
    Station station = nearPos.firstWhere(
        (station) => station.bikes >= groupSize,
        orElse: Station.stationNotFound);
    await cachePlaceId(station);
    return station;
  }

  Future<Station> getDropoffStationNear(LatLng pos, [int groupSize = 1]) async {
    List<Station> nearPos = _getOrderedToFromStationList(pos);
    Station station = nearPos.firstWhere(
        (station) => station.emptyDocks >= groupSize,
        orElse: Station.stationNotFound);
    await cachePlaceId(station);
    return station;
  }

  /// Returns a list of Stations with at least bikeNumber bikes
  List<Station> getStationsWithBikes(
      int bikeNumber, List<Station> filteredStations) {
    return filteredStations
        .where((station) => station.bikes >= bikeNumber)
        .toList();
  }

  /// Returns the list of all stations not including the ones passed into the function
  List<Station> getStationsCompliment(List<Station> stations) {
    return _stationsLookUp.difference(stations.toSet()).toList();
  }

  /// Returns a list of stations that are within the range passed in
  List<Station> getNearStations(double range) {
    List<Station> nearbyStations = [];

    int lastIndex = _stations.lastIndexWhere((station) {
      return station.distanceTo < range;
    });
    nearbyStations = _stations.take(lastIndex + 1).toList();

    return nearbyStations;
  }

  // Returns a list of stations that the user has favourited
  Future<List<Station>> getFavouriteStations() async {
    if (!DatabaseManager().isUserLogged()) return [];
    List<int> compare = await DatabaseManager().getFavouriteStations();
    List<Station> favouriteStations = List.from(_stations);
    favouriteStations.retainWhere((element) => compare.contains(element.id));
    return favouriteStations;
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
