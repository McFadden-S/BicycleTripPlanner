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
    // encode place as json String and add (make helper methods if needed)
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
    await prefs.setBool('darkMode', !darkMode).then((_) {
      // Data removed successfully!
      return true;
    }).catchError((error) {
      // error
      return false;
    });
    //no error caught
    return true;
  }


  isDarkModeOn() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool('darkMode') ?? false;
  }

  distanceUnitToggle() async {
    final SharedPreferences prefs = await _prefs;
    bool darkMode = prefs.getBool('distanceInKilometers') ?? false;
    await prefs.setBool('distanceInKilometers', !darkMode).then((_) {
      // Data removed successfully!
      return true;
    }).catchError((error) {
      // error
      return false;
    });
    //no error caught
    return true;
  }

  // distance unit is set as kilometers if returns true,
  // otherwise the distance unit will be miles
  distanceInKilometers() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool('distanceInKilometers') ?? false;
  }


  // returns a number representing the amount of time (in seconds)
  // between every API call for stations (default is 30 seconds)
  stationsRefreshRate() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getInt('stationsRefreshRate') ?? 30;
  }

  // returns a number representing the amount of time (in seconds)
  // between every API call for stations (default is 30 seconds)
  setStationsRefreshRate(int seconds) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setInt('stationsRefreshRate', seconds).then((_) {
      // Data set successfully!
      return true;
    }).catchError((error) {
      // error
      return false;
    });
    //no error caught
    return true;
  }


//********** Private **********

}