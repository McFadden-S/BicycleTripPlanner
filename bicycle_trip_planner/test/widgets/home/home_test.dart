import 'dart:io';

import 'package:bicycle_trip_planner/widgets/general/other/MapWidget.dart';
import 'package:bicycle_trip_planner/widgets/general/other/Search.dart';
import 'package:bicycle_trip_planner/widgets/general/dialogs/BinaryChoiceDialog.dart';
import 'package:bicycle_trip_planner/widgets/general/dialogs/SelectStationDialog.dart';
import 'package:bicycle_trip_planner/widgets/home/Home.dart';
import 'package:bicycle_trip_planner/widgets/home/HomeWidgets.dart';
import 'package:bicycle_trip_planner/widgets/home/StationBar.dart';
import 'package:bicycle_trip_planner/widgets/routeplanning/RoutePlanning.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../setUp.dart';
import '../login/mock.dart';


void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    HttpOverrides.global = null;
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  });

  testWidgets("Home root is a stack", (WidgetTester tester) async {
    await tester.runAsync( () async {
      await pumpWidget(tester, MaterialApp(home: Home()));
      expect(find.byType(Stack), findsWidgets);});
  });

  testWidgets("Home has a safeArea", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Home()));
    expect(find.byType(SafeArea), findsOneWidget);
  });

  testWidgets("Home has a search box", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Home()));
    expect(find.widgetWithText(Search, 'Search'), findsOneWidget);
  });

  testWidgets("Home has a map", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Home()));
    expect(find.byType(MapWidget), findsOneWidget);
  });

  testWidgets("Home has a bottom StationBar", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Home()));
    expect(find.byType(StationBar), findsOneWidget);
  });

  testWidgets("Home has AnimatedSwitcher", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Home()));
    expect(find.byType(AnimatedSwitcher), findsOneWidget);
  });

  testWidgets("Home has SelectStationDialog", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Home()));
    expect(find.byType(SelectStationDialog), findsOneWidget);
  });

  testWidgets("Home has BinaryChoiceDialog", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Home()));
    expect(find.byType(BinaryChoiceDialog), findsOneWidget);
  });


  testWidgets("Home displays homeWidgets initially", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Home()));
    expect(find.byType(HomeWidgets), findsOneWidget);
  });

  testWidgets("Home does not displays routePlanning widgets initially", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Home()));
    expect(find.byType(RoutePlanning), findsNothing);
  });

  testWidgets("Home does not displays navigation widgets widgets initially", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Home()));
    expect(find.byType(RoutePlanning), findsNothing);
  });





}