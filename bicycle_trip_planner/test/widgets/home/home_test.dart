import 'dart:io';

import 'package:bicycle_trip_planner/widgets/general/MapWidget.dart';
import 'package:bicycle_trip_planner/widgets/general/Search.dart';
import 'package:bicycle_trip_planner/widgets/home/Home.dart';
import 'package:bicycle_trip_planner/widgets/home/StationBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../setUp.dart';


void main() {
  setUpAll(() async {
    HttpOverrides.global = null;
  });

  // TODO:I don't think this should be in tis file (Ahmed)
  // testWidgets('Navigation has home', (WidgetTester tester) async {
  //   await pumpWidget(tester, MyApp());
  //   expect(find.text('Home'), findsOneWidget);
  // });

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



}