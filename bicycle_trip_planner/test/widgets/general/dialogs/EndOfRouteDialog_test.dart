import 'dart:io';

import 'package:bicycle_trip_planner/managers/DialogManager.dart';
import 'package:bicycle_trip_planner/widgets/general/dialogs/EndOfRouteDialog.dart';
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
    DialogManager().showEndOfRouteDialog();
  });

  testWidgets(
      "Select station dialog contains a dialog", (WidgetTester tester) async {
    await pumpWidget(
        tester, MaterialApp(home: Material(child: EndOfRouteDialog())));

    final dialog = find.byType(Dialog);

    expect(dialog, findsOneWidget);
  });

  testWidgets("Binary choice dialog contains one button", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: EndOfRouteDialog())));

    final button = find.byType(ElevatedButton);
    expect(button, findsOneWidget);
  });

  testWidgets("Binary choice dialog buttons contains correct text", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: EndOfRouteDialog())));

    final button = find.byType(ElevatedButton);
    final text = find.descendant(of: button, matching: find.byType(Text)).first;
    expect(button, findsOneWidget);
    Text s = text.evaluate().single.widget as Text;
    expect(s.data, DialogManager().getOkButtonText());
  });

  testWidgets("Binary choice dialog contains some text", (WidgetTester tester) async {
    DialogManager().setBinaryChoice("TEST DESCRIPTION", "option1", (){}, "option2", (){});
    await pumpWidget(tester, MaterialApp(home: Material(child: EndOfRouteDialog())));
    final text = find.byType(Text).first;

    expect(text, findsOneWidget);
    Text s = text.evaluate().single.widget as Text;
    expect(s.data, DialogManager().getChoicePrompt());
  });
}