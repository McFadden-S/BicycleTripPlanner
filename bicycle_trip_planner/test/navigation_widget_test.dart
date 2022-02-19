import 'dart:io';

import 'package:bicycle_trip_planner/widgets/general/CircleButton.dart';
import 'package:bicycle_trip_planner/widgets/general/DistanceETACard.dart';
import 'package:bicycle_trip_planner/widgets/navigation/Directions.dart';
import 'package:bicycle_trip_planner/widgets/navigation/Navigation.dart';
import 'package:bicycle_trip_planner/widgets/navigation/WalkOrCycleToggle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'setUp.dart';

void main() {
  setUpAll(() async {
    HttpOverrides.global = null;
  });

  testWidgets("Navigation has cancel button", (WidgetTester tester) async {
    await pumpWidget(tester, Navigation());

    final cancelButton = find.widgetWithIcon(CircleButton, Icons.cancel_outlined);

    expect(cancelButton, findsOneWidget);
  });

  testWidgets("Navigation has zoom in/out button", (WidgetTester tester) async {
    await pumpWidget(tester, Navigation());

    final zoomOutButton = find.widgetWithIcon(CircleButton, Icons.zoom_out_map);
    final zoomInButton = find.widgetWithIcon(CircleButton, Icons.fullscreen_exit);

    expect(zoomOutButton, findsOneWidget);
    expect(zoomInButton, findsNothing);

    await tester.tap(zoomOutButton);
    await tester.pump();

    expect(zoomOutButton, findsNothing);
    expect(zoomInButton, findsOneWidget);
  });

  testWidgets("Navigation has current location button", (WidgetTester tester) async {
    await pumpWidget(tester, Navigation());

    final currentLocation = find.widgetWithIcon(CircleButton, Icons.location_on);

    expect(currentLocation, findsOneWidget);
  });

  testWidgets("Navigation has Directions", (WidgetTester tester) async {
    await pumpWidget(tester, Navigation());

    final directions = find.byType(Directions);

    expect(directions, findsOneWidget);
  });

  testWidgets("Navigation has DistanceETACard", (WidgetTester tester) async {
    await pumpWidget(tester, Navigation());

    final distanceETACard = find.byType(DistanceETACard);

    expect(distanceETACard, findsOneWidget);
  });

  testWidgets("Navigation has Walk or Cycle button", (WidgetTester tester) async {
    await pumpWidget(tester, Navigation());

    final walkOrCycleButton = find.byType(WalkOrCycleToggle);

    expect(walkOrCycleButton, findsOneWidget);
  });
}