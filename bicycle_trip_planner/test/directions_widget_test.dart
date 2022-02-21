import 'dart:io';

import 'package:bicycle_trip_planner/managers/DirectionManager.dart';
import 'package:bicycle_trip_planner/models/steps.dart';
import 'package:bicycle_trip_planner/widgets/navigation/CurrentDirection.dart';
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
    directionManager.directions = [Steps(instruction: "Left", distance: 10, duration: 11)];
    directionManager.currentDirection = Steps(instruction: "Right", distance: 10, duration: 11);
  });

  testWidgets('Directions contain expand less/more icons when needed', (WidgetTester tester) async {
    await pumpWidget(tester, Directions(directionManager: directionManager,));

    final expandLess = find.byIcon(Icons.expand_less);
    final expandMore = find.byIcon(Icons.expand_more);

    expect(expandLess, findsNothing);
    expect(expandMore, findsOneWidget);

    await tester.tap(expandMore);
    await tester.pump();

    expect(expandLess, findsOneWidget);
    expect(expandMore, findsNothing);
  });

  testWidgets('Directions expand after tap if next directions exist', (WidgetTester tester) async {
    await pumpWidget(tester, Directions(directionManager: directionManager,));

    final directions = find.byType(DirectionTile);

    expect(directions, findsNothing);

    await tester.tap(find.byIcon(Icons.expand_more));
    await tester.pump();

    expect(directions, findsWidgets);
  });

  testWidgets('Directions do not expand after tap if no next directions exist', (WidgetTester tester) async {
    directionManager.directions = [];
    await pumpWidget(tester, Directions(directionManager: directionManager,));

    final directions = find.byType(DirectionTile);

    expect(directions, findsNothing);

    await tester.tap(find.byIcon(Icons.expand_more));
    await tester.pump();

    expect(directions, findsNothing);
  });

  testWidgets('Directions contain current direction', (WidgetTester tester) async {
    await pumpWidget(tester, Directions(directionManager: directionManager,));

    final directions = find.byType(CurrentDirection);

    expect(directions, findsOneWidget);

    await tester.tap(find.byIcon(Icons.expand_more));
    await tester.pump();

    expect(directions, findsOneWidget);
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
    List<Steps> steps = [];
    for (int i = 0; i < 7; i++) {
      steps.add(Steps(instruction: "Next Direction", distance: 10, duration: 10));
    }
    directionManager.directions = steps;

    await pumpWidget(tester, Directions(directionManager: directionManager));

    expect(find.byType(DirectionTile), findsNothing);

    await tester.tap(find.byIcon(Icons.expand_more));
    await tester.pump();

    expect(find.byType(DirectionTile), findsNWidgets(3));
  });

}
