import 'dart:io';

import 'package:bicycle_trip_planner/managers/DirectionManager.dart';
import 'package:bicycle_trip_planner/models/steps.dart';
import 'package:bicycle_trip_planner/widgets/navigation/DirectionTile.dart';
import 'package:bicycle_trip_planner/widgets/navigation/Directions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'setUp.dart';

void main() {
  DirectionManager directionManager = DirectionManager();

  final leftIcon = Icons.arrow_back;
  final rightIcon = Icons.arrow_forward;
  final straightIcon = Icons.arrow_upward;
  final roundaboutIcon = Icons.data_usage_outlined;

  setUpAll(() async {
    HttpOverrides.global = null;
    directionManager.directions = [];
    directionManager.currentDirection = Steps(instruction: "Right", distance: 10, duration: 11);
  });


  testWidgets('Correct Icon is displayed for turn left instruction', (WidgetTester tester) async {
    directionManager.directions = [Steps(instruction: "Turn left", distance: 10, duration: 10)];
    await pumpWidget(tester, Directions(directionManager: directionManager));

    expect(find.byIcon(leftIcon), findsNothing);
    expect(find.byIcon(rightIcon), findsOneWidget);
    expect(find.byIcon(straightIcon), findsNothing);
    expect(find.byIcon(roundaboutIcon), findsNothing);


    await tester.tap(find.byIcon(Icons.expand_more));
    await tester.pump();

    expect(find.widgetWithIcon(DirectionTile, leftIcon), findsOneWidget);
    expect(find.widgetWithIcon(DirectionTile, rightIcon), findsNothing);
    expect(find.widgetWithIcon(DirectionTile, straightIcon), findsNothing);
    expect(find.widgetWithIcon(DirectionTile, roundaboutIcon), findsNothing);
  });

  testWidgets('Correct Icon is displayed for continue straight instruction', (WidgetTester tester) async {
    directionManager.directions = [Steps(instruction: "Continue straight", distance: 10, duration: 10)];
    await pumpWidget(tester, Directions(directionManager: directionManager));

    expect(find.byIcon(leftIcon), findsNothing);
    expect(find.byIcon(rightIcon), findsOneWidget);
    expect(find.byIcon(straightIcon), findsNothing);
    expect(find.byIcon(roundaboutIcon), findsNothing);


    await tester.tap(find.byIcon(Icons.expand_more));
    await tester.pump();

    expect(find.widgetWithIcon(DirectionTile, leftIcon), findsNothing);
    expect(find.widgetWithIcon(DirectionTile, rightIcon), findsNothing);
    expect(find.widgetWithIcon(DirectionTile, straightIcon), findsOneWidget);
    expect(find.widgetWithIcon(DirectionTile, roundaboutIcon), findsNothing);
  });

  testWidgets('Correct Icon is displayed for turn right instruction', (WidgetTester tester) async {
    directionManager.directions = [Steps(instruction: "Turn right", distance: 10, duration: 10)];
    await pumpWidget(tester, Directions(directionManager: directionManager));

    expect(find.byIcon(leftIcon), findsNothing);
    expect(find.byIcon(rightIcon), findsOneWidget);
    expect(find.byIcon(straightIcon), findsNothing);
    expect(find.byIcon(roundaboutIcon), findsNothing);


    await tester.tap(find.byIcon(Icons.expand_more));
    await tester.pump();

    expect(find.widgetWithIcon(DirectionTile, leftIcon), findsNothing);
    expect(find.widgetWithIcon(DirectionTile, rightIcon), findsOneWidget);
    expect(find.widgetWithIcon(DirectionTile, straightIcon), findsNothing);
    expect(find.widgetWithIcon(DirectionTile, roundaboutIcon), findsNothing);
  });


  testWidgets('Correct Icon is displayed for roundabout instruction', (WidgetTester tester) async {
    directionManager.directions = [Steps(instruction: "Roundabout", distance: 10, duration: 10)];
    await pumpWidget(tester, Directions(directionManager: directionManager));

    expect(find.byIcon(leftIcon), findsNothing);
    expect(find.byIcon(rightIcon), findsOneWidget);
    expect(find.byIcon(straightIcon), findsNothing);
    expect(find.byIcon(roundaboutIcon), findsNothing);


    await tester.tap(find.byIcon(Icons.expand_more));
    await tester.pump();

    expect(find.widgetWithIcon(DirectionTile, leftIcon), findsNothing);
    expect(find.widgetWithIcon(DirectionTile, rightIcon), findsNothing);
    expect(find.widgetWithIcon(DirectionTile, straightIcon), findsNothing);
    expect(find.widgetWithIcon(DirectionTile, roundaboutIcon), findsOneWidget);
  });

  testWidgets('Only display 3 directions at a time', (WidgetTester tester) async {
    directionManager.directions = [
      Steps(instruction: "Next Direction", distance: 10, duration: 10),
      Steps(instruction: "Next Direction", distance: 10, duration: 10),
      Steps(instruction: "Next Direction", distance: 10, duration: 10),
      Steps(instruction: "Next Direction", distance: 10, duration: 10),
      Steps(instruction: "Next Direction", distance: 10, duration: 10),
      Steps(instruction: "Next Direction", distance: 10, duration: 10)
    ];
    await pumpWidget(tester, Directions(directionManager: directionManager));

    expect(find.byType(DirectionTile), findsNothing);

    await tester.tap(find.byIcon(Icons.expand_more));
    await tester.pump();

    expect(find.byType(DirectionTile), findsNWidgets(3));
  });

}