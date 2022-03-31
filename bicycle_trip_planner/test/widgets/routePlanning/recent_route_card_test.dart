import 'dart:io';

import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/managers/MarkerManager.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/managers/UserSettings.dart';
import 'package:bicycle_trip_planner/models/pathway.dart';
import 'package:bicycle_trip_planner/models/place.dart';
import 'package:bicycle_trip_planner/models/stop.dart';
import 'package:bicycle_trip_planner/widgets/routeplanning/RecentRouteCard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bicycle_trip_planner/widgets/routeplanning/RoutePlanning.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';


import '../../managers/firebase_mocks/firebase_auth_mocks.dart';
import '../../setUp.dart';
import 'recent_route_card_test.mocks.dart';

@GenerateMocks([UserSettings, RouteManager, MarkerManager, ApplicationBloc])
void main() {
  final mockUserSettings = MockUserSettings();
  final mockRouteManager = MockRouteManager();
  final mockMarkerManager = MockMarkerManager();
  final mockApplicationBlock = MockApplicationBloc();

  setMocks();
  final routeManager = RouteManager();
  when(mockUserSettings.getRecentRoute((any))).thenAnswer((realInvocation) async => Pathway());
  when(mockRouteManager.clearRouteMarkers()).thenAnswer((realInvocation) async => null);
  setupFirebaseAuthMocks();
  const location = LatLng(1, -1);
  final place = Place(latlng: location, name: "Bush House", placeId: "1", description: "");
  final place2 = Place(latlng: location, name: "Strand", placeId: "2", description: "");
  when(mockRouteManager.getStart()).thenAnswer((realInvocation) => Stop(place));
  when(mockRouteManager.getDestination()).thenAnswer((realInvocation) => Stop(place2));
  setupFirebaseAuthMocks();
  when(mockRouteManager.getWaypoints()).thenAnswer((realInvocation) => [Stop(place),Stop(place2)]);
  when(mockRouteManager.getGroupSize()).thenAnswer((realInvocation) => 1);
  when(mockApplicationBlock.findRoute(place, place2)).thenAnswer((realInvocation) => null);
  setupFirebaseAuthMocks();

  setUpAll(() async {
    HttpOverrides.global = null;
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  });

  testWidgets('Recent Route Card has InkWell', (WidgetTester tester) async {
    await pumpWidget(tester, const MaterialApp(home: Material(child: RecentRouteCard(index: 1))));
    expect(find.byType(InkWell), findsOneWidget);
  });

  testWidgets('Recent Route Card has SizedBox', (WidgetTester tester) async {
    await pumpWidget(tester, const MaterialApp(home: Material(child: RecentRouteCard(index: 1))));
    expect(find.byType(SizedBox), findsWidgets);
  });

  testWidgets('Recent Route Card has Circle icons', (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: const RecentRouteCard(index: 1))));
    expect(find.byType(Icon), findsWidgets);
  });

  testWidgets('Can tap recent route card', (WidgetTester tester) async {

    when(mockApplicationBlock.findRoute(any,any,[place, place2], 1)).thenAnswer((realInvocation) => null);
    await pumpWidget(tester, MaterialApp(home: Material(child: RecentRouteCard(index: 1, userSettings: mockUserSettings, routeManager: mockRouteManager, markerManager: mockMarkerManager, applicationBloc: mockApplicationBlock,))));

    final card = find.byType(InkWell);
    await tester.tap(card);
    await tester.pump();
  });
}