import 'dart:io';

import 'package:bicycle_trip_planner/widgets/general/buttons/CircleButton.dart';
import 'package:bicycle_trip_planner/widgets/general/buttons/OptimisedButton.dart';
import 'package:bicycle_trip_planner/widgets/general/other/DistanceETACard.dart';
import 'package:bicycle_trip_planner/widgets/routeplanning/IntermediateSearchList.dart';
import 'package:bicycle_trip_planner/widgets/routeplanning/RoutePlanning.dart';
import 'package:bicycle_trip_planner/widgets/routeplanning/RoutePlanningCard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../managers/firebase_mocks/firebase_auth_mocks.dart';
import '../../setUp.dart';

void main(){
  setupFirebaseAuthMocks();
  setUpAll(() async {
    HttpOverrides.global = null;
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  });

  testWidgets("RoutePlanning has a SafeArea", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: RoutePlanning())));
    expect(find.byType(SafeArea), findsOneWidget);
  });

  testWidgets("RoutePlanning has current location button", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: RoutePlanning())));
    expect(find.byKey(ValueKey("currentLocationButton")), findsOneWidget);
  });

  testWidgets("RoutePlanning has group button", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: RoutePlanning())));

    final groupButton = find.byKey(ValueKey("groupSizeSelector"));

    expect(groupButton, findsOneWidget);
  });

  testWidgets("RoutePlanning has two search bars in the RouteCard when first opened", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: RoutePlanning())));

    final startSearch = find.text('Starting Point');
    final destinationSearch = find.text('Destination');

    expect(startSearch, findsOneWidget);
    expect(destinationSearch, findsOneWidget);
  });

  testWidgets("RoutePlanning has DistanceETACard", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: RoutePlanning())));

    final distanceETACard = find.byType(DistanceETACard);

    expect(distanceETACard, findsOneWidget);
  });


  testWidgets("RoutePlanning has RouteCard", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: RoutePlanning())));

    final routeCard = find.byType(RoutePlanningCard);

    expect(routeCard, findsOneWidget);
  });

  testWidgets("When group button is clicked a dropdown appears", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: RoutePlanning())));

    final groupButton = find.byKey(ValueKey("groupSizeSelector"));

    expect(groupButton, findsOneWidget);

    await tester.tap(groupButton);
    await tester.pumpAndSettle();

    final dropdownItem = find.text('1').last;

    expect(dropdownItem, findsOneWidget);
  });




}