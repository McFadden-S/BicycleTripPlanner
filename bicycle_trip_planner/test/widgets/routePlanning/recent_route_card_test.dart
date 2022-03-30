import 'dart:io';

import 'package:bicycle_trip_planner/widgets/routeplanning/RecentRouteCard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bicycle_trip_planner/widgets/routeplanning/RoutePlanning.dart';

import '../../managers/firebase_mocks/firebase_auth_mocks.dart';
import '../../setUp.dart';


void main() {
  setupFirebaseAuthMocks();
  setUpAll(() async {
    HttpOverrides.global = null;
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  });

  testWidgets('Recent Route Card has InkWell', (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: RecentRouteCard(index: 1))));
    expect(find.byType(InkWell), findsOneWidget);
  });

  testWidgets('Recent Route Card has SizedBox', (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: RecentRouteCard(index: 1))));
    expect(find.byType(SizedBox), findsWidgets);
  });

  testWidgets('Recent Route Card has Circle icons', (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: RecentRouteCard(index: 1))));
    expect(find.byType(Icon), findsWidgets);
  });
}