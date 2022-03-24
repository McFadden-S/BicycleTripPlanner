import 'dart:async';
import 'package:bicycle_trip_planner/models/distance_types.dart';
import 'package:bicycle_trip_planner/models/pathway.dart';
import 'package:flutter/cupertino.dart';
import 'package:bicycle_trip_planner/models/search_types.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/place.dart';
import 'Helper.dart';

/// Class Comment:
/// UserSettings is a manager class that holds the data and functions for
/// the use of shared preferences, which stores data on the user's device
/// for later use

class UserSettings {
  //********** Singleton **********

  /// Holds Singleton Instance
  static final UserSettings _userSettings = UserSettings._internal();

  /// Stores max recent routes allowed to be stored
  static const int MAX_RECENT_ROUTES_COUNT = 5;

  /// Singleton Constructor Override
  factory UserSettings() {
    return _userSettings;
  }
  UserSettings._internal();

//********** Fields **********
  // shared preference created to store data to disk
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

//********** Private **********

  Map<String, dynamic> _capRoutes(Map<String, dynamic> savedRoutes) {
    Map<String, dynamic> output = {};
    // update item keys
    for (var key in savedRoutes.keys) {
      output[(int.parse(key) - 1).toString()] = savedRoutes[key];
    }
    // remove oldest
    output.remove('-1');

    return output;
  }

//********** Public **********

  @visibleForTesting
  getSharedPref() {
    return _prefs;
  }

  /// @param place - Place; saves recent place passed through
  /// @return void
  /// @effects - saves a place to shared pref with the key "recentSearches"
  savePlace(Place place) async {
    final SharedPreferences prefs = await _prefs;

    // add recent searches to prefs and store as json map
    if (place.description != "My current location") {
      if (prefs.getString("recentSearches") != null) {
        // gets existing recent searches and converts it into map
        String? encodedMap = prefs.getString("recentSearches");
        var decodedMap = Map<String, dynamic>.from(json.decode(encodedMap!));
        decodedMap[place.placeId] = place.description;

        // stores a max of 4 recent searches, removing the not so recent searches
        if (decodedMap.keys.toList().length > 4) {
          List<String> placeIds = decodedMap.keys.toList();
          decodedMap.remove(placeIds.first);
        }

        // encodes recent searches into map so can be stored as string
        String encodedMap1 = json.encode(decodedMap);
        await prefs.setString("recentSearches", encodedMap1);
      } else {
        // adds first recent search if there are currently none stored
        Map<String, String> placeDetails = {place.placeId: place.description};
        String encodedMap = json.encode(placeDetails);
        await prefs.setString("recentSearches", encodedMap);
      }
    }
  }

  /// @param place - Place; saves recent place passed through
  /// @return Future<Map<String, dynamic>> - decodedMap; map of all recent searches
  /// @effects - gets all the recent searches stored in shared pref
  getPlace() async {
    final SharedPreferences prefs = await _prefs;
    final String? encodedMap = prefs.getString("recentSearches");
    var decodedMap = json.decode(encodedMap!);
    Map<String, dynamic>.from(decodedMap);
    return decodedMap;
  }

  /// @param -
  ///   origin - Place; start place of route
  ///   destination - Place; destination place of route
  ///   intermediates - List<Place>; intermediate stop(s) of a route
  /// @return void
  /// @effects - saves a route using in shared pref
  saveRoute(Place origin, Place destination, List<Place> intermediates) async {
    final SharedPreferences prefs = await _prefs;
    // if origin is user's current location
    if(origin.description == SearchType.current.description){
      origin = Place(
          latlng: origin.latlng,
          description: origin.name,
          placeId: origin.placeId,
          name: origin.name);
    }

    String savedElements = prefs.getString('recentRoutes') ?? "{}";
    Map<String, dynamic> savedRoutes = jsonDecode(savedElements);
    // check if there are already 5 routes saved beforehand
    if (savedRoutes.length == MAX_RECENT_ROUTES_COUNT) {
      savedRoutes = _capRoutes(savedRoutes);
    }
    // store new recent route
    Map<String, dynamic> newRoute = {};
    Map<String, dynamic> start = Helper.place2Map(origin);
    Map<String, dynamic> end = Helper.place2Map(destination);
    List<Map<String, dynamic>> stops = [];

    for (int i = 0; i < intermediates.length; i++) {
      stops.add(Helper.place2Map(intermediates[i]));
    }

    newRoute['start'] = start;
    newRoute['end'] = end;
    newRoute['stops'] = stops;

    // indexes the recent route based on if there are other recent routes
    savedRoutes[(savedRoutes.length).toString()] = newRoute;
    prefs.setString('recentRoutes', json.encode(savedRoutes));
  }

  /// @param void
  /// @return Future<int> - number of recent routes stored (max 5)
  Future<int> getNumberOfRoutes() async {
    final SharedPreferences prefs = await _prefs;
    String encodedMap = prefs.getString('recentRoutes') ?? "{}";
    var routeCount = Map<String, dynamic>.from(json.decode(encodedMap));

    if (routeCount.isEmpty) {
      return 0;
    }

    return routeCount.length;
  }

  /// @param index - int;
  /// @return Future<Pathway> - recent route at index as a pathway
  Future<Pathway> getRecentRoute(int index) async {
    final SharedPreferences prefs = await _prefs;
    String encodedMap = prefs.getString('recentRoutes') ?? "{}";
    Map<String, dynamic> decodedMap = json.decode(encodedMap);
    return Helper.mapToPathway(decodedMap[index.toString()]);
  }

  /// @param void
  /// @return Future<DistanceType> - String 'miles' or 'km'
  Future<DistanceType> distanceUnit() async {
    final SharedPreferences prefs = await _prefs;
    String distanceUnit = prefs.getString('distanceUnit') ?? 'miles';
    if (distanceUnit == "miles") {
      return DistanceType.miles;
    }
    return DistanceType.km;
  }

  /// @param unit - String; unit of distance
  /// @return void
  /// @affect sets distance unit based on parameter
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

  /// @param void
  /// @return int - a number representing the amount of time (in seconds)
  /// between every API call for stations (default is 30 seconds)
  stationsRefreshRate() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getInt('stationsRefreshRate') ?? 30;
  }

  /// @param seconds - int; refresh rate that we want
  /// @return void
  /// @affect sets station refresh rate based on parameter
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

  /// @param void
  /// @return Future<int> - a number representing the range of stations we want to display
  Future<double> nearbyStationsRange() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getDouble('nearbyStationsRange') ?? 0.5;
  }

  /// @param value - double; range of stations we want to display
  /// @return void
  /// @affect sets station range based on parameter
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
}
