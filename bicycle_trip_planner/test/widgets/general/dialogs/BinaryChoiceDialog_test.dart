import 'dart:io';

import 'package:bicycle_trip_planner/widgets/general/dialogs/BinaryChoiceDialog.dart';
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

  testWidgets("Binary choice dialog contains two buttons", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: BinaryChoiceDialog())));

    // final endRouteButton = find.byKey(ValueKey('EndRouteButton'));
    //
    // await tester.tap(endRouteButton);
    // await tester.pump();

    // final binaryButton = find.byType(ElevatedButton);
    final button1 = find.descendant(of: find.byKey(ValueKey('Binary Button 1')), matching: find.byType(ElevatedButton));
    final button2 = find.descendant(of: find.byKey(ValueKey('Binary Button 2')), matching: find.byType(ElevatedButton));

    // expect(binaryButton, findsWidgets);
    expect(button1, findsOneWidget);
    expect(button2, findsOneWidget);

  });
}