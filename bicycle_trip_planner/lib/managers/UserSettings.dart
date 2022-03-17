import 'dart:async';
import 'package:bicycle_trip_planner/managers/DatabaseManager.dart';
import 'package:bicycle_trip_planner/models/pathway.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/place.dart';
class UserSettings {
  //********** Singleton **********
  static final UserSettings _userSettings = UserSettings._internal();
  factory UserSettings() {
    return _userSettings;
  }
  UserSettings._internal();


//********** Fields **********
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool _isFavouriteStationsSelected = false;


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

  styleMode() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('styleMode') ?? 'System';
  }

  setStyleMode(String? newMode) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('styleMode', newMode ?? 'System').then((_) {
      // Data added successfully!
      return true;
    }).catchError((error) {
      // error
      return false;
    });
    //no error caught
    return true;
  }

  // returns String 'miles' or 'km'
  distanceUnit() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('distanceUnit') ?? 'miles';
  }

  setDistanceUnit(String? unit) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('distanceUnit', unit ?? 'miles').then((_) {
      // Data set successfully!
      return true;
    }).catchError((error) {
      // error
      return false;
    });
    //no error caught
    return true;
  }


  // returns a number representing the amount of time (in seconds)
  // between every API call for stations (default is 30 seconds)
  stationsRefreshRate() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getInt('stationsRefreshRate') ?? 30;
  }

  // returns a number representing the amount of time (in seconds)
  // between every API call for stations (default is 30 seconds)
  setStationsRefreshRate(int? seconds) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setInt('stationsRefreshRate', seconds ?? 30).then((_) {
      // Data set successfully!
      return true;
    }).catchError((error) {
      // error
      return false;
    });
    //no error caught
    return true;
  }


  nearbyStationsRange() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getDouble('nearbyStationsRange') ?? 0.5;
  }

  setNearbyStationsRange(double? value) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setDouble('nearbyStationsRange', value ?? 30.5).then((_) {
      // Data set successfully!
      return true;
    }).catchError((error) {
      // error
      return false;
    });
    //no error caught
    return true;
  }

  setIsFavouriteStationsSelected(bool value) {
    _isFavouriteStationsSelected = value;
  }

  getIsIsFavouriteStationsSelected() {
    return _isFavouriteStationsSelected;
  }

//********** Private **********

}