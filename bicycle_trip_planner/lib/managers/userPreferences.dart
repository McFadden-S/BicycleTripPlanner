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




//********** Private **********

}