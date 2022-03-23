import 'dart:async';
import 'package:bicycle_trip_planner/managers/DatabaseManager.dart';
import 'package:bicycle_trip_planner/models/distance_types.dart';
import 'package:bicycle_trip_planner/models/pathway.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/geometry.dart';
import '../models/location.dart';
import '../models/place.dart';
import '../models/stop.dart';

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
    if (place.description != "My Current Location") {
      if (prefs.getString("recentSearches") != null) {
        String? encodedMap = prefs.getString("recentSearches");
        var decodedMap = json.decode(encodedMap!);
        Map<String, dynamic>.from(decodedMap);
        decodedMap[place.placeId] = place.description;

        // remove recent searches that are now quite old
        if (decodedMap.keys.toList().length > 4) {
          decodedMap.keys.toList().reversed.toList().remove(0);
          decodedMap.values.toList().reversed.toList().remove(0);
        }

        String encodedMap1 = json.encode(decodedMap);
        await prefs.setString("recentSearches", encodedMap1);
        // print(decodedMap.toString());
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

  // saveRoute(Place origin, Place destination, List<Place> intermediates) async {
  //   final SharedPreferences prefs = await _prefs;
  //   Map<String, dynamic> route = {};
  //   route[origin.placeId] = origin.description;
  //
  //   for (var place in intermediates) {
  //     route[place.placeId] = place.description;
  //   }
  //
  //   route[destination.placeId] = destination.description;
  //   // print("/////////////////////////////route/////////////////////////////////");
  //   // print(route);
  //
  //   // if routes is empty
  //   if ((prefs.getString("recentRoutes") != null)) {
  //     String? encodedMap = prefs.getString("recentRoutes");
  //     print("**************** 1 " + encodedMap!);
  //
  //     var decoded = Map<int, Map<String, dynamic>>.from(json.decode(encodedMap));
  //     // add to new route to decoded map
  //     int recordNumber = decoded.keys.length + 1; // could not be + 1
  //     decoded[recordNumber] = route;
  //     print("/////////////////////////decodedmap////////////////////////////");
  //     String encodedMap1 = json.encode(decoded);
  //     print("**************** encodedMap1 " + encodedMap1);
  //     await prefs.setString("recentRoutes", encodedMap1);
  //   } else {
  //
  //     Map<int, Map<String, dynamic>> recentRoutes = {};
  //     recentRoutes[0] = route;
  //     print("recent route with number " + recentRoutes.toString());
  //
  //     String encodedMap = json.encode(recentRoutes.toString());
  //
  //     print("**************** " + encodedMap);
  //     // print("////////////////////////////////////////////////////////////");
  //     // print(encodedMap);
  //     await prefs.setString("recentRoutes", encodedMap);
  //   }
  // }

  // TODO: make sure it works, delete prints
  saveRoute(Place origin, Place destination, List<Place> intermediates) async {
    final SharedPreferences prefs = await _prefs;
    String savedElements = prefs.getString('recentRoutes') ?? "{}";
    print('******** savedElements ${savedElements}');
    print("------------");
    Map<String, dynamic> savedRoutes = jsonDecode(savedElements);
    print('******** savedRoutes ${savedRoutes}');
    print("------------");
    Map<String, dynamic> newRoute = {};
    Map<String, dynamic> start = _place2Map(origin);
    Map<String, dynamic> end = _place2Map(destination);
    Map<String, dynamic> stops = {};

    for (int i = 0; i < intermediates.length; i++) {
      stops[i.toString()] = _place2Map(intermediates[i]);
    }

    newRoute['start'] = start;
    newRoute['end'] = end;
    newRoute['stops'] = stops;

    print('******** newRoute ${newRoute}');
    print("------------");
    // """"${(savedRoutes.keys.length + 1).toString()}" """.trim()
    savedRoutes[(savedRoutes.keys.length + 1).toString()] = newRoute;
    prefs.setString('recentRoutes', json.encode(savedRoutes));

    print('******** savedRoutes after saving ${savedRoutes}');
    print("------------");
  }

  Future<int> getNumberOfRoutes() async {
    final SharedPreferences prefs = await _prefs;

    String? encodedMap = prefs.getString('recentRoutes') ;
    var decodedMap = json.decode(encodedMap!);
    Map<String, dynamic>.from(decodedMap);

    if (encodedMap == null) {
      return 0;
    } else {
      return decodedMap.keys.toList().length;
    }
  }

  Future<Map<String, dynamic>> getRoute() async {
    final SharedPreferences prefs = await _prefs;
    final String? encodedMap = prefs.getString("recentRoutes");
    Map<String, dynamic> decodedMap = json.decode(encodedMap!);

    //print(decodedMap["1"]["start"]["description"]);
    // print("------------");
    // print(decodedMap);
    // print("------------");
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
// TODO: there is same method in databaseManager.dart make a helper class to have these
  Map<String, Object> _place2Map(Place place) {
    Map<String, Object> output = {};
    output['name'] = place.name;
    output['description'] = place.description;
    output['id'] = place.placeId;
    output['lng'] = place.geometry.location.lng;
    output['lat'] = place.geometry.location.lat;
    return output;
  }

  Pathway _mapToPathway(dynamic mapIn) {
    // TODO: refactor this to work with your code
    Pathway output = Pathway();
    // output.changeStart(_mapToPlace(mapIn['start']));
    // output.changeDestination(_mapToPlace(mapIn['end']));
    // if(mapIn['stops'] != null) {
    //   for(var stop in mapIn['stops']){
    //     output.addStop(Stop(_mapToPlace(stop)));
    //   }
    // }
    return output;
  }

  // TODO: there is same method in databaseManager.dart make a helper class to have these
  Place _mapToPlace(dynamic mapIn) {
    return Place(
        name: mapIn['name'],
        description: mapIn['description'],
        placeId: mapIn['id'],
        geometry:
            Geometry(location: Location(lat: mapIn['lat'], lng: mapIn['lng'])));
  }
}
