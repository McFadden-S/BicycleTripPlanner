import 'dart:io';

import 'package:bicycle_trip_planner/widgets/general/buttons/CircleButton.dart';
import 'package:bicycle_trip_planner/widgets/general/other/DistanceETACard.dart';
import 'package:bicycle_trip_planner/widgets/general/other/MapWidget.dart';
import 'package:bicycle_trip_planner/widgets/navigation/CustomCountdown.dart';
import 'package:bicycle_trip_planner/widgets/navigation/Directions.dart';
import 'package:bicycle_trip_planner/widgets/navigation/Navigation.dart';
import 'package:bicycle_trip_planner/widgets/navigation/WalkOrCycleToggle.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'setUp.dart';
import 'widgets/login/mock.dart';


void main() {

  setupFirebaseAuthMocks();

  setUpAll(() async {
    HttpOverrides.global = null;
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  });

  testWidgets("Navigation has countdown timer", (WidgetTester tester) async {
    await tester.runAsync(
            () async {
              await pumpWidget(tester, MaterialApp(home: Material(child: Navigation())));
              final countdown = find.byType(Countdown);
              expect(countdown, findsOneWidget);
            }
    );
  });

  testWidgets("Navigation has a SafeArea", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: Navigation())));
    expect(find.byType(SafeArea), findsOneWidget);
  });

  testWidgets("Navigation has Walk/Bike Toggle Dialog", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: Navigation())));

    expect(find.byType(WalkBikeToggleDialog), findsOneWidget);
  });

  testWidgets("Navigation has bottom sheet", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: Navigation())));

    final bottomSheet = find.byType(CustomBottomSheet);

    expect(bottomSheet, findsOneWidget);
  });


  testWidgets("Navigation has current location button", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: Navigation())));

    expect(find.byType(CurrentLocationButton), findsOneWidget);
  });

  testWidgets("Navigation has Directions", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: Navigation())));

    final directions = find.byType(Directions);

    expect(directions, findsOneWidget);
  });

  testWidgets("Navigation has DistanceETACard", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: Navigation())));

    final distanceETACard = find.byType(DistanceETACard);

    expect(distanceETACard, findsOneWidget);
  });

  testWidgets("Navigation has Walk or Cycle button", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: Navigation())));

    final walkOrCycleButton = find.byType(WalkOrCycleToggle);

    expect(walkOrCycleButton, findsOneWidget);
  });

  testWidgets("Navigation has End of Route Dialog", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: Navigation())));

  testWidgets("Navigation has countdown timer", (WidgetTester tester) async {
    await pumpWidget(tester, Navigation());

    final walkOrCycleButton = find.byType(CustomCountdown);

    expect(walkOrCycleButton, findsOneWidget);
  });
}
