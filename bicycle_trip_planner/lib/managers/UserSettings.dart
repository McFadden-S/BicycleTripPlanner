import 'dart:async';
import 'package:bicycle_trip_planner/managers/DatabaseManager.dart';
import 'package:bicycle_trip_planner/models/distance_types.dart';
import 'package:bicycle_trip_planner/models/pathway.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
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
    // encode this as a list of maps/maps with lots of values <--
    // use the different keys to differ between places.

    if (prefs.getString("one") != null) {
      String? encodedMap = prefs.getString("one");
      var decodedMap = json.decode(encodedMap!);
      // Map<String, String> placeDetails = decodedMap;
      Map<String, dynamic>.from(decodedMap);
      // placeDetails[place.placeId] = place.description;
      String encodedMap1 = json.encode(decodedMap);
      await prefs.setString("one", encodedMap1);
    } else {
      // create new prefs
      Map<String, String> placeDetails = {place.placeId: place.description};
      String encodedMap = json.encode(placeDetails);
      await prefs.setString("one", encodedMap);
    }
  }

  getPlace() async {
    final SharedPreferences prefs = await _prefs;
    final String? encodedMap = prefs.getString("one");
    var decodedMap = json.decode(encodedMap!);
    Map<String, dynamic>.from(decodedMap);
    print(decodedMap);
    return decodedMap;
  }

  saveRoute(Pathway pathway) async {
    final SharedPreferences prefs = await _prefs;
    // encode pathway as json String and add
    // await prefs.setString(key, value);
  }


  // returns String 'miles' or 'km'
  Future<DistanceType> distanceUnit() async {
    final SharedPreferences prefs = await _prefs;
    String distanceUnit = prefs.getString('distanceUnit') ?? 'miles';
    if (distanceUnit == "miles") {
      return DistanceType.miles;
    }
    return DistanceType.km;
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
