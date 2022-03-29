import 'dart:io';
import 'package:bicycle_trip_planner/managers/Helper.dart';
import 'package:bicycle_trip_planner/models/pathway.dart';
import 'package:bicycle_trip_planner/widgets/home/FavouriteRouteCard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../managers/firebase_mocks/firebase_auth_mocks.dart';
import '../../setUp.dart';

void main() {
  setupFirebaseAuthMocks();

  String key = "1";

  // creating mock pathway
  Map<String, dynamic> startMap = {
    "name": "Bush House",
    "description": "the start description",
    "id": "1",
    "lng": -0.116414,
    "lat": 51.511448
  };

  Map<String, dynamic> middleStopMap1 = {
    "name": "St. John's Wood Road",
    "description": "the first middle stop description",
    "id": "3",
    "lng": -0.115543,
    "lat": 51.345439
  };

  Map<String, dynamic> middleStopMap2 = {
    "name": "Caven Street, Strand",
    "description": "the second middle stop description",
    "id": "4",
    "lng": -0.125942,
    "lat": 51.678345
  };

  Map<String, dynamic> endMap = {
    "name": "Maida Vale",
    "description": "the end description",
    "id": "2",
    "lng": -0.138209,
    "lat": 51.400520
  };

  Map<String, dynamic> pathwayMap = {
    "start": startMap,
    "stops": [middleStopMap1, middleStopMap2],
    "end": endMap
  };

  // Converting the maps above to create a pathway
  Pathway valueRoute = Helper.mapToPathway(pathwayMap);

  Function(String)?  deleteRoute;

  setUpAll(() async {
    HttpOverrides.global = null;
    await Firebase.initializeApp();
  });

  testWidgets("Favourite route card widget exists", (WidgetTester tester) async {
    await tester.runAsync(
            () async {
              await pumpWidget(tester, MaterialApp(home: Material(child:FavouriteRouteCard(keyRoute: key, valueRoute: valueRoute, deleteRoute: deleteRoute,))));
              expect(find.byType(InkWell), findsWidgets);
            });
  });

  testWidgets("Favourite route card has an icon place_outlines", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child:FavouriteRouteCard(keyRoute: key, valueRoute: valueRoute, deleteRoute: deleteRoute,))));
    expect(find.byIcon(Icons.place_outlined), findsWidgets);
  });

  testWidgets("Favourite route card gets the correct route description for start stop", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child:FavouriteRouteCard(keyRoute: key, valueRoute: valueRoute, deleteRoute: deleteRoute,))));
    expect(find.text("\t\t${valueRoute.getStart().getStop().description}"), findsWidgets);
    // test it shows same description as start of pathway
    expect(valueRoute.getDestination().getStop().description, "the end description");
  });

  testWidgets("Favourite route card correctly gets icon circle", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child:FavouriteRouteCard(keyRoute: key, valueRoute: valueRoute, deleteRoute: deleteRoute,))));
    expect(find.byIcon(Icons.circle), findsWidgets);
  });

  testWidgets("Favourite route card gets the correct route description for intermediate stops", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child:FavouriteRouteCard(keyRoute: key, valueRoute: valueRoute, deleteRoute: deleteRoute,))));
    expect(find.text("\t\t${valueRoute.getWaypoints().map((e) => e.getStop().description).join(", ")}"), findsWidgets);

    // stop must be an intermediate stop
    for (var stop in valueRoute.getWaypoints()) {
      expect(stop.getStop().description.contains("stop description"), true);
    }
  });

  testWidgets("Favourite route card correctly displays place icon", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child:FavouriteRouteCard(keyRoute: key, valueRoute: valueRoute, deleteRoute: deleteRoute,))));
    expect(find.byIcon(Icons.place), findsWidgets);
  });

  testWidgets("Favourite route card gets the correct route description for destination stop", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child:FavouriteRouteCard(keyRoute: key, valueRoute: valueRoute, deleteRoute: deleteRoute,))));
    expect(find.text("\t\t${valueRoute.getDestination().getStop().description}"), findsWidgets);
    // test it shows same description as end of pathway

    expect(valueRoute.getDestination().getStop().description, "the end description");
  });

  testWidgets("Favourite route card correctly displays delete_forever icon", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child:FavouriteRouteCard(keyRoute: key, valueRoute: valueRoute, deleteRoute: deleteRoute,))));
    expect(find.byIcon(Icons.delete_forever), findsWidgets);
  });

}