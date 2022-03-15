import 'dart:async';

import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/models/place.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';


class DatabaseManager {
  //************Fields************


  //********** Singleton **********
  static final DatabaseManager _databaseManager = DatabaseManager._internal();
  final applicationBloc = ApplicationBloc();

  FirebaseDatabase _DBInstance = FirebaseDatabase.instance;
  final _auth = FirebaseAuth.instance;
  factory DatabaseManager() {
    return _databaseManager;
  }

  DatabaseManager._internal();

  //********** Private **********



  //********** Public **********

  Future<bool> addToFavouriteStations(int stationID) async {
    if(_auth.currentUser == null){
      return false;
    }
    var uid = _auth.currentUser?.uid;
    DatabaseReference favouriteStations = _DBInstance.ref('users/$uid/favouriteStations');
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
    List<int> output = [];
    var uid = _auth.currentUser?.uid;

    DatabaseReference favouriteStations = _DBInstance.ref('users/$uid/favouriteStations');
    await favouriteStations.once().then((value) => {
    for (var id in value.snapshot.children.cast()) {
        output.add(id.value)
    }
    });

    return output;
  }


  Future<bool> addToFavouriteRoutes(Place start, Place end, List<Place> stops) async{
    if(_auth.currentUser == null){
      return false;
    }

    if(start.description.isEmpty|| end.description.isEmpty){
      return false;
    }

    var uid = _auth.currentUser?.uid;
    DatabaseReference favouriteRoutes = _DBInstance.ref('users/$uid/favouriteRoutes');
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


  getFavouriteRoutes(){

  }


  Map<String, Object> _place2Map(Place place) {
    Map<String, Object> output = {};
    output['name'] = place.name;
    output['description'] = place.description;
    output['id'] = place.placeId;
    output['lng'] = place.geometry.location.lng;
    output['lat'] = place.geometry.location.lat;
    return output;
  }


}
