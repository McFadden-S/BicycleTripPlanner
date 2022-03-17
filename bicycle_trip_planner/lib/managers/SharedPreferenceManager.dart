import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceManager {
  //final prefs = await SharedPreferences.getInstance();

  //********** Singleton **********

  static final SharedPreferenceManager _sharedPreferenceManager = SharedPreferenceManager._internal();

  factory SharedPreferenceManager() {
    return _sharedPreferenceManager;
  }

  SharedPreferenceManager._internal();

  addRecentStart(startStation) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('start', startStation);
    final String? start = prefs.getString('start');
    print(start);
  }
}