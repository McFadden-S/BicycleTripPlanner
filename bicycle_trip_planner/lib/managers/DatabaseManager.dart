import 'dart:async';

import 'package:bicycle_trip_planner/models/pathway.dart';
import 'package:bicycle_trip_planner/models/place.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/search_types.dart';
import '../models/stop.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'Helper.dart';

/// Class Comment:
/// DatabaseManager is a manager class that manages data transfer
/// to and from the Firebase Database


class DatabaseManager {

  //************Fields************

  late FirebaseDatabase _dbInstance;
  var _auth;

  Map<String,Pathway> _routes = {};

  //********** Singleton **********

  /// Holds Singleton Instance
  static final DatabaseManager _databaseManager = DatabaseManager._internal();

  /// Singleton Constructor Override
  factory DatabaseManager() {
    _databaseManager._dbInstance = FirebaseDatabase.instance;
    _databaseManager._auth = FirebaseAuth.instance;
    return _databaseManager;
  }

  DatabaseManager._internal();

  DatabaseManager.forMock(FirebaseDatabase db, FirebaseAuth auth){
    _dbInstance = db;
    _auth = auth;
  }

  //********** Public **********

  /// Add @param stationId to Favourite Stations
  Future<bool> addToFavouriteStations(int stationID) async {
    if (_auth.currentUser == null) {
      return false;
    }
    var uid = _auth.currentUser?.uid;
    DatabaseReference favouriteStations =
        _dbInstance.ref('users/$uid/favouriteStations');
    favouriteStations.child(stationID.toString()).set(stationID).then((_) {
      // Data saved successfully!
      return true;
    }).catchError((error) {
      // The write failed...
      return false;
    });
    //no error caught
    return true;
  }

  /// @return List<int> - list of all Favourite Stations Ids
  Future<List<int>> getFavouriteStations() async {
    var uid = _auth.currentUser?.uid;
    var favouriteStations = await _dbInstance.ref('users/$uid/favouriteStations');
    List<int> output = [];

    final result = await favouriteStations.once();
    final map = new Map<String, dynamic>.from(result.snapshot.value as Map<dynamic, dynamic>);
    //final map = result.snapshot.value as Map<String, int>;
    map.forEach((key, value) => {output.add(value)});

    return output;
  }

  /// Remove @param stationId from Favourite Stations
  /// @return true if stationId was successfully removed, false otherwise
  Future<bool> removeFavouriteStation(String stationId) async {
    var uid = _auth.currentUser?.uid;
    DatabaseReference favouriteRoutes = _dbInstance.ref('users/$uid/favouriteStations');
    favouriteRoutes.child(stationId).set(null).then((_) {
      // Data removed successfully!
      return true;
    }).catchError((error) {
      // error
      return false;
    });
    //no error caught
    return true;
  }

  /// Add @param start, end, stops to Favourite Routes
  Future<bool> addToFavouriteRoutes(
      Place start, Place end, List<Place> stops) async {
    if (_auth.currentUser == null) {
      return false;
    }

    if (start.description.isEmpty || end.description.isEmpty) {
      return false;
    }
    if(start.description == SearchType.current.description){
      start = Place(
          latlng: start.latlng,
          description: start.name,
          placeId: start.placeId,
          name: start.name);
    }
    var uid = FirebaseAuth.instance.currentUser?.uid;
    DatabaseReference favouriteRoutes =
        _dbInstance.ref('users/$uid/favouriteRoutes');
    Map<String, Object> intermediatePlaces = {};
    Map<String, Object> route = {};
    route['start'] = Helper.place2Map(start);
    route['end'] = Helper.place2Map(end);
    stops.removeWhere((place) => place == Place.placeNotFound());
    for (int i = 0; i < stops.length; i++) {
      Place stop = stops[i];
      if (stop != const Place.placeNotFound()) {
        intermediatePlaces[i.toString()] = Helper.place2Map(stop);
      }
    }
    route['stops'] = intermediatePlaces;
    await favouriteRoutes.push().update(route).then((_) {
      // Data saved successfully!
      return true;
    }).catchError((error) {
      // The write failed...
      return false;
    });
    //no error caught
    return true;
  }

  /// @return Map<String, Pathway> - map of all Favourite Routes
  Future<Map<String, Pathway>> getFavouriteRoutes() async {
    var uid = _auth.currentUser?.uid;
    DatabaseReference favouriteRoutes = _dbInstance.ref('users/$uid/favouriteRoutes');
    Map<String, Pathway> pathways = {};
    final result = await favouriteRoutes.once();
    final map = new Map<String, dynamic>.from(result.snapshot.value as Map<dynamic, dynamic>);
    map.forEach((key, value) => { pathways[key] =  Helper.mapToPathway(value)});
    _routes = pathways;
    return pathways;
  }

  /// Remove route with @param routeKey from Favourite Routes
  /// @return true if route was successfully removed, false otherwise
  Future<bool> removeFavouriteRoute(String routeKey) async {
    var uid = FirebaseAuth.instance.currentUser?.uid;
    DatabaseReference favouriteRoutes =
        _dbInstance.ref('users/$uid/favouriteRoutes');
    await favouriteRoutes.child(routeKey).set(null).then((_) {
      // Data removed successfully!
      return true;
    }).catchError((error) {
      // error
      return false;
    });
    //no error caught
    return true;
  }

  /// @return true if user is logged in, false otherwise
  bool isUserLogged() {
    return _auth.currentUser != null;
  }


  //********** Manage favourite routes **********

  /// @return number of routes
  int getNumberOfRoutes() {
    return _routes.length;
  }

  /// @return favourite route with @param index
  Pathway? getFavouriteRouteByIndex(int index) {
    if(index < _routes.length && index >= 0) {
      return _routes[_routes.keys.toList()[index]]!;
    }
  }

  /// @return route key of route with @param index
  String getRouteKeyByIndex(int index) {
    if(index < _routes.length && index >= 0) {
      return _routes.keys.toList()[index];
    } else {
      return "";
    }
  }


  //********** Private **********

  /// @return Map from @param place
  Map<String, Object> _place2Map(Place place) {
    Map<String, Object> output = {};
    output['name'] = place.name;
    output['description'] = place.description;
    output['id'] = place.placeId;
    output['lng'] = place.latlng.longitude;
    output['lat'] = place.latlng.latitude;
    return output;
  }

  /// @return Pathway from @param mapIn
  Pathway _mapToPathway(dynamic mapIn) {
    Pathway output = Pathway();
    output.changeStart(_mapToPlace(mapIn['start']));
    output.changeDestination(_mapToPlace(mapIn['end']));
    if(mapIn['stops'] != null) {
      for(var stop in mapIn['stops']){
        output.addStop(Stop(_mapToPlace(stop)));
      }
    }
    return output;
  }

  /// @return Place from @param mapIn
  Place _mapToPlace(dynamic mapIn) {
    return Place(
      name: mapIn['name'],
      description: mapIn['description'],
      placeId: mapIn['id'],
      latlng: LatLng(mapIn['lat'], mapIn['lng'])
    );

  }

}
