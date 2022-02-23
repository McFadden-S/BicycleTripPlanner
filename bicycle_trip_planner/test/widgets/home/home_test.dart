import 'dart:io';

import 'package:bicycle_trip_planner/widgets/general/MapWidget.dart';
import 'package:bicycle_trip_planner/widgets/general/Search.dart';
import 'package:bicycle_trip_planner/widgets/home/Home.dart';
import 'package:bicycle_trip_planner/widgets/home/HomeWidgets.dart';
import 'package:bicycle_trip_planner/widgets/home/StationBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../setUp.dart';


void main() {
  setUpAll(() async {
    HttpOverrides.global = null;
  });

  testWidgets("Home has a map", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: Home())));
    expect(find.byType(MapWidget), findsOneWidget);
  });

  testWidgets("HomeWidgets has a safeArea", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: HomeWidgets())));
    expect(find.byType(SafeArea), findsOneWidget);
  });

  testWidgets("HomeWidgets has a search box", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: HomeWidgets())));
    expect(find.widgetWithText(Search, 'Search'), findsOneWidget);
  });

  // TODO: this test fails for now
  // testWidgets("HomeWidgets has a user profile Image", (WidgetTester tester) async {
  //   await pumpWidget(tester, MaterialApp(home: Material(child: HomeWidgets())));
  //   expect(find.widgetWithImage(DecorationImage, AssetImage('assets/signup_image.png')), findsOneWidget);
  // });

  testWidgets("HomeWidgets has a bottom StationBar", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: HomeWidgets())));
    expect(find.byType(StationBar), findsOneWidget);
  });



}