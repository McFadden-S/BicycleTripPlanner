import 'dart:io';
import 'package:bicycle_trip_planner/widgets/home/StationBar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../managers/firebase_mocks/firebase_auth_mocks.dart';
import '../../setUp.dart';

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    HttpOverrides.global = null;
    await Firebase.initializeApp();
  });

  testWidgets("StationBar has a title 'Nearby Stations'", (WidgetTester tester) async {
    await tester.runAsync(
            () async {
              await pumpWidget(tester, MaterialApp(home: Material(child:StationBar())));
              expect(find.text('Nearby Stations'), findsOneWidget);
        });
  });

  testWidgets("StationBar has an icon button 'firstPage'", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child:StationBar())));
    expect(find.widgetWithIcon(IconButton, Icons.first_page), findsOneWidget);
  });

  testWidgets("StationBar has an icon button 'expanded station list'", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child:StationBar())));
    expect(find.widgetWithIcon(IconButton, Icons.menu), findsOneWidget);
  });

  testWidgets("StationBar returns type container", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child:StationBar())));
    expect(find.byType(Container), findsOneWidget);
  });

  testWidgets("StationBar returns type container", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child:StationBar())));
    final widget = find.byKey(ValueKey("first_page"));
    expect(widget, findsOneWidget);
  });

  testWidgets("Tapping menu icon returns another widget", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child:StationBar())));
    final widget = find.byKey(ValueKey("menu"));
    expect(widget, findsOneWidget);

    await tester.tap(widget);
    await tester.pump();
    expect(widget, findsOneWidget);
  });

  testWidgets("StationBar returns type container", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child:StationBar())));
    expect(find.byType(Container), findsOneWidget);
  });
}