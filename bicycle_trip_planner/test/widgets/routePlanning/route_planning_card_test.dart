import 'dart:io';

import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/models/place.dart';
import 'package:bicycle_trip_planner/models/stop.dart';
import 'package:bicycle_trip_planner/widgets/routeplanning/RoutePlanningCard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bicycle_trip_planner/widgets/routeplanning/RoutePlanning.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../managers/firebase_mocks/firebase_auth_mocks.dart';
import '../../setUp.dart';
import 'route_planning_card_test.mocks.dart';


@GenerateMocks([RouteManager])
void main() {
  final mockRouteManager = MockRouteManager();
  when(mockRouteManager.ifStartSet()).thenAnswer((realInvocation) => true);
  when(mockRouteManager.ifDestinationSet()).thenAnswer((realInvocation) => true);
  when(mockRouteManager.ifChanged()).thenAnswer((realInvocation) => true);
  when(mockRouteManager.getStart()).thenAnswer((realInvocation) => Stop());
  when(mockRouteManager.getDestination()).thenAnswer((realInvocation) => Stop());
  when(mockRouteManager.getGroupSize()).thenAnswer((realInvocation) => 1);
  when(mockRouteManager.ifCostOptimised()).thenAnswer((realInvocation) => true);
  when(mockRouteManager.getWaypoints()).thenAnswer((realInvocation) => []);
  when(mockRouteManager.clearRouteMarkers()).thenAnswer((realInvocation) => null);

  setupFirebaseAuthMocks();
  setUpAll(() async {
    HttpOverrides.global = null;
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  });

  testWidgets('Find', (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: RoutePlanningCard(loadRoute: true, routeManager: mockRouteManager,))));


  });
}