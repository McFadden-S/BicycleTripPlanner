import 'dart:io';

import 'package:bicycle_trip_planner/managers/CameraManager.dart';
import 'package:bicycle_trip_planner/managers/DialogManager.dart';
import 'package:bicycle_trip_planner/widgets/general/buttons/CurrentLocationButton.dart';
import 'package:bicycle_trip_planner/widgets/home/Home.dart';
import 'package:bicycle_trip_planner/widgets/home/HomeWidgets.dart';
import 'package:bicycle_trip_planner/widgets/routeplanning/RoutePlanning.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../bloc/application_bloc_test.mocks.dart';
import '../../../setUp.dart';
import '../../../managers/firebase_mocks/firebase_auth_mocks.dart';

void main() {

  setMocks();

  setupFirebaseAuthMocks();
  setMocks();

  setUpAll(() async {
    HttpOverrides.global = null;
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  });

  testWidgets("CurrentLocationButton is a button", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: CurrentLocationButton())));

    final button = find.byType(CurrentLocationButton);

    expect(button, findsOneWidget);
  });

  testWidgets("CurrentLocationButton has a location icon", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: CurrentLocationButton())));

    final icon = find.byIcon(Icons.location_searching);

    expect(icon, findsOneWidget);
  });

  testWidgets("CurrentLocationButton is an icon button", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: CurrentLocationButton())));

    final icon = find.widgetWithIcon(CurrentLocationButton, Icons.location_searching);

    expect(icon, findsOneWidget);
  });
}
