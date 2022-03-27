import 'dart:io';

import 'package:bicycle_trip_planner/widgets/general/buttons/WalkToFirstButton.dart';
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
}