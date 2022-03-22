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

    // add recent searches to prefs and store as json map
    if (prefs.getString("recentSearches") != null) {
      String? encodedMap = prefs.getString("recentSearches");
      var decodedMap = json.decode(encodedMap!);
      Map<String, dynamic>.from(decodedMap);
      decodedMap[place.placeId] = place.description;
      String encodedMap1 = json.encode(decodedMap);
      await prefs.setString("recentSearches", encodedMap1);
      print(decodedMap.toString());
    } else {
      Map<String, String> placeDetails = {place.placeId: place.description};
      String encodedMap = json.encode(placeDetails);
      await prefs.setString("recentSearches", encodedMap);
    }
  }

  // Retrieve recent searches map
  getPlace() async {
    final SharedPreferences prefs = await _prefs;
    final String? encodedMap = prefs.getString("recentSearches");
    var decodedMap = json.decode(encodedMap!);
    Map<String, dynamic>.from(decodedMap);
    // print(decodedMap);
    return decodedMap;
  }

  saveRoute(Place origin, Place destination, List<Place> intermediates) async {
    final SharedPreferences prefs = await _prefs;
    Map<String, dynamic> route = {};
    route[origin.placeId] = origin.description;

    for (var place in intermediates) {
      route[place.placeId] = place.description;
    }

    route[destination.placeId] = destination.description;
    print(route);

    // if routes is empty
    if ((prefs.getString("recentSearches") == null)) {
      Map<int, Map<String, dynamic>> routes = {};
      routes[0] = route;
      String encodedMap = json.encode(routes);
      await prefs.setString("recentRoutes", encodedMap);
    } else {
      String? encodedMap = prefs.getString("recentRoutes");
      var decodedMap = json.decode(encodedMap!);

      Map<int, Map<String, dynamic>>.from(decodedMap);
      // add to new route to decoded map
      int recordNumber = decodedMap.keys.length + 1; // could not be + 1
      decodedMap[recordNumber] = route;
      String encodedMap1 = json.encode(decodedMap);
      await prefs.setString("recentRoutes", encodedMap1);
    }
  }

  getRoute() async {
    final SharedPreferences prefs = await _prefs;
    final String? encodedMap = prefs.getString("recentRoutes");
    var decodedMap = json.decode(encodedMap!);
    Map<int, Map<String, dynamic>>.from(decodedMap);
    // print(decodedMap);
    return decodedMap;
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
