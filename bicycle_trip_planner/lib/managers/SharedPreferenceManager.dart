import 'dart:collection';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPreferenceManager {
  LinkedHashMap recentSearch = new LinkedHashMap<String, String>();
  List<String> startStops = [];
  List<String> endStops = [];

  List<Map<List<String>, List<String>>> recentRoute = [];


  //********** Singleton **********

  static final SharedPreferenceManager _sharedPreferenceManager = SharedPreferenceManager._internal();

  factory SharedPreferenceManager() {
    return _sharedPreferenceManager;
  }

  SharedPreferenceManager._internal();

  //********** Public **********

  addRecentRoute(start, end, intermediateStops) async {
    Map<List<String>, List<String>> recentRouteMap = {};
    recentRouteMap[[start, end]] = intermediateStops;
    recentRoute.add(recentRouteMap);

    String encodedMap = json.encode(recentRoute);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('recentRoutes', encodedMap);
    String? encodedMapRoute = prefs.getString('recentRoutes');
    List<dynamic> decodedMap = json.decode(encodedMapRoute!);
    // print("/////////////////////////////////////////");
    // print(decodedMap);
  }

  addRecentStart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('start', startStops);
    final List<String>? start = prefs.getStringList('start');
    // print("/////////////////////////////start////////////////////////////////");
    // print(start);
  }

  addRecentEnd() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('end', endStops);
    final List<String>? end = prefs.getStringList('end');
    // print("//////////////////////////////end//////////////////////////////");
    // print(end);
  }

  addRecentIntermediary(middleStops) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('middle', middleStops);
    final List<String>? middle = prefs.getStringList('middle');
    // print("///////////////////////////middle//////////////////////////////");
    // print(middle);
  }

  addToStartList(startStop){
    startStops.add(startStop);
    // print("//////////////////////////////////////////////////////////////////");
    // print(startStops);
  }

  addToEndList(endStop) {
    endStops.add(endStop);
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