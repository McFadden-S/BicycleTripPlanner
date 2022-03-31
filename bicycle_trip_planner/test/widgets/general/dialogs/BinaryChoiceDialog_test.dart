import 'dart:io';

import 'package:bicycle_trip_planner/managers/DialogManager.dart';
import 'package:bicycle_trip_planner/widgets/general/dialogs/BinaryChoiceDialog.dart';
import 'package:bicycle_trip_planner/widgets/navigation/Navigation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../setUp.dart';
import '../../../managers/firebase_mocks/firebase_auth_mocks.dart';

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

    final button1 = find.byKey(Key('Binary Button 1'));
    final button2 = find.byKey(Key('Binary Button 2'));

    expect(button1, findsOneWidget);
    expect(button2, findsOneWidget);
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

  testWidgets("Binary choice dialog button1 contains some text", (WidgetTester tester) async {
    DialogManager().setBinaryChoice("TEST DESCRIPTION", "option1", (){}, "option2", (){});
    await pumpWidget(tester, MaterialApp(home: Material(child: BinaryChoiceDialog())));
    final button1 = find.byKey(Key('Binary Button 1'));
    final text = find.descendant(of: button1, matching: find.byType(Text)).first;

    expect(text, findsOneWidget);
    Text s = text.evaluate().single.widget as Text;
    expect(s.data, DialogManager().getOptionOneText());
  });

  testWidgets("Binary choice dialog button2 contains some text", (WidgetTester tester) async {
    DialogManager().setBinaryChoice("TEST DESCRIPTION", "option1", (){}, "option2", (){});
    await pumpWidget(tester, MaterialApp(home: Material(child: BinaryChoiceDialog())));
    final button2 = find.byKey(Key('Binary Button 2'));
    final text = find.descendant(of: button2, matching: find.byType(Text)).first;

    expect(text, findsOneWidget);
    Text s = text.evaluate().single.widget as Text;
    expect(s.data, DialogManager().getOptionTwoText());
  });

  testWidgets("Binary choice dialog button1 on tap hides dialog",(WidgetTester tester) async {
    DialogManager().setBinaryChoice("TEST DESCRIPTION", "option1", (){}, "option2", (){});
    await pumpWidget(tester, MaterialApp(home: Material(child: BinaryChoiceDialog())));
    final button1 = find.byKey(Key('Binary Button 1'));
    var dialog = find.byType(Dialog);
    expect(dialog, findsOneWidget);

    await tester.tap(button1);

    await pumpWidget(tester, MaterialApp(home: Material(child: BinaryChoiceDialog())));
    dialog = find.byType(Dialog);
    expect(dialog, findsNothing);
  });

  testWidgets("Binary choice dialog button2 on tap hides dialog",(WidgetTester tester) async {
    DialogManager().setBinaryChoice("TEST DESCRIPTION", "option1", (){}, "option2", (){});
    await pumpWidget(tester, MaterialApp(home: Material(child: BinaryChoiceDialog())));
    final button2 = find.byKey(Key('Binary Button 2'));
    var dialog = find.byType(Dialog);
    expect(dialog, findsOneWidget);

    await tester.tap(button2);

    await pumpWidget(tester, MaterialApp(home: Material(child: BinaryChoiceDialog())));
    dialog = find.byType(Dialog);
    expect(dialog, findsNothing);
  });
}