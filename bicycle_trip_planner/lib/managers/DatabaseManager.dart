import 'dart:async';

import 'package:bicycle_trip_planner/models/pathway.dart';
import 'package:bicycle_trip_planner/models/place.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../models/search_types.dart';
import '../models/stop.dart';
import 'Helper.dart';

/// Class Comment:
/// DatabaseManager is a manager class that manages data transfer
/// to and from the Firebase Database

class DatabaseManager {

  //************Fields************

  final FirebaseDatabase _dbInstance = FirebaseDatabase.instance;
  final _auth = FirebaseAuth.instance;

  //********** Singleton **********

  /// Holds Singleton Instance
  static final DatabaseManager _databaseManager = DatabaseManager._internal();

  /// Singleton Constructor Override
  factory DatabaseManager() {
    return _databaseManager;
  }

  DatabaseManager._internal();

  //********** Public **********

  Future<bool> addToFavouriteStations(int stationID) async {
    if (_auth.currentUser == null) {
      return false;
    }
    var uid = _auth.currentUser?.uid;
    DatabaseReference favouriteStations =
        _dbInstance.ref('users/$uid/favouriteStations');
    Map<String, int> favorites = {};
    favorites['$stationID'] = stationID;
    await favouriteStations.update(favorites).then((_) {
      // Data saved successfully!
      return true;
    }).catchError((error) {
      // The write failed...
      return false;
    });
    //no error caught
    return true;
  }

  Future<List<int>> getFavouriteStations() async {
    var uid = FirebaseAuth.instance.currentUser?.uid;
    DatabaseReference favouriteStations =
        _dbInstance.ref('users/$uid/favouriteStations');
    List<int> output = [];
    await favouriteStations.once().then((value) => {
          for (var id in value.snapshot.children.cast()) {output.add(id.value)}
        });

    return output;
  }

  Future<bool> removeFavouriteStation(String stationId) async {
    var uid = FirebaseAuth.instance.currentUser?.uid;
    DatabaseReference favouriteRoutes =
        _dbInstance.ref('users/$uid/favouriteStations');
    await favouriteRoutes.child(stationId).remove().then((_) {
      // Data removed successfully!
      return true;
    }).catchError((error) {
      // error
      return false;
    });
    //no error caught
    return true;
  }

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

  Future<Map<String, Pathway>> getFavouriteRoutes() async {
    var uid = FirebaseAuth.instance.currentUser?.uid;
    DatabaseReference favouriteRoutes =
        _dbInstance.ref('users/$uid/favouriteRoutes');
    Map<String, Pathway> pathways = {};
    await favouriteRoutes.once().then((value) => {
          for (var child in value.snapshot.children)
            {pathways[child.key.toString()] = Helper.mapToPathway(child.value)}
        });
    print("Pathsways: $pathways");
    return pathways;
  }

  Future<bool> removeFavouriteRoute(String routeKey) async {
    var uid = FirebaseAuth.instance.currentUser?.uid;
    DatabaseReference favouriteRoutes =
        _dbInstance.ref('users/$uid/favouriteRoutes');
    await favouriteRoutes.child(routeKey).remove().then((_) {
      // Data removed successfully!
      return true;
    }).catchError((error) {
      // error
      return false;
    });
    //no error caught
    return true;
  }

  bool isUserLogged() {
    return _auth.currentUser != null;
  }
}
