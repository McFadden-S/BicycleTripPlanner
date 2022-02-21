import 'dart:io';

import 'package:bicycle_trip_planner/widgets/navigation/CurrentDirection.dart';
import 'package:bicycle_trip_planner/widgets/navigation/DirectionTile.dart';
import 'package:bicycle_trip_planner/widgets/navigation/Directions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'setUp.dart';

void main() {
  setUpAll(() async {
    HttpOverrides.global = null;
  });

  testWidgets('Directions contain expand less/more icons when needed', (WidgetTester tester) async {
    await pumpWidget(tester, Directions());

    final expandLess = find.byIcon(Icons.expand_less);
    final expandMore = find.byIcon(Icons.expand_more);

    expect(expandLess, findsNothing);
    expect(expandMore, findsOneWidget);

    await tester.tap(expandMore);
    await tester.pump();

    expect(expandLess, findsOneWidget);
    expect(expandMore, findsNothing);
  });

  testWidgets('Directions expand after tap', (WidgetTester tester) async {
    await pumpWidget(tester, Directions());

    final directions = find.byType(DirectionTile);

    expect(directions, findsNothing);

    await tester.tap(find.byIcon(Icons.expand_more));
    await tester.pump();

    expect(directions, findsWidgets);
  });

  testWidgets('Directions contain current direction', (WidgetTester tester) async {
    await pumpWidget(tester, Directions());

    final directions = find.byType(CurrentDirection);

    expect(directions, findsOneWidget);

    await tester.tap(find.byIcon(Icons.expand_more));
    await tester.pump();

    expect(directions, findsOneWidget);
  });
}
