import 'dart:io';

import 'package:bicycle_trip_planner/widgets/general/other/GroupSizeSelector.dart';
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

  testWidgets("GroupSizeSelector is a container", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: GroupSizeSelector())));

    final container = find.byType(Container);

    expect(container, findsWidgets);
  });

  testWidgets("GroupSizeSelector contains a DropdownButtonHideUnderline", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: GroupSizeSelector())));

    final dropdownButtonHideUnderline = find.byType(DropdownButtonHideUnderline);

    expect(dropdownButtonHideUnderline, findsOneWidget);
  });

  testWidgets("GroupSizeSelector shows a group icon", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: GroupSizeSelector())));

    final icon = find.byIcon(Icons.group);

    expect(icon, findsOneWidget);
  });

  testWidgets("GroupSizeSelector contains a Text widget", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: GroupSizeSelector())));

    final textWidget = find.byType(Text);

    expect(textWidget, findsWidgets);
  });
}