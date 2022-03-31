import 'dart:io';

import 'package:bicycle_trip_planner/widgets/general/buttons/CustomBackButton.dart';
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

  testWidgets("CustomBackButton is a button", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: RoutePlanning()));
    final BuildContext context = tester.element(find.byType(Container));
    
    await pumpWidget(tester, MaterialApp(home: Material(child: CustomBackButton(backTo: 'Navigation', context: context))));

    final backButton = find.byType(CustomBackButton);

    expect(backButton, findsOneWidget);
  });

  testWidgets("CircleButton has an icon", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: RoutePlanning()));
    final BuildContext context = tester.element(find.byType(Container));

    await pumpWidget(tester, MaterialApp(home: Material(child: CustomBackButton(backTo: 'Navigation', context: context))));

    final icon = find.byIcon(Icons.arrow_back);

    expect(icon, findsOneWidget);
  });
}