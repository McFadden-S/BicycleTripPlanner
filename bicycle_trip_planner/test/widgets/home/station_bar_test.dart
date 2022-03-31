import 'dart:async';
import 'dart:io';
import 'package:bicycle_trip_planner/widgets/home/StationBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database_mocks/firebase_database_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../setUp.dart';
import 'station_bar_test.mocks.dart';

@GenerateMocks([FirebaseAuth, User])
void main() {
  setupFirebaseMocks();

  final mockFirebaseAuth = MockFirebaseAuth();
  final mockUser = MockUser();

  setUpAll(() async {
    HttpOverrides.global = null;
    await Firebase.initializeApp();
  });

  testWidgets("StationBar has a title 'Nearby Stations'", (WidgetTester tester) async {
    await tester.runAsync(
            () async {
              await pumpWidget(tester, MaterialApp(home: Material(child:StationBar())));
              expect(find.text('Nearby Stations'), findsWidgets);
        });
  });

  testWidgets("StationBar has an icon button 'firstPage'", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child:StationBar())));
    expect(find.widgetWithIcon(IconButton, Icons.first_page), findsWidgets);
  });

  testWidgets("StationBar has an icon button 'expanded station list'", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child:StationBar())));
    expect(find.widgetWithIcon(IconButton, Icons.menu), findsWidgets);
  });

  testWidgets("StationBar returns type container", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child:StationBar())));
    expect(find.byType(Container), findsWidgets);
  });

  testWidgets("StationBar returns type container", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child:StationBar())));
    final widget = find.byKey(ValueKey("first_page"));
    expect(widget, findsWidgets);
  });

  testWidgets("Tapping menu icon returns another widget", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child:StationBar())));
    final widget = find.byKey(ValueKey("menu"));
    expect(widget, findsWidgets);

    await tester.tap(widget);
    await tester.pump();
    expect(widget, findsWidgets);

    final widget2 = find.byType(StatefulBuilder);
    expect(widget2, findsWidgets);

    expect(find.byType(Expanded), findsWidgets);
    expect(find.byType(Container), findsWidgets);
  });

  testWidgets("StationBar returns type container", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child:StationBar())));
    expect(find.byType(Container), findsWidgets);
  });

  testWidgets("StationBar shows dropdown", (WidgetTester tester) async {
    StreamController<User> controller = StreamController<User>();
    Stream<User> stream = controller.stream;
    controller.add(mockUser);

    when(mockFirebaseAuth.authStateChanges()).thenAnswer((_) => stream);

    when(mockUser.isAnonymous).thenAnswer((_) => false);

    await pumpWidget(tester, MaterialApp(home: Material(child:StationBar(auth: mockFirebaseAuth))));
    expect(find.text("Nearby Stations"), findsWidgets);
  });
}