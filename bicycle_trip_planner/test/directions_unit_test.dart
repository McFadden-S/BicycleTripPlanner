import 'dart:io';

import 'package:bicycle_trip_planner/managers/DirectionManager.dart';
import 'package:bicycle_trip_planner/models/steps.dart';
import 'package:bicycle_trip_planner/widgets/navigation/Directions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'setUp.dart';

void main() {
  DirectionManager directionManager = DirectionManager();

  final leftIcon = find.byIcon(Icons.arrow_back);
  final rightIcon = find.byIcon(Icons.arrow_forward);
  final straightIcon = find.byIcon(Icons.arrow_upward);
  final roundaboutIcon = find.byIcon(Icons.data_usage_outlined);

  setUpAll(() async {
    HttpOverrides.global = null;
    directionManager.directions = [];
    directionManager.currentDirection = Steps(instruction: "Right", distance: 10, duration: 11);
  });


  testWidgets('Correct Icon is displayed for instruction', (WidgetTester tester) async {
    directionManager.directions = [Steps(instruction: "Turn right", distance: 10, duration: 10)];
    await pumpWidget(tester, Directions(directionManager: directionManager));

    expect(leftIcon, findsNothing);
    expect(rightIcon, findsOneWidget);
    expect(straightIcon, findsNothing);
    expect(roundaboutIcon, findsNothing);


    await tester.tap(find.byIcon(Icons.expand_more));
    await tester.pump();

    expect(leftIcon, findsOneWidget);
    expect(rightIcon, findsOneWidget);
    expect(straightIcon, findsNothing);
    expect(roundaboutIcon, findsNothing);
  });

}