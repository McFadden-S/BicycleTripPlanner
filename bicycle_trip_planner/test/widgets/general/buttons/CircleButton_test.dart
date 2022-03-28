import 'dart:io';

import 'package:bicycle_trip_planner/widgets/general/buttons/CircleButton.dart';
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

  testWidgets("CircleButton is a button", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: CircleButton(iconIn: Icons.abc, onButtonClicked: (){}))));

    final button = find.byType(CircleButton);

    expect(button, findsOneWidget);
  });

  testWidgets("CircleButton has an icon", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: CircleButton(iconIn: Icons.abc, onButtonClicked: (){}))));

    final icon = find.byIcon(Icons.abc);

    expect(icon, findsOneWidget);
  });
}