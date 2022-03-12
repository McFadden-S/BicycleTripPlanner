import 'dart:async';

import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
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
    return false;
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


  addFavouriteRoute(){

  }

  getFavouriteRoutes(){

  }


}
