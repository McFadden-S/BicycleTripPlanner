import 'dart:io';

import 'package:bicycle_trip_planner/managers/DialogManager.dart';
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
    DialogManager().showBinaryChoice();
  });

  testWidgets("Binary choice dialog contains two buttons", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: BinaryChoiceDialog())));
    // await pumpWidget(tester, MaterialApp(home: Material(child: Navigation())));

    // final endRouteButton = find.byKey(ValueKey('EndRouteButton'));

    // expect(endRouteButton, findsOneWidget);
    //
    // await tester.tap(endRouteButton);
    // await tester.pumpAndSettle();

    // final binaryButton = find.byType(ElevatedButton);
    //final binaryChoiceDialog = find.byType(BinaryChoiceDialog);
    // final button1 = find.descendant(of: find.byKey(ValueKey('Binary Button 1'), skipOffstage: false), matching: find.byType(ElevatedButton));
    // final button2 = find.descendant(of: find.byKey(ValueKey('Binary Button 2'), skipOffstage: false), matching: find.byType(ElevatedButton));
    //final text = find.text('Would you like to end your route?');
    final button1 = find.byKey(Key('Binary Button 1'));
    final button2 = find.byKey(Key('Binary Button 2'));

    // var button1 = find.text('Yes', skipOffstage: false);
    // var button2 = find.text('No', skipOffstage: false);

    // expect(binaryButton, findsWidgets);
    //expect(binaryChoiceDialog, findsOneWidget);
    expect(button1, findsOneWidget);
    expect(button2, findsOneWidget);
    // expect(button1, findsOneWidget);
    // expect(button2, findsOneWidget);

  });

  testWidgets("Binary choice dialog is a dialog", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: BinaryChoiceDialog())));
    final dialog = find.byType(Dialog);
    expect(dialog, findsOneWidget);
  });

  testWidgets("Binary choice dialog contains some text", (WidgetTester tester) async {
    DialogManager().setBinaryChoice("TEST DESCRIPTION", "option1", (){}, "option2", (){});
    await pumpWidget(tester, MaterialApp(home: Material(child: BinaryChoiceDialog())));
    final text = find.byType(Text).first;

    expect(text, findsOneWidget);
    Text s = text.evaluate().single.widget as Text;
    expect(s.data, DialogManager().getChoicePrompt());
  });
}