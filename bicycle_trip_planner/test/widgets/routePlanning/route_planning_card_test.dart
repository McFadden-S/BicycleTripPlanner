import 'dart:io';

import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/models/bounds.dart';
import 'package:bicycle_trip_planner/models/overview_polyline.dart';
import 'package:bicycle_trip_planner/models/place.dart';
import 'package:bicycle_trip_planner/models/route.dart' as r;
import 'package:bicycle_trip_planner/models/route_types.dart';
import 'package:bicycle_trip_planner/models/station.dart';
import 'package:bicycle_trip_planner/models/stop.dart';
import 'package:bicycle_trip_planner/widgets/routeplanning/RoutePlanningCard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bicycle_trip_planner/widgets/routeplanning/RoutePlanning.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../bloc/application_bloc_test.mocks.dart' as app;
import '../../managers/firebase_mocks/firebase_auth_mocks.dart';
import '../../setUp.dart';
import 'route_planning_card_test.mocks.dart';


@GenerateMocks([RouteManager])
void main() {
  setMocks();
  app.MockRouteManager appBlocRouteManager = getAppBloc().getRouteManager();
  app.MockStationManager appBlocStationManager = getAppBloc().getStationManager();
  app.MockDirectionsService appBlocDirectionService = getAppBloc().getDirectionService();

  final mockRouteManager = MockRouteManager();
  when(mockRouteManager.ifStartSet()).thenAnswer((realInvocation) => true);
  when(mockRouteManager.ifDestinationSet()).thenAnswer((realInvocation) => true);
  when(mockRouteManager.ifChanged()).thenAnswer((realInvocation) => true);
  when(mockRouteManager.getStart()).thenAnswer((realInvocation) => Stop());
  when(mockRouteManager.getDestination()).thenAnswer((realInvocation) => Stop());
  when(mockRouteManager.getGroupSize()).thenAnswer((realInvocation) => 1);
  when(mockRouteManager.ifCostOptimised()).thenAnswer((realInvocation) => false);
  when(mockRouteManager.getWaypoints()).thenAnswer((realInvocation) => []);
  when(mockRouteManager.clearRouteMarkers()).thenAnswer((realInvocation) => null);

  when(appBlocRouteManager.clearRouteMarkers()).thenAnswer((realInvocation) => null);
  final station = Station(id: 5, name: "name", lat: 153.01, lng: 128.01, bikes: 10, emptyDocks: 0, totalDocks: 10);
  when(appBlocStationManager.getPickupStationNear(LatLng(0.0, 0.0), 1)).thenAnswer((realInvocation) async=> station);
  when(appBlocRouteManager.getStart()).thenAnswer((realInvocation) => Stop());
  when(appBlocRouteManager.getDestination()).thenAnswer((realInvocation) => Stop());
  when(appBlocDirectionService.getRoutes('', '', RouteType.walk, [], true)).thenAnswer((realInvocation) async => r.Route(bounds: Bounds(northeast: {}, southwest: {}), legs: [], polyline: OverviewPolyline(points: []), routeType: RouteType.walk));
  when(appBlocRouteManager.ifOptimised()).thenAnswer((realInvocation) => true);
  when(appBlocDirectionService.getRoutes('', '', RouteType.bike, [], true)).thenAnswer((realInvocation) async => r.Route(bounds: Bounds(northeast: {}, southwest: {}), legs: [], polyline: OverviewPolyline(points: []), routeType: RouteType.bike));

  setupFirebaseAuthMocks();
  setUpAll(() async {
    HttpOverrides.global = null;
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  });

  testWidgets('Can tap recent route card', (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: RoutePlanningCard(loadRoute: true,routeManager: mockRouteManager,))));


  });

}