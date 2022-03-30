import 'dart:io';

import 'package:bicycle_trip_planner/models/steps.dart';
import 'package:bicycle_trip_planner/widgets/navigation/CurrentDirection.dart';
import 'package:bicycle_trip_planner/widgets/navigation/DirectionTile.dart';
import 'package:bicycle_trip_planner/widgets/navigation/Directions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../setUp.dart';

void main() {
  int duration = 1;
  int distance = 2;
  String instruction = "instruction";
  setUpAll(() async {
    HttpOverrides.global = null;
  });

  testWidgets("Current direction contains a SingleChildScrollView", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: CurrentDirection(
      currentDirection: Steps(
          distance: distance,
          duration: duration,
          instruction: instruction)
    ))));

    final scrollview = find.byType(SingleChildScrollView);

    expect(scrollview, findsOneWidget);
  });

  testWidgets("Current direction contains distance", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: CurrentDirection(
        currentDirection: Steps(
            distance: distance,
            duration: duration,
            instruction: instruction)
    ))));

    expect(find.text("${distance} m"), findsOneWidget);
  });

  testWidgets("Current direction contains instruction", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: CurrentDirection(
        currentDirection: Steps(
            distance: distance,
            duration: duration,
            instruction: instruction)
    ))));

    expect(find.text(instruction), findsOneWidget);
  });
}
