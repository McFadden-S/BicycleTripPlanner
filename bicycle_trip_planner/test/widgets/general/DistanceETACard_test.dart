import 'dart:io';

import 'package:bicycle_trip_planner/widgets/general/DistanceETACard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../setUp.dart';
import '../login/mock.dart';

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    HttpOverrides.global = null;
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  });

  testWidgets("DistanceETACard is a card", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: DistanceETACard())));

    final widgetCard = find.byType(Card);

    expect(widgetCard, findsOneWidget);
  });

  testWidgets("DistanceETACard shows a clock icon", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: DistanceETACard())));

    final clockIcon = find.byIcon(Icons.access_time_outlined);

    expect(clockIcon, findsOneWidget);
  });

  testWidgets("DistanceETACard contains multiple Text widgets", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: DistanceETACard())));

    final textWidget = find.byType(Text);

    expect(textWidget, findsWidgets);
  });
}