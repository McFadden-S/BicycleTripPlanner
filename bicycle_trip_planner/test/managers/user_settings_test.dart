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

  test('make sure a place can be saved', () async {
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
  // make sure savePlace cant save "My current location"
  // make sure savePlace can save place from emptiness
  // make sure savePlace can removes not so recent searches
}
