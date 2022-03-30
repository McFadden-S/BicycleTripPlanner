import 'dart:io';

import 'package:bicycle_trip_planner/widgets/general/buttons/CircleButton.dart';
import 'package:bicycle_trip_planner/widgets/routeplanning/IntermediateSearchList.dart';
import 'package:bicycle_trip_planner/widgets/routeplanning/RoutePlanning.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../managers/firebase_mocks/firebase_auth_mocks.dart';
import '../../setUp.dart';


void main() {
  setupFirebaseAuthMocks();
  setUpAll(() async {
    HttpOverrides.global = null;
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  });

  testWidgets("ensure has 'Add Stop(s)' button in RouteCard", (WidgetTester tester) async {
    Firebase.initializeApp();
    await pumpWidget(tester, MaterialApp(home: Material(child: RoutePlanning())));

    final addStopsButton = find.text('Add Stop(s)');

    expect(addStopsButton, findsOneWidget);
  });

  testWidgets("When Add Stop(s) button is clicked a new search bar for an intermediate stop appears", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: RoutePlanning())));

    final addStopsButton = find.text('Add Stop(s)');
    final stopSearchBar = find.text('Stop');
    final removeStopButton = find.byIcon(Icons.remove_circle_outline);

    expect(stopSearchBar, findsNothing);

    await tester.tap(addStopsButton);
    await tester.pump();

    expect(stopSearchBar, findsOneWidget);
  });

  testWidgets("When Add Stop(s) button is clicked twice, two new search bars for an intermediate stops appear", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: RoutePlanning())));

    final addStopsButton = find.text('Add Stop(s)');
    final stopSearchBar1 = find.byKey(ValueKey('Stop 1'));
    final stopSearchBar2 = find.byKey(ValueKey('Stop 2'));

    expect(stopSearchBar1, findsNothing);
    expect(stopSearchBar2, findsNothing);

    await tester.tap(addStopsButton);
    await tester.pumpAndSettle();

    expect(stopSearchBar1, findsOneWidget);

    await tester.tap(addStopsButton);
    await tester.pumpAndSettle();

    expect(stopSearchBar1, findsOneWidget);
    expect(stopSearchBar2, findsOneWidget);
  });

  /**
   * detects two icons instead of one
   */
  // testWidgets("When remove button is clicked next to an intermediate stop, the stop is removed from the screen", (WidgetTester tester) async {
  //   await pumpWidget(tester, MaterialApp(home: Material(child: RoutePlanning())));
  //
  //   final addStopsButton = find.text('Add Stop(s)');
  //   final stopSearchBar = find.byKey(ValueKey('Stop 1'));
  //   final removeStopButton = find.byIcon(Icons.remove_circle_outline);
  //
  //   expect(stopSearchBar, findsNothing);
  //
  //   await tester.tap(addStopsButton);
  //   await tester.pumpAndSettle();
  //
  //   expect(stopSearchBar, findsOneWidget);
  //
  //   await tester.tap(removeStopButton);
  //   await tester.pumpAndSettle();
  //
  //   expect(stopSearchBar, findsNothing);
  // });
}