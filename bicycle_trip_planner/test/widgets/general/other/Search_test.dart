import 'dart:io';

import 'package:bicycle_trip_planner/widgets/general/other/Search.dart';
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

  testWidgets("Search is a stack", (WidgetTester tester) async {
    TextEditingController searchController = TextEditingController();

    await pumpWidget(tester, MaterialApp(home: Material(child: Search(labelTextIn: 'Test', searchController: searchController,))));

    final widgetStack = find.byType(Stack);

    expect(widgetStack, findsOneWidget);
  });

  testWidgets("Search shows a search icon", (WidgetTester tester) async {
    TextEditingController searchController = TextEditingController();

    await pumpWidget(tester, MaterialApp(home: Material(child: Search(labelTextIn: 'Test', searchController: searchController,))));

    final icon = find.byIcon(Icons.search);

    expect(icon, findsOneWidget);
  });

  testWidgets("Search shows a clear icon", (WidgetTester tester) async {
    TextEditingController searchController = TextEditingController();

    await pumpWidget(tester, MaterialApp(home: Material(child: Search(labelTextIn: 'Test', searchController: searchController,))));

    final icon = find.byIcon(Icons.clear);

    expect(icon, findsOneWidget);
  });

  testWidgets("Search contains a Text widget", (WidgetTester tester) async {
    TextEditingController searchController = TextEditingController();

    await pumpWidget(tester, MaterialApp(home: Material(child: Search(labelTextIn: 'Test', searchController: searchController,))));

    final textWidget = find.byType(Text);

    expect(textWidget, findsWidgets);
  });
}