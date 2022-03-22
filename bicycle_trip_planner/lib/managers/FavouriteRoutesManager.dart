import 'package:bicycle_trip_planner/managers/DatabaseManager.dart';

import '../models/pathway.dart';

class FavouriteRoutesManager {
  //********** Fields **********

  Map<String,Pathway> _routes = {};

  //********** Singleton **********

  static final FavouriteRoutesManager _stationManager = FavouriteRoutesManager._internal();

  factory FavouriteRoutesManager() {
    return _stationManager;
  }

  FavouriteRoutesManager._internal();

  //********** Private **********

  //********** Public **********

  int getNumberOfRoutes() {
    return _routes.length;
  }

  Map<String, Pathway> getFavouriteRoutes() {
    return _routes;
  }

  Pathway? getFavouriteRouteByIndex(int index) {
    if(index < _routes.length && index >= 0) {
      return _routes[_routes.keys.toList()[index]]!;
    }
  }

  String getKey(int index) {
    if(index < _routes.length && index >= 0) {
      return _routes.keys.toList()[index];
    } else {
      return "";
    }
  }

  void updateRoutes() {
    if(DatabaseManager().isUserLogged()) {
      DatabaseManager().getFavouriteRoutes().then((value) => _routes = value);
    }
  }

}
