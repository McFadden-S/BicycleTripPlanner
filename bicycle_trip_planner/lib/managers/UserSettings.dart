import 'dart:async';
import 'package:bicycle_trip_planner/models/distance_types.dart';
import 'package:bicycle_trip_planner/models/pathway.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/place.dart';
import 'Helper.dart';

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
    if (place.description != "My current location") {
      if (prefs.getString("recentSearches") != null) {
        String? encodedMap = prefs.getString("recentSearches");
        var decodedMap = Map<String, dynamic>.from(json.decode(encodedMap!));
        decodedMap[place.placeId] = place.description;

        if (decodedMap.keys.toList().length > 4) {
          List<String> placeIds = decodedMap.keys.toList();
          placeIds.remove(placeIds.first);

          List<dynamic> names = decodedMap.values.toList();
          names.remove(names.first);

          Map<String, dynamic> newMap = {};
          for (int i = 0; i < names.length ; i++) {
            newMap[placeIds[i]] = names[i];
          }
          decodedMap = newMap;
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
    // print(decodedMap);
    return decodedMap;
  }

  // TODO: Delete prints
  saveRoute(Place origin, Place destination, List<Place> intermediates) async {
    final SharedPreferences prefs = await _prefs;
    String savedElements = prefs.getString('recentRoutes') ?? "{}";
    // print('******** savedElements ${savedElements}');
    // print("------------");
    Map<String, dynamic> savedRoutes = jsonDecode(savedElements);
    // print('******** savedRoutes ${savedRoutes}');
    // print("------------");
    Map<String, dynamic> newRoute = {};
    Map<String, dynamic> start =  Helper.place2Map(origin);
    Map<String, dynamic> end =  Helper.place2Map(destination);
    List<Map<String, dynamic>> stops = [];

    for (int i = 0; i < intermediates.length; i++) {
      stops.add( Helper.place2Map(intermediates[i]));
    }

    newRoute['start'] = start;
    newRoute['end'] = end;
    newRoute['stops'] = stops;

    // print('******** newRoute ${newRoute}');
    // print("------------");
    // """"${(savedRoutes.keys.length + 1).toString()}" """.trim()
    if(savedRoutes.isEmpty){
      savedRoutes['0'] = newRoute;
    }
    savedRoutes[(savedRoutes.keys.length + 1).toString()] = newRoute;
    prefs.setString('recentRoutes', json.encode(savedRoutes));

    // print('******** savedRoutes after saving ${savedRoutes}');
    // print("------------");
  }

  // Future<int> getNumberOfRoutes() async {
  //   final SharedPreferences prefs = await _prefs;
  //   String encodedMap = prefs.getString('recentRoutes') ?? "{}";
  //   var decodedMap = json.decode(encodedMap!);
  //   Map<String, dynamic>.from(decodedMap);
  //
  //   if (encodedMap == null) {
  //     return 0;
  //   } else {
  //     return decodedMap.keys.toList().length;
  //   }
  // }

  Future<Pathway> getRecentRoute(int index) async {
    final SharedPreferences prefs = await _prefs;
    String encodedMap = prefs.getString('recentRoutes') ?? "{}";
    Map<String, dynamic> decodedMap = json.decode(encodedMap);

    //print(decodedMap["1"]["start"]["description"]);
    // print("------------");
    // print(decodedMap);
    print("------------ ${decodedMap[index.toString()]}");
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

}
