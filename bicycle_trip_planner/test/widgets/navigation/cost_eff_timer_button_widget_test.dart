import 'dart:io';

import 'package:bicycle_trip_planner/managers/DialogManager.dart';
import 'package:bicycle_trip_planner/managers/NavigationManager.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/models/bounds.dart';
import 'package:bicycle_trip_planner/models/legs.dart';
import 'package:bicycle_trip_planner/models/overview_polyline.dart';
import 'package:bicycle_trip_planner/models/route_types.dart';
import 'package:bicycle_trip_planner/models/steps.dart';
import 'package:bicycle_trip_planner/widgets/general/buttons/CircleButton.dart';
import 'package:bicycle_trip_planner/widgets/general/dialogs/BinaryChoiceDialog.dart';
import 'package:bicycle_trip_planner/widgets/navigation/CostEffTimerButton.dart';
import 'package:bicycle_trip_planner/widgets/navigation/CurrentDirection.dart';
import 'package:bicycle_trip_planner/widgets/navigation/DirectionTile.dart';
import 'package:bicycle_trip_planner/widgets/navigation/Directions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:timer_count_down/timer_controller.dart';

import '../../setUp.dart';
import 'package:bicycle_trip_planner/models/route.dart' as R;
void main() {
  NavigationManager navigationManager = NavigationManager();
  RouteManager routeManager = RouteManager();

  final bounds = Bounds(
      northeast: <String, dynamic>{}, southwest: <String, dynamic>{});
  const startLocation = LatLng(1, -1);
  const endLocation = LatLng(2, -2);
  final steps = Steps(instruction: "right", distance: 1, duration: 1);
  final polyline = OverviewPolyline(points: []);
  final legs = Legs(
      startLocation: startLocation,
      endLocation: endLocation,
      steps: [steps],
      distance: 1,
      duration: 1);
  final bikeRoute = R.Route(
      bounds: bounds,
      legs: [legs],
      polyline: polyline,
      routeType: RouteType.bike);

  final walkRoute = R.Route(
      bounds: bounds,
      legs: [legs],
      polyline: polyline,
      routeType: RouteType.walk);

  routeManager.setRoutes(walkRoute, bikeRoute, walkRoute);
  setUpAll(() async {
    HttpOverrides.global = null;
  });

  testWidgets("Current direction contains a CircleButton", (WidgetTester tester) async {
    routeManager.setCostOptimised(true);
    routeManager.setCurrentRoute(bikeRoute, false);
    final controller = CountdownController();
    await pumpWidget(tester, MaterialApp(home: Material(child: Scaffold(body: Stack(children: [CostEffTimerButton(ctdwnController: controller,), BinaryChoiceDialog()])))));

    final button = find.byType(CircleButton);

    expect(button, findsOneWidget);

    await tester.tap(button);
    DialogManager().showBinaryChoice();
    await tester.pump();
    final dialogButton = find.byKey(Key('Binary Button 1'));
    expect(dialogButton, findsOneWidget);
  });

  testWidgets("Current direction contains a CircleButton when no optimized", (WidgetTester tester) async {
    routeManager.setCostOptimised(false);
    routeManager.setCurrentRoute(bikeRoute, false);
    final controller = CountdownController();
    await pumpWidget(tester, MaterialApp(home: Material(child: Scaffold(body: Stack(children: [CostEffTimerButton(ctdwnController: controller,), BinaryChoiceDialog()])))));

    final button = find.byType(CircleButton);

    expect(button, findsOneWidget);

    await tester.tap(button);
    DialogManager().showBinaryChoice();
    await tester.pump();
    final dialogButton = find.byKey(Key('Binary Button 1'));
    expect(dialogButton, findsOneWidget);
  });

  testWidgets("Stop cost optimising after clicking twice", (WidgetTester tester) async {
    routeManager.setCostOptimised(true);
    routeManager.setCurrentRoute(bikeRoute, false);
    final controller = CountdownController();
    await pumpWidget(tester, MaterialApp(home: Material(child: Scaffold(body: Stack(children: [CostEffTimerButton(ctdwnController: controller,), BinaryChoiceDialog()])))));

    final button = find.byType(CircleButton);

    expect(button, findsOneWidget);

    await tester.tap(button);
    DialogManager().showBinaryChoice();
    await tester.pump();
    var dialogButton = find.byKey(Key('Binary Button 1'));
    expect(dialogButton, findsOneWidget);
    await tester.tap(dialogButton);
    await tester.pump();

    await tester.tap(button);
    DialogManager().showBinaryChoice();
    await tester.pump();
    dialogButton = find.byKey(Key('Binary Button 1'));

    expect(dialogButton, findsOneWidget);
    await tester.tap(dialogButton);
    await tester.pump();
  });


}
