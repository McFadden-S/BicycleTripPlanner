import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPreferenceManager {
  List<Map<String, String>> recentSearch = [];
  List<String> startStops = [];
  List<String> endStops = [];
  var recentSearchesJson = "";

  //********** Singleton **********

  static final SharedPreferenceManager _sharedPreferenceManager = SharedPreferenceManager._internal();

  factory SharedPreferenceManager() {
    return _sharedPreferenceManager;
  }

  SharedPreferenceManager._internal();

  //********** Public **********

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
    Map<String, String> recentSearchMap = {};
    recentSearchMap[placeId] = name;
    recentSearch.add(recentSearchMap);
    convertToJson(recentSearch);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('recentSearches', recentSearchesJson);
    String? encodedMap = prefs.getString('recentSearches');
    List<dynamic> decodedMap = json.decode(encodedMap!);
    // print("//////////////////////////////////////////////////////////////////");
    // print(decodedMap);
  }

  convertToJson(toBeConverted) {
    recentSearchesJson = json.encode(toBeConverted);
  }
}