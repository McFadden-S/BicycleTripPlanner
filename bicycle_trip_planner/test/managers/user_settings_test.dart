import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test/test.dart';
import 'package:bicycle_trip_planner/managers/UserSettings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bicycle_trip_planner/models/place.dart';

void main() {
  final userSettings = UserSettings();

  const String _key = 'dummy';
  const String _prefixedKey = 'flutter.' + _key;

  setUp(() async {
    final SharedPreferences prefs = await userSettings.getSharedPref();
    final removeRecentSearches = await prefs.remove('recentSearches');
    final removeRecentRoutes = await prefs.remove('recentRoutes');
  });

  test('check shared pref works', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{_prefixedKey: 'my string'});
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_key);
    expect(value, 'my string');
  });

  test('check shared pref works with another instance being made', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{_prefixedKey: 'my other string'});
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_key);
    expect(value, 'my other string');
  });

  test('make sure a single place can be saved', () async {
    Place place = Place(
        latlng: const LatLng(51.511448, -0.116414),
        name: 'Bush House',
        placeId: "1",
        description: "the description"
    );

    userSettings.savePlace(place);
    final SharedPreferences prefs = await userSettings.getSharedPref();
    String? placeString = prefs.getString("recentSearches");
    Map<String, dynamic> placeMap = json.decode(placeString!);
    expect(placeMap.length, 1);
    expect(placeMap.containsKey("1"), true);
    expect(placeMap.containsValue("the description"), true);
    expect(placeMap["1"], "the description");
  });

  test('make sure multiple places can be saved', () async {
    Place place = Place(
        latlng: const LatLng(51.511448, -0.116414),
        name: 'Bush House',
        placeId: "1",
        description: "the description"
    );

    Place place2 = Place(
        latlng: const LatLng(51.400520, -0.138209),
        name: "Maida Vale",
        placeId: "2",
        description: "the other description"
    );

    Place place3 = Place(
        latlng: const LatLng(51.678345, -0.125942),
        name: "Southampton Street, Strand",
        placeId: "3",
        description: "the final description"
    );

    userSettings.savePlace(place);
    userSettings.savePlace(place2);
    userSettings.savePlace(place3);

    // getting the Shared Pref from userSettings and checking stored values are correct
    final SharedPreferences prefs = await userSettings.getSharedPref();
    String? placeString = prefs.getString("recentSearches");
    Map<String, dynamic> placeMap = json.decode(placeString!);
    expect(placeMap.length, 3);

    expect(placeMap.containsKey("1"), true);
    expect(placeMap.containsValue("the description"), true);
    expect(placeMap["1"], "the description");

    expect(placeMap.containsKey("2"), true);
    expect(placeMap.containsValue("the other description"), true);
    expect(placeMap["2"], "the other description");

    expect(placeMap.containsKey("3"), true);
    expect(placeMap.containsValue("the final description"), true);
    expect(placeMap["3"], "the final description");

    // test places are stored in order of recency
    expect(placeMap.keys.first, "1");
    expect(placeMap.values.first, "the description");
    expect(placeMap.keys.last, "3");
    expect(placeMap.values.last, "the final description");
  });

  test('make sure savePlace cant save "My current location"', () async {
    Place place = Place(
        latlng: const LatLng(51.511448, -0.116414),
        name: 'Bush House',
        placeId: "1",
        description: "My current location"
    );

    userSettings.savePlace(place);
    final SharedPreferences prefs = await userSettings.getSharedPref();
    String? placeString = prefs.getString("recentSearches");
    expect(placeString, null);
  });

  test('make sure savePlace removes not so recent searches', () async {
    Place place = Place(
        latlng: const LatLng(51.511448, -0.116414),
        name: 'Bush House',
        placeId: "1",
        description: "the description"
    );

    Place place2 = Place(
        latlng: const LatLng(51.400520, -0.138209),
        name: "Maida Vale",
        placeId: "2",
        description: "the second description"
    );

    Place place3 = Place(
        latlng: const LatLng(51.678345, -0.125942),
        name: "Southampton Street, Strand",
        placeId: "3",
        description: "the third description"
    );

    Place place4 = Place(
        latlng: const LatLng(51.345439, -0.115543),
        name: "St. John's Wood Road",
        placeId: "4",
        description: "the fourth description"
    );

    Place place5 = Place(
        latlng: const LatLng(51.678345, -0.125942),
        name: "Caven Street, Strand",
        placeId: "5",
        description: "the fifth description"
    );

    userSettings.savePlace(place);
    userSettings.savePlace(place2);
    userSettings.savePlace(place3);
    userSettings.savePlace(place4);
    userSettings.savePlace(place5);

    // getting the Shared Pref from userSettings and checking stored values are correct
    final SharedPreferences prefs = await userSettings.getSharedPref();
    String? placeString = prefs.getString("recentSearches");
    Map<String, dynamic> placeMap = json.decode(placeString!);
    // max of 4 saved places at one time
    expect(placeMap.length, 4);

    // removes place that was first inserted into map
    expect(placeMap.containsKey("1"), false);
    expect(placeMap.containsValue("the description"), false);
    expect(placeMap["1"], null);

    // retains maps that are more recent
    expect(placeMap.containsKey("2"), true);
    expect(placeMap.containsValue("the second description"), true);
    expect(placeMap["2"], "the second description");

    expect(placeMap.containsKey("3"), true);
    expect(placeMap.containsValue("the third description"), true);
    expect(placeMap["3"], "the third description");

    expect(placeMap.containsKey("4"), true);
    expect(placeMap.containsValue("the fourth description"), true);
    expect(placeMap["4"], "the fourth description");

    expect(placeMap.containsKey("5"), true);
    expect(placeMap.containsValue("the fifth description"), true);
    expect(placeMap["5"], "the fifth description");

    // test places are stored in order of recency
    expect(placeMap.keys.first, "2");
    expect(placeMap.values.first, "the second description");

    expect(placeMap.keys.elementAt(1), "3");
    expect(placeMap.values.elementAt(1), "the third description");

    expect(placeMap.keys.elementAt(2), "4");
    expect(placeMap.values.elementAt(2), "the fourth description");

    expect(placeMap.keys.last, "5");
    expect(placeMap.values.last, "the fifth description");
  });

  test('make get place works with savePlace', () async {
    Place place = Place(
        latlng: const LatLng(51.511448, -0.116414),
        name: 'Bush House',
        placeId: "1",
        description: "the description"
    );

    userSettings.savePlace(place);
    Map<String, dynamic> placeMap = await userSettings.getPlace();

    expect(placeMap.length, 1);
    expect(placeMap.containsKey("1"), true);
    expect(placeMap.containsValue("the description"), true);
    expect(placeMap["1"], "the description");
  });

  test('get place works with multiple saved places', () async {
    Place place = Place(
        latlng: const LatLng(51.511448, -0.116414),
        name: 'Bush House',
        placeId: "1",
        description: "the description"
    );

    Place place2 = Place(
        latlng: const LatLng(51.400520, -0.138209),
        name: "Maida Vale",
        placeId: "2",
        description: "the second description"
    );

    Place place3 = Place(
        latlng: const LatLng(51.678345, -0.125942),
        name: "Southampton Street, Strand",
        placeId: "3",
        description: "the third description"
    );

    Place place4 = Place(
        latlng: const LatLng(51.345439, -0.115543),
        name: "St. John's Wood Road",
        placeId: "4",
        description: "the fourth description"
    );

    Place place5 = Place(
        latlng: const LatLng(51.678345, -0.125942),
        name: "Caven Street, Strand",
        placeId: "5",
        description: "the fifth description"
    );

    userSettings.savePlace(place);
    userSettings.savePlace(place2);
    userSettings.savePlace(place3);
    userSettings.savePlace(place4);
    userSettings.savePlace(place5);

    Map<String, dynamic> placeMap = await userSettings.getPlace();
    // max of 4 saved places at one time
    expect(placeMap.length, 4);

    // removes place that was first inserted into map
    expect(placeMap.containsKey("1"), false);
    expect(placeMap.containsValue("the description"), false);
    expect(placeMap["1"], null);

    // retains maps that are more recent
    expect(placeMap.containsKey("2"), true);
    expect(placeMap.containsValue("the second description"), true);
    expect(placeMap["2"], "the second description");

    expect(placeMap.containsKey("3"), true);
    expect(placeMap.containsValue("the third description"), true);
    expect(placeMap["3"], "the third description");

    expect(placeMap.containsKey("4"), true);
    expect(placeMap.containsValue("the fourth description"), true);
    expect(placeMap["4"], "the fourth description");

    expect(placeMap.containsKey("5"), true);
    expect(placeMap.containsValue("the fifth description"), true);
    expect(placeMap["5"], "the fifth description");

    // test places are stored in order of recency
    expect(placeMap.keys.first, "2");
    expect(placeMap.values.first, "the second description");

    expect(placeMap.keys.elementAt(1), "3");
    expect(placeMap.values.elementAt(1), "the third description");

    expect(placeMap.keys.elementAt(2), "4");
    expect(placeMap.values.elementAt(2), "the fourth description");

    expect(placeMap.keys.last, "5");
    expect(placeMap.values.last, "the fifth description");
  });

  test('make save route works with a start and end stop only', () async {
    Place startPlace = Place(
        latlng: const LatLng(51.511448, -0.116414),
        name: 'Bush House',
        placeId: "1",
        description: "the description"
    );

    Place endPlace = Place(
        latlng: const LatLng(51.400520, -0.138209),
        name: "Maida Vale",
        placeId: "2",
        description: "the end description"
    );

    // no intermediary stops set
    List<Place> intermediates = [];

    userSettings.saveRoute(startPlace, endPlace, intermediates);
    final SharedPreferences prefs = await userSettings.getSharedPref();
    String? routesString = prefs.getString("recentRoutes");
    Map<String, dynamic> placeMap = json.decode(routesString!);

    // stored one recent route
    expect(placeMap.length, 1);
    expect(placeMap.containsKey("0"), true);
    expect(placeMap["0"].containsKey("start"), true);
    expect(placeMap["0"].containsKey("end"), true);

    // expect 5 attributes of the start stop
    expect(placeMap["0"]["start"].length, 5);
    expect(placeMap["0"]["start"]["name"], "Bush House");
    expect(placeMap["0"]["start"]["description"], "the description");
    expect(placeMap["0"]["start"]["id"], "1");
    expect(placeMap["0"]["start"]["lat"], 51.511448);
    expect(placeMap["0"]["start"]["lng"], -0.116414);

    // expect 5 attributes of the end stop
    expect(placeMap["0"]["end"].length, 5);
    expect(placeMap["0"]["end"]["name"], "Maida Vale");
    expect(placeMap["0"]["end"]["description"], "the end description");
    expect(placeMap["0"]["end"]["id"], "2");
    expect(placeMap["0"]["end"]["lat"], 51.400520);
    expect(placeMap["0"]["end"]["lng"], -0.138209);

    // no intermediary stops set so length should be 0
    expect(placeMap["0"]["stops"].length, 0);
  });

  test('make save route works with a start and end stop only', () async {
    Place startPlace = Place(
        latlng: const LatLng(51.511448, -0.116414),
        name: 'Bush House',
        placeId: "1",
        description: "the description"
    );

    Place middleStopPlace1 = Place(
        latlng: const LatLng(51.345439, -0.115543),
        name: "St. John's Wood Road",
        placeId: "3",
        description: "the first middle stop description"
    );

    Place middleStopPlace2 = Place(
        latlng: const LatLng(51.678345, -0.125942),
        name: "Caven Street, Strand",
        placeId: "4",
        description: "the second middle stop description"
    );

    Place middleStopPlace3 = Place(
        latlng: const LatLng(51.678345, -0.125942),
        name: "Southampton Street, Strand",
        placeId: "5",
        description: "the third and final middle stop description"
    );

    Place endPlace = Place(
        latlng: const LatLng(51.400520, -0.138209),
        name: "Maida Vale",
        placeId: "2",
        description: "the end description"
    );

    List<Place> intermediates = [middleStopPlace1, middleStopPlace2, middleStopPlace3];

    userSettings.saveRoute(startPlace, endPlace, intermediates);
    final SharedPreferences prefs = await userSettings.getSharedPref();
    String? routesString = prefs.getString("recentRoutes");
    Map<String, dynamic> placeMap = json.decode(routesString!);

    // stored one recent route
    expect(placeMap.length, 1);
    expect(placeMap.containsKey("0"), true);
    expect(placeMap["0"].containsKey("start"), true);
    expect(placeMap["0"].containsKey("end"), true);

    // expect 5 attributes of the start stop
    expect(placeMap["0"]["start"].length, 5);
    expect(placeMap["0"]["start"]["name"], "Bush House");
    expect(placeMap["0"]["start"]["description"], "the description");
    expect(placeMap["0"]["start"]["id"], "1");
    expect(placeMap["0"]["start"]["lat"], 51.511448);
    expect(placeMap["0"]["start"]["lng"], -0.116414);

    expect(placeMap["0"]["stops"].length, 3);
    // check each stop is actually a stop
    for (var stop in placeMap["0"]["stops"]) {
      expect(stop["description"].contains("stop description"), true);
    }

    // expect 5 attributes of the end stop
    expect(placeMap["0"]["end"].length, 5);
    expect(placeMap["0"]["end"]["name"], "Maida Vale");
    expect(placeMap["0"]["end"]["description"], "the end description");
    expect(placeMap["0"]["end"]["id"], "2");
    expect(placeMap["0"]["end"]["lat"], 51.400520);
    expect(placeMap["0"]["end"]["lng"], -0.138209);
  });

  test('add multiple different type of routes with and without stops', () async {
    Place startPlace = Place(
        latlng: const LatLng(51.511448, -0.116414),
        name: 'Bush House',
        placeId: "1",
        description: "the description"
    );

    Place endPlace = Place(
        latlng: const LatLng(51.400520, -0.138209),
        name: "Maida Vale",
        placeId: "2",
        description: "the end description"
    );

    // no intermediary stops set
    List<Place> intermediates = [];

    Place startPlace1 = Place(
        latlng: const LatLng(51.345439, -0.115543),
        name: "St. John's Wood Road",
        placeId: "3",
        description: "the second route first description"
    );

    Place middleStop1 = Place(
        latlng: const LatLng(51.678345, -0.125942),
        name: "Caven Street, Strand",
        placeId: "4",
        description: "the second route middle stop description"
    );

    Place endPlace1 = Place(
        latlng: const LatLng(51.678345, -0.125942),
        name: "Southampton Street, Strand",
        placeId: "5",
        description: "the second route end description"
    );

    List<Place> intermediates1 = [middleStop1];

    userSettings.saveRoute(startPlace, endPlace, intermediates);
    userSettings.saveRoute(startPlace1, endPlace1, intermediates1);

    final SharedPreferences prefs = await userSettings.getSharedPref();
    String? routesString = prefs.getString("recentRoutes");
    Map<String, dynamic> placeMap = json.decode(routesString!);

    // stored two recent routes
    expect(placeMap.length, 2);
    expect(placeMap.containsKey("0"), true);
    expect(placeMap.containsKey("1"), true);

    expect(placeMap["0"]["start"]["name"], "Bush House");
    expect(placeMap["0"]["start"]["description"], "the description");
    expect(placeMap["0"]["start"]["id"], "1");
    expect(placeMap["0"]["start"]["lat"], 51.511448);
    expect(placeMap["0"]["start"]["lng"], -0.116414);

    expect(placeMap["0"]["end"]["name"], "Maida Vale");
    expect(placeMap["0"]["end"]["description"], "the end description");
    expect(placeMap["0"]["end"]["id"], "2");
    expect(placeMap["0"]["end"]["lat"], 51.400520);
    expect(placeMap["0"]["end"]["lng"], -0.138209);

    // no intermediary stops set so length should be 0
    expect(placeMap["0"]["stops"].length, 0);

    expect(placeMap["1"]["start"]["name"], "St. John's Wood Road");
    expect(placeMap["1"]["start"]["description"], "the second route first description");
    expect(placeMap["1"]["start"]["id"], "3");
    expect(placeMap["1"]["start"]["lat"], 51.345439);
    expect(placeMap["1"]["start"]["lng"], -0.115543);

    expect(placeMap["1"]["end"]["name"], "Southampton Street, Strand");
    expect(placeMap["1"]["end"]["description"], "the second route end description");
    expect(placeMap["1"]["end"]["id"], "5");
    expect(placeMap["1"]["end"]["lat"], 51.678345);
    expect(placeMap["1"]["end"]["lng"], -0.125942);

    // one intermediary stop set so length should be 1
    expect(placeMap["1"]["stops"].length, 1);

    for (var stop in placeMap["1"]["stops"]) {
      expect(stop["description"].contains("stop description"), true);
    }
  });

  test('add more than max routes to see if recent routes are stored properly', () async {
    Place startPlace = Place(
        latlng: const LatLng(51.511448, -0.116414),
        name: 'Bush House',
        placeId: "1",
        description: "the description"
    );

    Place endPlace = Place(
        latlng: const LatLng(51.400520, -0.138209),
        name: "Maida Vale",
        placeId: "2",
        description: "the end description"
    );

    // no intermediary stops set
    List<Place> intermediates = [];

    Place startPlace1 = Place(
        latlng: const LatLng(51.345439, -0.115543),
        name: "St. John's Wood Road",
        placeId: "3",
        description: "the second route first description"
    );

    Place endPlace1 = Place(
        latlng: const LatLng(51.678345, -0.125942),
        name: "Southampton Street, Strand",
        placeId: "4",
        description: "the second route end description"
    );

    List<Place> intermediates1 = [];

    Place startPlace2 = Place(
        latlng: const LatLng(51.678345, -0.125942),
        name: "Caven Street, Strand",
        placeId: "5",
        description: "the third route start description"
    );

    Place endPlace2 = Place(
        latlng: const LatLng(49.947584, -0.124837),
        name: "Somerset House, Strand",
        placeId: "6",
        description: "the third route end description"
    );

    Place startPlace3 = Place(
        latlng: const LatLng(51.485573, -0.119585),
        name: "Sardinia Street, Holborn",
        placeId: "5",
        description: "the foruth route start description"
    );

    Place endPlace3 = Place(
        latlng: const LatLng(49.999233, -0.123456),
        name: "Drury Lane, Covent Garden",
        placeId: "6",
        description: "the fourth route end description"
    );

    Place startPlace3 = Place(
        latlng: const LatLng(51.485573, -0.119585),
        name: "Sardinia Street, Holborn",
        placeId: "5",
        description: "the foruth route start description"
    );

    Place endPlace3 = Place(
        latlng: const LatLng(49.999233, -0.123456),
        name: "Drury Lane, Covent Garden",
        placeId: "6",
        description: "the fourth route end description"
    );

    userSettings.saveRoute(startPlace, endPlace, intermediates);
    userSettings.saveRoute(startPlace1, endPlace1, intermediates1);

    final SharedPreferences prefs = await userSettings.getSharedPref();
    String? routesString = prefs.getString("recentRoutes");
    Map<String, dynamic> placeMap = json.decode(routesString!);

    // stored two recent routes
    expect(placeMap.length, 2);
    expect(placeMap.containsKey("0"), true);
    expect(placeMap.containsKey("1"), true);

    expect(placeMap["0"]["start"]["name"], "Bush House");
    expect(placeMap["0"]["start"]["description"], "the description");
    expect(placeMap["0"]["start"]["id"], "1");
    expect(placeMap["0"]["start"]["lat"], 51.511448);
    expect(placeMap["0"]["start"]["lng"], -0.116414);

    expect(placeMap["0"]["end"]["name"], "Maida Vale");
    expect(placeMap["0"]["end"]["description"], "the end description");
    expect(placeMap["0"]["end"]["id"], "2");
    expect(placeMap["0"]["end"]["lat"], 51.400520);
    expect(placeMap["0"]["end"]["lng"], -0.138209);

    // no intermediary stops set so length should be 0
    expect(placeMap["0"]["stops"].length, 0);

    expect(placeMap["1"]["start"]["name"], "St. John's Wood Road");
    expect(placeMap["1"]["start"]["description"], "the second route first description");
    expect(placeMap["1"]["start"]["id"], "3");
    expect(placeMap["1"]["start"]["lat"], 51.345439);
    expect(placeMap["1"]["start"]["lng"], -0.115543);

    expect(placeMap["1"]["end"]["name"], "Southampton Street, Strand");
    expect(placeMap["1"]["end"]["description"], "the second route end description");
    expect(placeMap["1"]["end"]["id"], "5");
    expect(placeMap["1"]["end"]["lat"], 51.678345);
    expect(placeMap["1"]["end"]["lng"], -0.125942);

    // one intermediary stop set so length should be 1
    expect(placeMap["1"]["stops"].length, 1);

    for (var stop in placeMap["1"]["stops"]) {
      expect(stop["description"].contains("stop description"), true);
    }
  });
}
