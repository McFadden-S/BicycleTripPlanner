import 'dart:io';

import 'package:bicycle_trip_planner/managers/DirectionManager.dart';
import 'package:bicycle_trip_planner/models/steps.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../setUp.dart';

import 'package:bicycle_trip_planner/widgets/navigation/CurrentDirection.dart';
import 'package:bicycle_trip_planner/widgets/navigation/Directions.dart';
import '../../managers/firebase_mocks/firebase_auth_mocks.dart';


void main() {
  setupFirebaseAuthMocks();
  setUpAll(() async {
    HttpOverrides.global = null;
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();


    int duration = 1;
    int distance = 2;
    String instruction = "instruction";
    DirectionManager().setDirections(
        [
          Steps(
              distance: distance,
              duration: duration,
              instruction: instruction
          ),
          Steps(
              distance: distance + 1,
              duration: duration + 1,
              instruction: instruction
          ),
        ]
    );
  });

  testWidgets('Directions contain expand less/more icons when needed', (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: Directions())));

    final expandToggle = find.byType(InkWell);

    expect(find.byType(ListView), findsNothing);

    await tester.tap(expandToggle);
    await tester.pump();

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('Directions expand after tap', (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: Directions())));

    var directions = find.byType(ListView);

    expect(directions, findsNothing);

    await tester.tap(find.byType(InkWell));
    await tester.pump();

    directions = find.byType(ListView);

    expect(directions, findsWidgets);
  });

  testWidgets('Directions contain current direction', (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: Directions())));

    final directions = find.byType(CurrentDirection);

    expect(directions, findsOneWidget);

    await tester.tap(find.byType(InkWell));
    await tester.pump();

    expect(directions, findsOneWidget);
  });
}
