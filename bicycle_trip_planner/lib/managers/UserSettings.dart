import 'dart:async';
import 'package:bicycle_trip_planner/managers/DatabaseManager.dart';
import 'package:bicycle_trip_planner/models/distance_types.dart';
import 'package:bicycle_trip_planner/models/pathway.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/place.dart';
import 'Helper.dart';

class UserSettings {
  //********** Singleton **********
  static final UserSettings _userSettings = UserSettings._internal();

  static int MAX_RECENT_ROUTES_COUNT = 5;
  factory UserSettings() {
    return _userSettings;
  }
  UserSettings._internal();

//********** Fields **********
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

//********** Public **********

  savePlace(Place place) async {
    final SharedPreferences prefs = await _prefs;

    // add recent searches to prefs and store as json map
    if (place.description != "My current location") {
      if (prefs.getString("recentSearches") != null) {
        String? encodedMap = prefs.getString("recentSearches");
        var decodedMap = Map<String, dynamic>.from(json.decode(encodedMap!));
        decodedMap[place.placeId] = place.description;

        if (decodedMap.keys.toList().length > 4) {
          List<String> placeIds = decodedMap.keys.toList();
          decodedMap.remove(placeIds.first);
        }

        String encodedMap1 = json.encode(decodedMap);
        await prefs.setString("recentSearches", encodedMap1);
      } else {
        Map<String, String> placeDetails = {place.placeId: place.description};
        String encodedMap = json.encode(placeDetails);
        await prefs.setString("recentSearches", encodedMap);
      }
    }
  }

  // Retrieve recent searches map
  getPlace() async {
    final SharedPreferences prefs = await _prefs;
    final String? encodedMap = prefs.getString("recentSearches");
    var decodedMap = json.decode(encodedMap!);
    Map<String, dynamic>.from(decodedMap);
    return decodedMap;
  }

  saveRoute(Place origin, Place destination, List<Place> intermediates) async {
    final SharedPreferences prefs = await _prefs;
    String savedElements = prefs.getString('recentRoutes') ?? "{}";
    Map<String, dynamic> savedRoutes = jsonDecode(savedElements);
    //if there are already 5 routes saved
    if (savedRoutes.length == MAX_RECENT_ROUTES_COUNT) {
      savedRoutes = capRoutes(savedRoutes);
    }
    Map<String, dynamic> newRoute = {};
    Map<String, dynamic> start = Helper.place2Map(origin);
    Map<String, dynamic> end = Helper.place2Map(destination);
    List<Map<String, dynamic>> stops = [];

    for (int i = 0; i < intermediates.length; i++) {
      stops.add(Helper.place2Map(intermediates[i]));
    }

    print(start);
    print(end);
    print(stops);

    newRoute['start'] = start;
    newRoute['end'] = end;
    newRoute['stops'] = stops;

    savedRoutes[(savedRoutes.length).toString()] = newRoute;
    prefs.setString('recentRoutes', json.encode(savedRoutes));
  }

  Future<int> getNumberOfRoutes() async {
    final SharedPreferences prefs = await _prefs;
    String encodedMap = prefs.getString('recentRoutes') ?? "{}";
    var routeCount = Map<String, dynamic>.from(json.decode(encodedMap));

    if (routeCount.isEmpty) {
      return 0;
    }

    return routeCount.length;
  }

  Future<Pathway> getRecentRoute(int index) async {
    final SharedPreferences prefs = await _prefs;
    String encodedMap = prefs.getString('recentRoutes') ?? "{}";
    Map<String, dynamic> decodedMap = json.decode(encodedMap);
    print("decodedMap: ${decodedMap}");
    return Helper.mapToPathway(decodedMap[index.toString()]);
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

  Future<double> nearbyStationsRange() async {
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

  Map<String, dynamic> capRoutes(Map<String, dynamic> savedRoutes) {
    Map<String, dynamic> output = {};
    // update item keys
    for (var key in savedRoutes.keys) {
      output[(int.parse(key) - 1).toString()] = savedRoutes[key];
    }
    // remove oldest
    output.remove('-1');

    return output;
  }
}
