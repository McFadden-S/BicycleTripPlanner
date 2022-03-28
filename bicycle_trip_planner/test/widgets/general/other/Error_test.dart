import 'dart:io';

import 'package:bicycle_trip_planner/widgets/general/other/Error.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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

  testWidgets("Error is a scaffold", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: Error())));

    final scaffold = find.byType(Scaffold);

    expect(scaffold, findsOneWidget);
  });

  testWidgets("Error contains a SpinKitFadingCube", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: Error())));

    final spinKitFadingCube = find.byType(SpinKitFadingCube);

    expect(spinKitFadingCube, findsOneWidget);
  });

  testWidgets("Error contains a text widget", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: Error())));

    final textWidget = find.byType(Text);

    expect(textWidget, findsOneWidget);
  });
}