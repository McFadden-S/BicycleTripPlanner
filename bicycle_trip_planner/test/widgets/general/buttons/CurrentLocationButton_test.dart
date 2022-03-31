import 'dart:io';

import 'package:bicycle_trip_planner/widgets/general/buttons/CurrentLocationButton.dart';
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

  testWidgets("CurrentLocationButton is a button", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: CurrentLocationButton())));

    final button = find.byType(CurrentLocationButton);

    expect(button, findsOneWidget);
  });

  testWidgets("CurrentLocationButton has a location icon", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: CurrentLocationButton())));

    final icon = find.byIcon(Icons.location_searching);

    expect(icon, findsOneWidget);
  });
}