import 'dart:io';

import 'package:bicycle_trip_planner/widgets/general/buttons/OptimisedButton.dart';
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
}