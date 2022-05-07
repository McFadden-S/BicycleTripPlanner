import 'dart:convert';
import 'package:bicycle_trip_planner/models/distance_types.dart';
import 'package:bicycle_trip_planner/models/pathway.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test/test.dart';
import 'package:bicycle_trip_planner/managers/UserSettings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bicycle_trip_planner/models/place.dart';


/// NOTE: Tests only run on an Non MacOS device as a result of a macOS shared
/// preferences issue
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final userSettings = UserSettings();

  const String _key = 'dummy';
  const String _prefixedKey = 'flutter.' + _key;

  // clear currently saved shared prefs, if any
  setUp(() async {
    final SharedPreferences prefs = await userSettings.getSharedPref();
    final removeRecentSearches = await prefs.remove('recentSearches');
    final removeRecentRoutes = await prefs.remove('recentRoutes');
    final removeDistanceUnit = await prefs.remove('distanceUnit');
    final removeRefreshRate = await prefs.remove('stationsRefreshRate');
    final removeNearbyStations = await prefs.remove('nearbyStationsRange');
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

  test('make sure savePlace() can not save "My current location"', () async {
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

  test('make sure savePlace() removes not so recent searches', () async {
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
    Map<String, dynamic> routeMap = json.decode(routesString!);

    // stored one recent route
    expect(routeMap.length, 1);
    expect(routeMap.containsKey("0"), true);
    expect(routeMap["0"].containsKey("start"), true);
    expect(routeMap["0"].containsKey("end"), true);

    // expect 5 attributes of the start stop
    expect(routeMap["0"]["start"].length, 5);
    expect(routeMap["0"]["start"]["name"], "Bush House");
    expect(routeMap["0"]["start"]["description"], "the description");
    expect(routeMap["0"]["start"]["id"], "1");
    expect(routeMap["0"]["start"]["lat"], 51.511448);
    expect(routeMap["0"]["start"]["lng"], -0.116414);

    // expect 5 attributes of the end stop
    expect(routeMap["0"]["end"].length, 5);
    expect(routeMap["0"]["end"]["name"], "Maida Vale");
    expect(routeMap["0"]["end"]["description"], "the end description");
    expect(routeMap["0"]["end"]["id"], "2");
    expect(routeMap["0"]["end"]["lat"], 51.400520);
    expect(routeMap["0"]["end"]["lng"], -0.138209);

    // no intermediary stops set so length should be 0
    expect(routeMap["0"]["stops"].length, 0);
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
    Map<String, dynamic> routeMap = json.decode(routesString!);

    // stored one recent route
    expect(routeMap.length, 1);
    expect(routeMap.containsKey("0"), true);
    expect(routeMap["0"].containsKey("start"), true);
    expect(routeMap["0"].containsKey("end"), true);

    // expect 5 attributes of the start stop
    expect(routeMap["0"]["start"].length, 5);
    expect(routeMap["0"]["start"]["name"], "Bush House");
    expect(routeMap["0"]["start"]["description"], "the description");
    expect(routeMap["0"]["start"]["id"], "1");
    expect(routeMap["0"]["start"]["lat"], 51.511448);
    expect(routeMap["0"]["start"]["lng"], -0.116414);

    expect(routeMap["0"]["stops"].length, 3);
    // check each stop is actually a stop
    for (var stop in routeMap["0"]["stops"]) {
      expect(stop["description"].contains("stop description"), true);
    }

    // expect 5 attributes of the end stop
    expect(routeMap["0"]["end"].length, 5);
    expect(routeMap["0"]["end"]["name"], "Maida Vale");
    expect(routeMap["0"]["end"]["description"], "the end description");
    expect(routeMap["0"]["end"]["id"], "2");
    expect(routeMap["0"]["end"]["lat"], 51.400520);
    expect(routeMap["0"]["end"]["lng"], -0.138209);
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
    Map<String, dynamic> routeMap = json.decode(routesString!);

    // stored two recent routes
    expect(routeMap.length, 2);
    expect(routeMap.containsKey("0"), true);
    expect(routeMap.containsKey("1"), true);

    expect(routeMap["0"]["start"]["name"], "Bush House");
    expect(routeMap["0"]["start"]["description"], "the description");
    expect(routeMap["0"]["start"]["id"], "1");
    expect(routeMap["0"]["start"]["lat"], 51.511448);
    expect(routeMap["0"]["start"]["lng"], -0.116414);

    expect(routeMap["0"]["end"]["name"], "Maida Vale");
    expect(routeMap["0"]["end"]["description"], "the end description");
    expect(routeMap["0"]["end"]["id"], "2");
    expect(routeMap["0"]["end"]["lat"], 51.400520);
    expect(routeMap["0"]["end"]["lng"], -0.138209);

    // no intermediary stops set so length should be 0
    expect(routeMap["0"]["stops"].length, 0);

    expect(routeMap["1"]["start"]["name"], "St. John's Wood Road");
    expect(routeMap["1"]["start"]["description"], "the second route first description");
    expect(routeMap["1"]["start"]["id"], "3");
    expect(routeMap["1"]["start"]["lat"], 51.345439);
    expect(routeMap["1"]["start"]["lng"], -0.115543);

    expect(routeMap["1"]["end"]["name"], "Southampton Street, Strand");
    expect(routeMap["1"]["end"]["description"], "the second route end description");
    expect(routeMap["1"]["end"]["id"], "5");
    expect(routeMap["1"]["end"]["lat"], 51.678345);
    expect(routeMap["1"]["end"]["lng"], -0.125942);

    // one intermediary stop set so length should be 1
    expect(routeMap["1"]["stops"].length, 1);

    for (var stop in routeMap["1"]["stops"]) {
      expect(stop["description"].contains("stop description"), true);
    }
  });

  test('add more than max routes to see if recent routes are stored properly', () async {
    Place startPlace = Place(
        latlng: const LatLng(51.511448, -0.116414),
        name: 'Bush House',
        placeId: "1",
        description: "the first route start description"
    );

    Place endPlace = Place(
        latlng: const LatLng(51.400520, -0.138209),
        name: "Maida Vale",
        placeId: "2",
        description: "the first route end description"
    );

    // no intermediary stops set
    List<Place> intermediates = [];

    Place startPlace1 = Place(
        latlng: const LatLng(51.345439, -0.115543),
        name: "St. John's Wood Road",
        placeId: "3",
        description: "the second route start description"
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

    List<Place> intermediates2 = [];

    Place startPlace3 = Place(
        latlng: const LatLng(51.485573, -0.119585),
        name: "Sardinia Street, Holborn",
        placeId: "7",
        description: "the fourth route start description"
    );

    Place endPlace3 = Place(
        latlng: const LatLng(49.999233, -0.123456),
        name: "Drury Lane, Covent Garden",
        placeId: "8",
        description: "the fourth route end description"
    );

    List<Place> intermediates3 = [];

    Place startPlace4 = Place(
        latlng: const LatLng(50.123456, -0.109834),
        name: "Arundel Street, Temple",
        placeId: "9",
        description: "the fifth route start description"
    );

    Place endPlace4 = Place(
        latlng: const LatLng(52.002232, -0.103432),
        name: "Kingsway, Covent Garden",
        placeId: "10",
        description: "the fifth route end description"
    );

    List<Place> intermediates4 = [];

    Place startPlace5 = Place(
        latlng: const LatLng(50.457345, -0.2342353),
        name: "Clifton Road, Maida Vale",
        placeId: "11",
        description: "the sixth route start description"
    );

    Place endPlace5 = Place(
        latlng: const LatLng(52.532667, -0.2343256),
        name: "Frampton Street, Paddington",
        placeId: "12",
        description: "the sixth route end description"
    );

    List<Place> intermediates5 = [];

    userSettings.saveRoute(startPlace, endPlace, intermediates);
    userSettings.saveRoute(startPlace1, endPlace1, intermediates1);
    userSettings.saveRoute(startPlace2, endPlace2, intermediates2);
    userSettings.saveRoute(startPlace3, endPlace3, intermediates3);
    userSettings.saveRoute(startPlace4, endPlace4, intermediates4);
    userSettings.saveRoute(startPlace5, endPlace5, intermediates5);

    final SharedPreferences prefs = await userSettings.getSharedPref();
    String? routesString = prefs.getString("recentRoutes");
    Map<String, dynamic> routeMap = json.decode(routesString!);

    // max of 5 recent routes stored despite saving 6 routes
    expect(routeMap.length, 5);
    expect(routeMap.containsKey("0"), true);
    expect(routeMap.containsKey("1"), true);
    expect(routeMap.containsKey("2"), true);
    expect(routeMap.containsKey("3"), true);
    expect(routeMap.containsKey("4"), true);
    expect(routeMap.containsKey("5"), false);

    // check correct recent routes are stored in order of recency and removes first recent route entry
    expect(routeMap["0"]["start"]["id"], "3");
    expect(routeMap["0"]["start"]["description"], "the second route start description");
    expect(routeMap["0"]["end"]["id"], "4");
    expect(routeMap["0"]["end"]["description"], "the second route end description");

    expect(routeMap["1"]["start"]["id"], "5");
    expect(routeMap["1"]["end"]["id"], "6");

    expect(routeMap["2"]["start"]["id"], "7");
    expect(routeMap["2"]["end"]["id"], "8");

    expect(routeMap["3"]["start"]["id"], "9");
    expect(routeMap["3"]["end"]["id"], "10");

    expect(routeMap["4"]["start"]["id"], "11");
    expect(routeMap["4"]["start"]["description"], "the sixth route start description");
    expect(routeMap["4"]["end"]["id"], "12");
    expect(routeMap["4"]["end"]["description"], "the sixth route end description");
  });

  test('test getNumberOfRoutes with a route with intermediate stops and a route without intermediate stops', () async {
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

    expect(await userSettings.getNumberOfRoutes(), 2);
  });

  test('test getNumberOfRoutes with when there are no routes', () async {
    expect(await userSettings.getNumberOfRoutes(), 0);
  });

  // test when 6 routes are added the number of routes remains at max 5
  test('add more than max routes to see if recent routes are stored properly', () async {
    Place startPlace = Place(
        latlng: const LatLng(51.511448, -0.116414),
        name: 'Bush House',
        placeId: "1",
        description: "the first route start description"
    );

    Place endPlace = Place(
        latlng: const LatLng(51.400520, -0.138209),
        name: "Maida Vale",
        placeId: "2",
        description: "the first route end description"
    );

    // no intermediary stops set
    List<Place> intermediates = [];

    Place startPlace1 = Place(
        latlng: const LatLng(51.345439, -0.115543),
        name: "St. John's Wood Road",
        placeId: "3",
        description: "the second route start description"
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

    List<Place> intermediates2 = [];

    Place startPlace3 = Place(
        latlng: const LatLng(51.485573, -0.119585),
        name: "Sardinia Street, Holborn",
        placeId: "7",
        description: "the fourth route start description"
    );

    Place endPlace3 = Place(
        latlng: const LatLng(49.999233, -0.123456),
        name: "Drury Lane, Covent Garden",
        placeId: "8",
        description: "the fourth route end description"
    );

    List<Place> intermediates3 = [];

    Place startPlace4 = Place(
        latlng: const LatLng(50.123456, -0.109834),
        name: "Arundel Street, Temple",
        placeId: "9",
        description: "the fifth route start description"
    );

    Place endPlace4 = Place(
        latlng: const LatLng(52.002232, -0.103432),
        name: "Kingsway, Covent Garden",
        placeId: "10",
        description: "the fifth route end description"
    );

    List<Place> intermediates4 = [];

    Place startPlace5 = Place(
        latlng: const LatLng(50.457345, -0.2342353),
        name: "Clifton Road, Maida Vale",
        placeId: "11",
        description: "the sixth route start description"
    );

    Place endPlace5 = Place(
        latlng: const LatLng(52.532667, -0.2343256),
        name: "Frampton Street, Paddington",
        placeId: "12",
        description: "the sixth route end description"
    );

    List<Place> intermediates5 = [];

    userSettings.saveRoute(startPlace, endPlace, intermediates);
    userSettings.saveRoute(startPlace1, endPlace1, intermediates1);
    userSettings.saveRoute(startPlace2, endPlace2, intermediates2);
    userSettings.saveRoute(startPlace3, endPlace3, intermediates3);
    userSettings.saveRoute(startPlace4, endPlace4, intermediates4);
    userSettings.saveRoute(startPlace5, endPlace5, intermediates5);

    expect(await userSettings.getNumberOfRoutes(), 5);
  });

  test('test getRecentRoute() gets correct recent route', () async {
    Place startPlace = Place(
        latlng: const LatLng(51.511448, -0.116414),
        name: 'Bush House',
        placeId: "1",
        description: "the start description"
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

    Pathway pathway1 = await userSettings.getRecentRoute(0);
    Pathway pathway2 = await userSettings.getRecentRoute(1);

    expect(pathway1.getStart().getStop().name, "Bush House");
    expect(pathway1.getStart().getStop().description, "the start description");
    expect(pathway1.getStart().getStop().placeId, "1");
    expect(pathway1.getStart().getStop().getLatLng(), const LatLng(51.511448, -0.116414));

    expect(pathway1.getDestination().getStop().name, "Maida Vale");
    expect(pathway1.getDestination().getStop().description, "the end description");
    expect(pathway1.getDestination().getStop().placeId, "2");
    expect(pathway1.getDestination().getStop().getLatLng(), const LatLng(51.400520, -0.138209));

    expect(pathway2.getStart().getStop().name, "St. John's Wood Road");
    expect(pathway2.getStart().getStop().description, "the second route first description");
    expect(pathway2.getStart().getStop().placeId, "3");
    expect(pathway2.getStart().getStop().getLatLng(), const LatLng(51.345439, -0.115543));

    expect(pathway2.getDestination().getStop().name, "Southampton Street, Strand");
    expect(pathway2.getDestination().getStop().description, "the second route end description");
    expect(pathway2.getDestination().getStop().placeId, "5");
    expect(pathway2.getDestination().getStop().getLatLng(), const LatLng(51.678345, -0.125942));

    expect(pathway2.getWaypoints().length, 1);
    for (var stop in pathway2.getWaypoints()) {
      expect(stop.getStop().description.contains("middle stop description"), true);
    }
  });

  test('test correct distance type is output based on what is passed in (km)', () async {
    final SharedPreferences prefs = await userSettings.getSharedPref();

    userSettings.setDistanceUnit("km");
    var distanceUnit = await userSettings.distanceUnit();
    expect(distanceUnit.runtimeType, DistanceType);
    String? distanceUnitString = prefs.getString("distanceUnit");
    expect(distanceUnitString, "km");
  });

  test('test correct distance type is output based on what is passed in (miles)', () async {
    final SharedPreferences prefs = await userSettings.getSharedPref();

    userSettings.setDistanceUnit("miles");
    var distanceUnit = await userSettings.distanceUnit();
    expect(distanceUnit.runtimeType, DistanceType);
    String? distanceUnitString = prefs.getString("distanceUnit");
    expect(distanceUnitString, "miles");
  });

  test('test default miles is output if null distance is input', () async {
    final SharedPreferences prefs = await userSettings.getSharedPref();

    await userSettings.setDistanceUnit(null);
    var distanceUnit = await userSettings.distanceUnit();
    expect(distanceUnit.runtimeType, DistanceType);
    String? distanceUnitString = prefs.getString("distanceUnit");
    expect(distanceUnitString, "miles");
  });

  test('test correct refresh rate is output after 60 is input', () async {
    final SharedPreferences prefs = await userSettings.getSharedPref();

    userSettings.setStationsRefreshRate(60);
    var refreshRate = await userSettings.stationsRefreshRate();
    expect(refreshRate.runtimeType, int);
    int? refreshRateInt = prefs.getInt("stationsRefreshRate");
    expect(refreshRateInt, 60);
  });

  test('test correct refresh rate is output after 30 is input', () async {
    final SharedPreferences prefs = await userSettings.getSharedPref();

    userSettings.setStationsRefreshRate(30);
    var refreshRate = await userSettings.stationsRefreshRate();
    expect(refreshRate.runtimeType, int);
    int? refreshRateInt = prefs.getInt("stationsRefreshRate");
    expect(refreshRateInt, 30);
  });

  test('test default refresh rate (30) is output if null rate is input', () async {
    final SharedPreferences prefs = await userSettings.getSharedPref();

    userSettings.setStationsRefreshRate(null);
    var refreshRate = await userSettings.stationsRefreshRate();
    expect(refreshRate.runtimeType, int);
    int? refreshRateInt = prefs.getInt("stationsRefreshRate");
    expect(refreshRateInt, 30);
  });

  test('test correct station range is output after 0.5 is input', () async {
    final SharedPreferences prefs = await userSettings.getSharedPref();

    userSettings.setNearbyStationsRange(0.5);
    var nearbyStations = await userSettings.nearbyStationsRange();
    expect(nearbyStations.runtimeType, double);
    double? nearbyStationDouble = prefs.getDouble("nearbyStationsRange");
    expect(nearbyStationDouble, 0.5);
  });

  test('test correct station range is output after 30.5 is input', () async {
    final SharedPreferences prefs = await userSettings.getSharedPref();

    userSettings.setNearbyStationsRange(30.5);
    var nearbyStations = await userSettings.nearbyStationsRange();
    expect(nearbyStations.runtimeType, double);
    double? nearbyStationDouble = prefs.getDouble("nearbyStationsRange");
    expect(nearbyStationDouble, 30.5);
  });

  test('test default station range (30.5) is output if null range is input', () async {
    final SharedPreferences prefs = await userSettings.getSharedPref();

    userSettings.setNearbyStationsRange(null);
    var nearbyStations = await userSettings.nearbyStationsRange();
    expect(nearbyStations.runtimeType, double);
    double? nearbyStationDouble = prefs.getDouble("nearbyStationsRange");
    expect(nearbyStationDouble, 30.5);
  });
}
