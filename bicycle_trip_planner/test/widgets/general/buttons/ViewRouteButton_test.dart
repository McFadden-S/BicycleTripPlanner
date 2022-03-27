import 'dart:io';

import 'package:bicycle_trip_planner/widgets/general/buttons/ZoomOnUserButton.dart';
import 'package:bicycle_trip_planner/widgets/navigation/Navigation.dart';
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
    await pumpWidget(tester, MaterialApp(home: Material(child: ZoomOnUserButton())));

    final button = find.byType(ZoomOnUserButton);

    expect(button, findsOneWidget);
  });

  testWidgets("ViewRouteButton is clickable", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: ZoomOnUserButton())));

    final button = find.byType(ZoomOnUserButton);

    await tester.tap(button);
    await tester.pump();

    expect(button, findsOneWidget);
  });

  testWidgets("ViewRouteButton has an icon", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: ZoomOnUserButton())));

    final icon = find.byIcon(Icons.zoom_out_map);

    expect(icon, findsOneWidget);
  });
}