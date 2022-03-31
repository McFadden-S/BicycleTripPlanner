import 'dart:io';

import 'package:bicycle_trip_planner/managers/DirectionManager.dart';
import 'package:bicycle_trip_planner/models/steps.dart';
import 'package:bicycle_trip_planner/widgets/navigation/CurrentDirection.dart';
import 'package:bicycle_trip_planner/widgets/navigation/DirectionTile.dart';
import 'package:bicycle_trip_planner/widgets/navigation/Directions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../setUp.dart';

void main() {
  int duration = 1;
  int distance = 2;
  String instruction = "instruction";

  setUpAll(() async {
    HttpOverrides.global = null;
    DirectionManager().setDirections([
      Steps(
          distance: distance,
          duration: duration,
          instruction: instruction)
    ]);
  });

  testWidgets("Current diraction contains a SingleChildScrollView", (WidgetTester tester) async {
    var l = [
      Steps(
        distance: distance,
        duration: duration,
        instruction: instruction
      ),
      Steps(
          distance: distance + 1,
          duration: duration + 1,
          instruction: instruction
      ),
    ];
    DirectionManager().setDirections(l);
    await pumpWidget(tester, MaterialApp(home: Material(child:DirectionTile(index: 0, directionManager: DirectionManager(),))));

    expect(find.text(instruction), findsOneWidget);
  });

}
