import 'dart:io';

import 'package:bicycle_trip_planner/widgets/general/other/Weather.dart';
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

  testWidgets("Weather is a card", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: Weather())));

    final widgetCard = find.byType(Card);

    expect(widgetCard, findsOneWidget);
  });
}