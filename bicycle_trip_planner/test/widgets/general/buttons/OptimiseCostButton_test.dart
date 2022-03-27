import 'dart:io';

import 'package:bicycle_trip_planner/widgets/general/buttons/OptimiseCostButton.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../setUp.dart';
import '../../login/mock.dart';

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
}