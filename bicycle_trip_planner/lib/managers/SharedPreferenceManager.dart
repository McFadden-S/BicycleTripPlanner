import 'dart:collection';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPreferenceManager {
  LinkedHashMap recentSearch = new LinkedHashMap<String, String>();

  LinkedHashMap recentStartRoute = new LinkedHashMap<String, String>();
  LinkedHashMap recentEndRoute = new LinkedHashMap<String, String>();
  LinkedHashMap recentMiddleRoute = new LinkedHashMap<String, String>();
  List<LinkedHashMap> recentRoute = [];

  //********** Singleton **********

  static final SharedPreferenceManager _sharedPreferenceManager = SharedPreferenceManager._internal();

  factory SharedPreferenceManager() {
    return _sharedPreferenceManager;
  }

  SharedPreferenceManager._internal();

  //********** Public **********

  // create map with placeid and name for each start stop and intermediary
  // use linkedhashmap

  addToRecentStartRouteList(placeId, name) {
    recentStartRoute[placeId] = name;
  }

  addToRecentEndRouteList(placeId, name) {
    recentEndRoute[placeId] = name;
  }

  addToRecentMiddleRouteList(placeId, name) {
    recentMiddleRoute[placeId] = name;
  }

  addToRecentRoute() {
    recentRoute.add(recentStartRoute);
    recentRoute.add(recentEndRoute);
    recentRoute.add(recentMiddleRoute);
  }

  addToRecentSearchList(placeId, name) async {
    recentSearch[placeId] = name;

    String encodedMap = json.encode(recentSearch);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('recentSearches', encodedMap);
    String? encodedMapRecent = prefs.getString('recentSearches');
    var decodedMap = json.decode(encodedMapRecent!);
    // print("//////////////////////////////////////////////////////////////////");
    // print(decodedMap);
  }

  getRecentSearchPlaceID() {
    return recentSearch.keys;
  }

  getRecentSearchNames() {
    return recentSearch.values;
  }
}