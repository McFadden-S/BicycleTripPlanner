import 'dart:io';

import 'package:bicycle_trip_planner/widgets/general/CircleButton.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../setUp.dart';
import '../login/mock.dart';

void main() {
  setupFirebaseAuthMocks();

  Function printTest(String string1) {
    String innerFunction(String string2) {
      return string1+string2;
    }
    return innerFunction;
  }

  setUpAll(() async {
    HttpOverrides.global = null;
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  });

  testWidgets("CircleButton has an icon", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: CircleButton(iconIn: Icons.abc, onButtonClicked: printTest("test");))));

    final widgetCard = find.byType(Card);

    expect(widgetCard, findsOneWidget);
  });
}