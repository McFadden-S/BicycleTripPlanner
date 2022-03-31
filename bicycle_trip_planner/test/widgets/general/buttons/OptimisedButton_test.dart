import 'dart:io';

import 'package:bicycle_trip_planner/managers/DialogManager.dart';
import 'package:bicycle_trip_planner/widgets/general/buttons/CircleButton.dart';
import 'package:bicycle_trip_planner/widgets/general/buttons/OptimisedButton.dart';
import 'package:bicycle_trip_planner/widgets/routeplanning/RoutePlanning.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../setUp.dart';
import '../../../managers/firebase_mocks/firebase_auth_mocks.dart';

void main() {

  setupFirebaseAuthMocks();

  setUpAll(() async {
    HttpOverrides.global = null;
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  });

  testWidgets("OptimisedButton is a button", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: OptimisedButton())));

    final button = find.byType(OptimisedButton);

    expect(button, findsOneWidget);
  });

  testWidgets("OptimisedButton has an icon", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: OptimisedButton())));

    final icon = find.byIcon(Icons.alt_route);

    expect(icon, findsOneWidget);
  });

  testWidgets("OptimisedButton shows has an icon button", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: OptimisedButton())));

    final button = find.widgetWithIcon(CircleButton, Icons.alt_route);

    expect(button, findsOneWidget);
  });

  testWidgets("OptimisedButton shows a binary choice when pressed", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: RoutePlanning())));

    final button = find.byType(OptimisedButton);

    expect(button, findsOneWidget);

    await tester.tap(button);
    await tester.pump();

    expect(DialogManager.instance.ifShowingBinaryChoice(), true);
  });
}