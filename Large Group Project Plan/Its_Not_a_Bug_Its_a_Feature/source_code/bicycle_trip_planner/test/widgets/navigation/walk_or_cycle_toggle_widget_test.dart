import 'dart:io';

import 'package:bicycle_trip_planner/managers/DialogManager.dart';
import 'package:bicycle_trip_planner/managers/DirectionManager.dart';
import 'package:bicycle_trip_planner/managers/NavigationManager.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/models/bounds.dart';
import 'package:bicycle_trip_planner/models/legs.dart';
import 'package:bicycle_trip_planner/models/overview_polyline.dart';
import 'package:bicycle_trip_planner/models/route_types.dart';
import 'package:bicycle_trip_planner/models/steps.dart';
import 'package:bicycle_trip_planner/widgets/general/dialogs/BinaryChoiceDialog.dart';
import 'package:bicycle_trip_planner/widgets/home/Home.dart';
import 'package:bicycle_trip_planner/widgets/navigation/Navigation.dart';
import 'package:bicycle_trip_planner/widgets/navigation/WalkOrCycleToggle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bicycle_trip_planner/models/route.dart' as R;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../setUp.dart';

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

  testWidgets('WalkOrCycleToggle has a button', (WidgetTester tester) async {
    await pumpWidget(tester, WalkOrCycleToggle());

    final button = find.byType(ElevatedButton);

    expect(button, findsOneWidget);
  });

  testWidgets('WalkOrCycleToggle has a walk icon', (WidgetTester tester) async {
    await pumpWidget(tester, WalkOrCycleToggle());

    final walkIcon = find.byIcon(Icons.directions_walk);

    expect(walkIcon, findsOneWidget);
  });

  testWidgets('WalkOrCycleToggle has a bike icon', (WidgetTester tester) async {
    await pumpWidget(tester, WalkOrCycleToggle());

    final bikeIcon = find.byIcon(Icons.directions_bike);

    expect(bikeIcon, findsOneWidget);
  });

  testWidgets('When isCycling is false walkIcon is red', (WidgetTester tester) async {

    await pumpWidget(tester, WalkOrCycleToggle());

    final walkIcon = tester.widget(find.byIcon(Icons.directions_walk));
    final bikeIcon = tester.widget(find.byIcon(Icons.directions_bike));

    expect((walkIcon as Icon).color, Colors.red);
    expect((bikeIcon as Icon).color, Colors.black26);
  });

  testWidgets('When isCycling is true bikeIcon is red', (WidgetTester tester) async {
    routeManager.setCurrentRoute(bikeRoute, false);
    await pumpWidget(tester, WalkOrCycleToggle());

    final walkIcon = tester.widget(find.byIcon(Icons.directions_walk));
    final bikeIcon = tester.widget(find.byIcon(Icons.directions_bike));

    expect((walkIcon as Icon).color, Colors.black26);
    expect((bikeIcon as Icon).color, Colors.red);
  });

  // Cannot test because of error caused by CameraManager
  /*testWidgets('WalkOrCycleToggle button toggles isCycling', (WidgetTester tester) async {
    routeManager.setCurrentRoute(bikeRoute, false);

    await pumpWidget(tester, MaterialApp(home: Material(child: Scaffold(body: Stack(children: [BinaryChoiceDialog(), WalkOrCycleToggle()])))));

    expect(routeManager.getCurrentRoute().routeType, RouteType.bike);

    final toggleCycleButton = find.byType(ElevatedButton);
    await tester.tap(toggleCycleButton);
    DialogManager().showBinaryChoice();
    await tester.pump();
    final dialogButton = find.byKey(Key('Binary Button 1'));
    await tester.tap(dialogButton);
    expect(routeManager.getCurrentRoute().routeType, RouteType.walk);
  });*/
}
