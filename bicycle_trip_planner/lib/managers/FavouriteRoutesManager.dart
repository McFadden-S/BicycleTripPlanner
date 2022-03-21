import '../models/pathway.dart';

class FavouriteRoutesManager {
  //********** Fields **********

  List<Pathway> _routes = [];

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

 List<Pathway> getFavouriteRoutes() {
    return _routes;
  }

  Pathway getFavouriteRouteByName(int index) {
    return _routes[index];
  }

}
