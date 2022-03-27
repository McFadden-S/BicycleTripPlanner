import 'dart:io';

import 'package:bicycle_trip_planner/widgets/general/buttons/RoundedRectangleButton.dart';
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

  testWidgets("RoundedRectangleButton is a button", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: RoundedRectangleButton(buttonColor: Colors.black, iconIn: Icons.abc, onButtonClicked: (){}))));

    final button = find.byType(RoundedRectangleButton);

    expect(button, findsOneWidget);
  });

  testWidgets("RoundedRectangleButton has an icon", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: RoundedRectangleButton(buttonColor: Colors.black, iconIn: Icons.abc, onButtonClicked: (){}))));

    final icon = find.byIcon(Icons.abc);

    expect(icon, findsOneWidget);
  });
}