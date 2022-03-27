import 'dart:io';

import 'package:bicycle_trip_planner/widgets/general/buttons/EndRouteButton.dart';
import 'package:bicycle_trip_planner/widgets/general/other/CustomBottomSheet.dart';
import 'package:bicycle_trip_planner/widgets/general/other/DistanceETACard.dart';
import 'package:bicycle_trip_planner/widgets/navigation/Navigation.dart';
import 'package:bicycle_trip_planner/widgets/navigation/WalkOrCycleToggle.dart';
import 'package:bicycle_trip_planner/widgets/routeplanning/RoutePlanning.dart';
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

  testWidgets("CustomBottomSheet is an AnimatedContainer", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home:
    Material(child:
    CustomBottomSheet(child:
    Container(
      margin: EdgeInsets.only(bottom: 10, right: 5, left: 5),
      child: Row(
        children: [
          Expanded(child: DistanceETACard()),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: EndRouteButton(),
                ),
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: WalkOrCycleToggle(),
                    )),
              ],
            ),
          ),
        ],
      ),
    )))));

    final widgetCard = find.byType(AnimatedContainer);

    expect(widgetCard, findsOneWidget);
  });

  testWidgets("CustomBottomSheet shows an arrow icon", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: Navigation())));

    final icon = find.byIcon(Icons.keyboard_arrow_down);

    expect(icon, findsWidgets);
  });

  testWidgets("CustomBottomSheet shows a different arrow icon when tapped", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: Navigation())));

    final icon = find.byIcon(Icons.keyboard_arrow_up);

    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();

    expect(icon, findsOneWidget);
  });

  testWidgets("CustomBottomSheet shrinks when first tapped", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: Navigation())));

    final animatedContainer = find.byType(AnimatedContainer);
    final Size origSize = tester.getSize(animatedContainer);

    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();

    final Size shrunkSize = tester.getSize(animatedContainer);

    expect(shrunkSize.height, equals(origSize.height / 3));
  });

  testWidgets("CustomBottomSheet shrinks when first tapped, then expands when tapped again", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: Navigation())));

    final animatedContainer = find.byType(AnimatedContainer);
    final Size origSize = tester.getSize(animatedContainer);

    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();

    final Size shrunkSize = tester.getSize(animatedContainer);

    expect(shrunkSize.height, equals(origSize.height / 3));

    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();

    final Size nextSize = tester.getSize(animatedContainer);

    expect(nextSize.height, equals(origSize.height));
    expect(nextSize.height, equals(shrunkSize.height * 3));
  });

  testWidgets("CustomBottomSheet shrinks when first tapped", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: RoutePlanning())));

    final animatedContainer = find.byType(AnimatedContainer);
    final Size origSize = tester.getSize(animatedContainer);

    await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
    await tester.pumpAndSettle();

    final Size shrunkSize = tester.getSize(animatedContainer);

    expect(shrunkSize.height, equals(origSize.height / 3));
  });

  testWidgets("CustomBottomSheet shrinks when first tapped, then expands when tapped again", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: RoutePlanning())));

    final animatedContainer = find.byType(AnimatedContainer);
    final Size origSize = tester.getSize(animatedContainer);

    await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
    await tester.pumpAndSettle();

    final Size shrunkSize = tester.getSize(animatedContainer);

    expect(shrunkSize.height, equals(origSize.height / 3));

    await tester.tap(find.byIcon(Icons.keyboard_arrow_up));
    await tester.pumpAndSettle();

    final Size nextSize = tester.getSize(animatedContainer);

    expect(nextSize.height, equals(origSize.height));
    expect(nextSize.height, equals(shrunkSize.height * 3));
  });
}