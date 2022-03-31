import 'dart:io';

import 'package:bicycle_trip_planner/managers/DialogManager.dart';
import 'package:bicycle_trip_planner/widgets/general/buttons/RoundedRectangleButton.dart';
import 'package:bicycle_trip_planner/widgets/general/buttons/WalkToFirstButton.dart';
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

  testWidgets("WalkToFirstButton is a button", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: WalkToFirstButton())));

    final button = find.byType(WalkToFirstButton);

    expect(button, findsOneWidget);
  });

  testWidgets("WalkToFirstButton has an icon", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: WalkToFirstButton())));

    final icon = find.byIcon(Icons.directions_walk);

    expect(icon, findsOneWidget);
  });

  testWidgets("WalkToFirstButton has an icon button", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: WalkToFirstButton())));

    final button = find.widgetWithIcon(WalkToFirstButton, Icons.directions_walk);

    expect(button, findsOneWidget);
  });

  testWidgets("WalkToFirstButton shows a binary choice when pressed", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: WalkToFirstButton())));

    final button = find.widgetWithIcon(WalkToFirstButton, Icons.directions_walk);

    expect(button, findsOneWidget);

    await tester.tap(button);
    await tester.pump();

    expect(DialogManager.instance.ifShowingBinaryChoice(), true);
  });
}