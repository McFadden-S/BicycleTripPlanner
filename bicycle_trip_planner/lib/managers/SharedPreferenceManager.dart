import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceManager {
  //final prefs = await SharedPreferences.getInstance();

  List<String> startStops = [];
  List<String> endStops = [];

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
    final List<String>? middle = prefs.getStringList('end');
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
}