import 'dart:async';
import 'package:bicycle_trip_planner/models/pathway.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/place.dart';
class UserPreferences {

  //********** Singleton **********
  static final UserPreferences _userPreferences = UserPreferences._internal();
  factory UserPreferences() {
    return _userPreferences;
  }
  UserPreferences._internal();


//********** Fields **********
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();



//********** Public **********

  savePlace(Place place) async {
    final SharedPreferences prefs = await _prefs;
    // encode place as json String and add
    // await prefs.setString(key, value);
  }


  saveRoute(Pathway pathway) async {
    final SharedPreferences prefs = await _prefs;
    // encode pathway as json String and add
    // await prefs.setString(key, value);
  }

  darkModeToggle() async {
    final SharedPreferences prefs = await _prefs;
    bool darkMode = prefs.getBool('darkMode') ?? false;
    prefs.setBool('darkMode', !darkMode);
  }



//********** Private **********

}