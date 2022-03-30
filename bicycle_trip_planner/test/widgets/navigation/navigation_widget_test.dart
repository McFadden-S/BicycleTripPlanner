import 'dart:async';
import 'dart:io';

import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/managers/CameraManager.dart';
import 'package:bicycle_trip_planner/managers/LocationManager.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/widgets/general/dialogs/EndOfRouteDialog.dart';
import 'package:bicycle_trip_planner/widgets/general/other/CustomBottomSheet.dart';
import 'package:bicycle_trip_planner/widgets/general/other/DistanceETACard.dart';
import 'package:bicycle_trip_planner/widgets/navigation/Directions.dart';
import 'package:bicycle_trip_planner/widgets/navigation/Navigation.dart';
import 'package:bicycle_trip_planner/widgets/navigation/WalkOrCycleToggle.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:location/location.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'navigation_widget_test.mocks.dart';
import '../../setUp.dart';
import '../login/mock.dart';

@GenerateMocks([LocationManager, CameraManager])
void main() {
  var locationManager = MockLocationManager();
  var cameraManager = MockCameraManager();
  StreamController<LocationData> controller =
     StreamController<LocationData>.broadcast();
    Stream<LocationData> stream = controller.stream;
  when(locationManager.onUserLocationChange(5)).thenAnswer((realInvocation) => stream);

  setupFirebaseAuthMocks();

  setUpAll(() async {
    HttpOverrides.global = null;
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  });

  testWidgets("Navigation has countdown timer", (WidgetTester tester) async {

    await tester.runAsync(
            () async {
              RouteManager().setCostOptimised(true);
              await pumpWidget(tester, MaterialApp(home: Material(child: Navigation(locationManager: locationManager, cameraManager: cameraManager,))));
              final countdown = find.byKey(ValueKey('countdownCard'));
              expect(countdown, findsOneWidget);
            }
    );
  });

  testWidgets("Navigation has a SafeArea", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: Navigation(locationManager: locationManager, cameraManager: cameraManager,))));
    expect(find.byType(SafeArea), findsOneWidget);
  });

  testWidgets("Navigation has Walk/Bike Toggle Dialog", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: Navigation(locationManager: locationManager, cameraManager: cameraManager,))));

    expect(find.byType(WalkOrCycleToggle), findsOneWidget);
  });

  testWidgets("Navigation has bottom sheet", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: Navigation(locationManager: locationManager, cameraManager: cameraManager,))));

    final bottomSheet = find.byType(CustomBottomSheet);

    expect(bottomSheet, findsOneWidget);
  });

  testWidgets("Navigation has Directions", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: Navigation(locationManager: locationManager, cameraManager: cameraManager,))));

    final directions = find.byType(Directions);

    expect(directions, findsOneWidget);
  });

  testWidgets("Navigation has DistanceETACard", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: Navigation(locationManager: locationManager, cameraManager: cameraManager,))));

    final distanceETACard = find.byType(DistanceETACard);

    expect(distanceETACard, findsOneWidget);
  });

  testWidgets("Navigation has Walk or Cycle button", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: Navigation(locationManager: locationManager, cameraManager: cameraManager,))));

    final walkOrCycleButton = find.byType(WalkOrCycleToggle);

    expect(walkOrCycleButton, findsOneWidget);
  });

  testWidgets("Navigation has End of Route Dialog", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: Navigation(locationManager: locationManager, cameraManager: cameraManager,))));
    expect(find.byType(EndOfRouteDialog), findsOneWidget);
  });
 }
