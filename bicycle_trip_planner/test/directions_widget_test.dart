import 'dart:io';

import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/widgets/navigation/DirectionTile.dart';
import 'package:bicycle_trip_planner/widgets/navigation/Directions.dart';
import 'package:bicycle_trip_planner/widgets/navigation/Navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'setUp.dart';

void main() {
  setUpAll(() async {
    HttpOverrides.global = null;
  });

  testWidgets('Directions contain expand less/more icons when needed', (WidgetTester tester) async {
    await pumpWidget(tester, Directions());

    final expandLess = find.byIcon(Icons.expand_less);
    final expandMore = find.byIcon(Icons.expand_more);

    expect(expandLess, findsNothing);
    expect(expandMore, findsOneWidget);

    await tester.tap(expandMore);
    await tester.pump();

    expect(expandLess, findsOneWidget);
    expect(expandMore, findsNothing);
  });
}
