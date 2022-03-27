import 'dart:io';

import 'package:bicycle_trip_planner/widgets/general/dialogs/BinaryChoiceDialog.dart';
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

  testWidgets("binary choice dialog contains two buttons", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: BinaryChoiceDialog())));

    final dialog = find.byKey(ValueKey("binaryChoiceDialog"));

    expect(dialog, findsWidgets);
  });
}