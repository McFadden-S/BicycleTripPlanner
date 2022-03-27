import 'dart:io';

import 'package:bicycle_trip_planner/widgets/general/buttons/EndRouteButton.dart';
import 'package:bicycle_trip_planner/widgets/general/other/CustomBottomSheet.dart';
import 'package:bicycle_trip_planner/widgets/general/other/DistanceETACard.dart';
import 'package:bicycle_trip_planner/widgets/navigation/Navigation.dart';
import 'package:bicycle_trip_planner/widgets/navigation/WalkOrCycleToggle.dart';
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
}