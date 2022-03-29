import 'dart:io';

import 'package:bicycle_trip_planner/widgets/general/buttons/EndRouteButton.dart';
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

  testWidgets("EndRouteButton is a button", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: EndRouteButton(onPressed: (){},))));

    final button = find.byType(EndRouteButton);

    expect(button, findsOneWidget);
  });

  testWidgets("EndRouteButton has end text", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: EndRouteButton(onPressed: (){},))));

    final text = find.text("End");

    expect(text, findsOneWidget);
  });
}