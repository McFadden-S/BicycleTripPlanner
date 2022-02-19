import 'dart:io';

import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/widgets/general/CircleButton.dart';
import 'package:bicycle_trip_planner/widgets/general/DistanceETACard.dart';
import 'package:bicycle_trip_planner/widgets/navigation/Directions.dart';
import 'package:bicycle_trip_planner/widgets/navigation/Navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';


//@GenerateMocks([http.Client])
void main() {
  setUpAll(() {
    HttpOverrides.global = null;
  });

  testWidgets("Navigation has cancel button", (WidgetTester tester) async {
    //await tester.runAsync(() async {
      //await tester.pumpAndSettle(const Duration(seconds: 5));
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ListenableProvider(create: (context) => ApplicationBloc()),
          ],
          builder: (context, child) {
            return MaterialApp(home: Navigation());
          },
        ),
      );
      await tester.pumpAndSettle(const Duration(minutes: 1));

      final cancelButton = find.widgetWithIcon(CircleButton, Icons.cancel_outlined);

      expect(cancelButton, findsOneWidget);
    //});
    //await tester.pumpWidget(MaterialApp(home: Navigation()));
    //final client = MockClient();
  });

  testWidgets("Navigation has zoom in/out button", (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ListenableProvider(create: (context) => ApplicationBloc()),
        ],
        builder: (context, child) {
          return MaterialApp(home: Navigation());
        },
      ),
    );

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
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ListenableProvider(create: (context) => ApplicationBloc()),
        ],
        builder: (context, child) {
          return MaterialApp(home: Navigation());
        },
      ),
    );

    final currentLocation = find.widgetWithIcon(CircleButton, Icons.location_on);

    expect(currentLocation, findsOneWidget);
  });

  testWidgets("Navigation has DistanceETACard", (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ListenableProvider(create: (context) => ApplicationBloc()),
        ],
        builder: (context, child) {
          return MaterialApp(home: Navigation());
        },
      ),
    );

    final distanceETACard = find.byWidget(DistanceETACard());

    expect(distanceETACard, findsOneWidget);
  });


  testWidgets("Navigation has Directions", (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ListenableProvider(create: (context) => ApplicationBloc()),
        ],
        builder: (context, child) {
          return MaterialApp(home: Navigation());
        },
      ),
    );

    final directions = find.byWidget(Directions());

    expect(directions, findsOneWidget);
  });
}
