import 'dart:async';

import 'package:bicycle_trip_planner/models/geometry.dart';
import 'package:bicycle_trip_planner/models/location.dart';
import 'package:bicycle_trip_planner/models/pathway.dart';
import 'package:bicycle_trip_planner/models/place.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../models/stop.dart';


class DatabaseManager {
  //************Fields************
  final FirebaseDatabase _dbInstance = FirebaseDatabase.instance;
  final _auth = FirebaseAuth.instance;

  //********** Singleton **********
  static final DatabaseManager _databaseManager = DatabaseManager._internal();
  factory DatabaseManager() {
    return _databaseManager;
  }

  DatabaseManager._internal();


  //********** Public **********

  Future<bool> addToFavouriteStations(int stationID) async {
    if(_auth.currentUser == null){
      return false;
    }
    var uid = _auth.currentUser?.uid;
    DatabaseReference favouriteStations = _dbInstance.ref('users/$uid/favouriteStations');
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
    DatabaseReference favouriteStations = _dbInstance.ref('users/$uid/favouriteStations');
    List<int> output = [];
    await favouriteStations.once().then((value) => {
    for (var id in value.snapshot.children.cast()) {
        output.add(id.value)
    }
    });

    return output;
  }

  Future<bool> removeFavouriteStation(String stationId) async {
    var uid = FirebaseAuth.instance.currentUser?.uid;
    DatabaseReference favouriteRoutes = _dbInstance.ref('users/$uid/favouriteStations');
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


  Future<bool> addToFavouriteRoutes(Place start, Place end, List<Place> stops) async{
    if(_auth.currentUser == null){
      return false;
    }

    if(start.description.isEmpty|| end.description.isEmpty){
      return false;
    }
    var uid = FirebaseAuth.instance.currentUser?.uid;
    DatabaseReference favouriteRoutes = _dbInstance.ref('users/$uid/favouriteRoutes');
    Map<String, Object> intermediatePlaces = {};
    Map<String, Object> route = {};
    route['start'] = _place2Map(start);
    route['end'] = _place2Map(end);
    stops.removeWhere((place) => place == Place.placeNotFound());
    for(int i = 0; i < stops.length; i++){
      Place stop = stops[i];
      if(stop != const Place.placeNotFound()){
        intermediatePlaces[i.toString()] = _place2Map(stop);
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
    DatabaseReference favouriteRoutes = _dbInstance.ref('users/$uid/favouriteRoutes');
    Map<String, Pathway> pathways = {};
    await favouriteRoutes.once().then((value) => {
      for (var child in value.snapshot.children) {
        pathways[child.key.toString()] = _mapToPathway(child.value)
      }
    });
    return pathways;
  }

  Future<bool> removeFavouriteRoute(String routeKey) async {
    var uid = FirebaseAuth.instance.currentUser?.uid;
    DatabaseReference favouriteRoutes = _dbInstance.ref('users/$uid/favouriteRoutes');
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


  //********** Private **********

  Map<String, Object> _place2Map(Place place) {
    Map<String, Object> output = {};
    output['name'] = place.name;
    output['description'] = place.description;
    output['id'] = place.placeId;
    output['lng'] = place.geometry.location.lng;
    output['lat'] = place.geometry.location.lat;
    return output;
  }

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

  Place _mapToPlace(dynamic mapIn) {
    return Place(
      name: mapIn['name'],
      description: mapIn['description'],
      placeId: mapIn['id'],
      geometry: Geometry(
          location: Location(lat: mapIn['lat'], lng: mapIn['lng'])
      )
    );

  }



}
