import 'dart:io';

import 'package:bicycle_trip_planner/widgets/general/buttons/ViewRouteButton.dart';
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

  testWidgets("ViewRouteButton is a button", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: ViewRouteButton())));

    final button = find.byType(ViewRouteButton);

    expect(button, findsOneWidget);
  });

  testWidgets("ViewRouteButton has an icon", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: ViewRouteButton())));

    final icon = find.byIcon(Icons.zoom_out_map);

    expect(icon, findsOneWidget);
  });
}