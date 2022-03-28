import 'dart:io';

import 'package:bicycle_trip_planner/widgets/general/dialogs/SelectStationDialog.dart';
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

  testWidgets("Select station dialog contains a dialog", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: SelectStationDialog())));

    final dialog = find.byType(Dialog);

    expect(dialog, findsOneWidget);
  });

  testWidgets("Select station dialog contains four buttons", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: SelectStationDialog())));

    final text1 = find.text('Starting point');
    final text2 = find.text('Intermediate stop');
    final text3 = find.text('Destination');
    final text4 = find.text('Cancel');

    expect(text1, findsOneWidget);
    expect(text2, findsOneWidget);
    expect(text3, findsOneWidget);
    expect(text4, findsOneWidget);

  });
}