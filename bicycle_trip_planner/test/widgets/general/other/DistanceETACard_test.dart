import 'dart:io';

import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/widgets/general/other/DistanceETACard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../setUp.dart';
import '../../login/mock.dart';

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    RouteManager().setLoading(false);
    HttpOverrides.global = null;
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  });

  testWidgets("DistanceETACard is a card", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: DistanceETACard())));

    final widgetCard = find.byType(Container);

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

  testWidgets("DistanceETACard contains a Circular Progress Indicator", (WidgetTester tester) async {
    RouteManager().setLoading(true);
    await pumpWidget(tester, MaterialApp(home: Material(child: DistanceETACard())));

    final textWidget = find.byType(CircularProgressIndicator);

    expect(textWidget, findsOneWidget);
  });

  testWidgets("DistanceETACard contains a access_time icon", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: DistanceETACard())));
    final icon = tester.widget<Icon>(find.byKey(ValueKey("accessTime")));

    expect(icon, Icons.access_time_outlined);
  });

  testWidgets("DistanceETACard contains a pin_drop icon", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: DistanceETACard())));
    final icon = tester.widget<Icon>(find.byKey(ValueKey("pinDrop")));

    expect(icon, Icons.pin_drop);
  });

  testWidgets("DistanceETACard icons have correct colours", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: DistanceETACard())));
    final icon = tester.widget<Icon>(find.byKey(ValueKey("pinDrop")));
    final icon2 = tester.widget<Icon>(find.byKey(ValueKey("accessTime")));

    expect(icon.color,  ThemeStyle.secondaryIconColor);
    expect(icon2.color,  ThemeStyle.secondaryIconColor);
  });

  testWidgets("DistanceETACard text have correct colours", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: DistanceETACard())));
    final text = tester.widget<Text>(find.byKey(ValueKey("distance")));
    final text2 = tester.widget<Text>(find.byKey(ValueKey("duration")));

    expect(text.style?.color,  ThemeStyle.secondaryTextColor);
    expect(text2.style?.color,  ThemeStyle.secondaryTextColor);
  });

  testWidgets("DistanceETACard widgets are aligned towards at start", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: DistanceETACard())));
    final column = tester.widget<Column>(find.byType(Column));

    expect(column.crossAxisAlignment, CrossAxisAlignment.start);
  });

  testWidgets("DistanceETACard container has padding of 5 on all sides", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: DistanceETACard())));
    final container = tester.widget<Container>(find.byType(Container));

    expect(container.padding, const EdgeInsets.all(5.0));
  });

}