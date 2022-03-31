import 'dart:io';

import 'package:bicycle_trip_planner/managers/DialogManager.dart';
import 'package:bicycle_trip_planner/widgets/general/buttons/EndRouteButton.dart';
import 'package:bicycle_trip_planner/widgets/navigation/Navigation.dart';
import 'package:bicycle_trip_planner/widgets/routeplanning/RoutePlanning.dart';
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

  bool clicked = false;

  bool testClicked() {
    return clicked;
  }

  void setClicked() {
    clicked = true;
  }

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

  testWidgets("EndRouteButton shows dialog when clicked", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: Navigation())));

    final button = find.byType(EndRouteButton);

    expect(button, findsOneWidget);

    await tester.tap(button);
    await tester.pump();

    expect(DialogManager.instance.ifShowingBinaryChoice(), true);
  });
}
