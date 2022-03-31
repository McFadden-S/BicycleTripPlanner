import 'dart:io';

import 'package:bicycle_trip_planner/managers/DialogManager.dart';
import 'package:bicycle_trip_planner/widgets/general/buttons/CircleButton.dart';
import 'package:bicycle_trip_planner/widgets/general/buttons/OptimiseCostButton.dart';
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

  testWidgets("OptimiseCostButton is a button", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: OptimiseCostButton())));

    final button = find.byType(OptimiseCostButton);

    expect(button, findsOneWidget);
  });

  testWidgets("OptimiseCostButton has an icon", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: OptimiseCostButton())));

    final icon = find.byIcon(Icons.money_off);

    expect(icon, findsOneWidget);
  });

  testWidgets("OptimiseCostButton has an icon button", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: OptimiseCostButton())));

    final button = find.widgetWithIcon(CircleButton, Icons.money_off);

    expect(button, findsOneWidget);
  });


  testWidgets("OptimiseCostButton shows a binary choice when pressed", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: OptimiseCostButton())));

    final button = find.widgetWithIcon(CircleButton, Icons.money_off);

    expect(button, findsOneWidget);

    await tester.tap(button);
    await tester.pump();

    expect(DialogManager.instance.ifShowingBinaryChoice(), true);
  });

}