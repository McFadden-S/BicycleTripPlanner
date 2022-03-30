import 'dart:io';

import 'package:bicycle_trip_planner/managers/DatabaseManager.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/managers/UserSettings.dart';
import 'package:bicycle_trip_planner/models/stop.dart';
import 'package:bicycle_trip_planner/widgets/general/buttons/CircleButton.dart';
import 'package:bicycle_trip_planner/widgets/general/buttons/OptimiseCostButton.dart';
import 'package:bicycle_trip_planner/widgets/general/buttons/OptimisedButton.dart';
import 'package:bicycle_trip_planner/widgets/general/other/DistanceETACard.dart';
import 'package:bicycle_trip_planner/widgets/routeplanning/IntermediateSearchList.dart';
import 'package:bicycle_trip_planner/widgets/routeplanning/RoutePlanning.dart';
import 'package:bicycle_trip_planner/widgets/routeplanning/RoutePlanningCard.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../managers/firebase_mocks/firebase_auth_mocks.dart';
import '../../setUp.dart';
import 'route_planning_test.mocks.dart';

@GenerateMocks([DatabaseManager, UserSettings, RouteManager])
void main(){
  final mockDatabaseManager = MockDatabaseManager();
  final mockUserSettings = MockUserSettings();
  final mockRouteManager = MockRouteManager();
  when(mockDatabaseManager.isUserLogged()).thenAnswer((realInvocation) => true);
  when(mockUserSettings.getNumberOfRoutes()).thenAnswer((realInvocation) async => 3);
  when(mockRouteManager.ifRouteSet()).thenAnswer((realInvocation) => true);
  when(mockRouteManager.getWaypoints()).thenAnswer((realInvocation) => [Stop(), Stop()]);
  when(mockRouteManager.ifCostOptimised()).thenAnswer((realInvocation) => false);
  when(mockRouteManager.getStart()).thenAnswer((realInvocation) => Stop());
  setupFirebaseAuthMocks();
  setUpAll(() async {
    HttpOverrides.global = null;
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  });

  testWidgets("RoutePlanning has a SafeArea", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: RoutePlanning())));
    expect(find.byType(SafeArea), findsOneWidget);
  });

  testWidgets("RoutePlanning has current location button", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: RoutePlanning())));
    expect(find.byKey(ValueKey("currentLocationButton")), findsOneWidget);
  });

  testWidgets("RoutePlanning has group button", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: RoutePlanning())));

    final groupButton = find.byKey(ValueKey("groupSizeSelector"));

    expect(groupButton, findsOneWidget);
  });

  testWidgets("RoutePlanning has two search bars in the RouteCard when first opened", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: RoutePlanning())));

    final startSearch = find.text('Starting Point');
    final destinationSearch = find.text('Destination');

    expect(startSearch, findsOneWidget);
    expect(destinationSearch, findsOneWidget);
  });

  testWidgets("RoutePlanning has DistanceETACard", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: RoutePlanning())));

    final distanceETACard = find.byType(DistanceETACard);

    expect(distanceETACard, findsOneWidget);
  });


  testWidgets("RoutePlanning has RouteCard", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: RoutePlanning())));

    final routeCard = find.byType(RoutePlanningCard);

    expect(routeCard, findsOneWidget);
  });

  testWidgets("When group button is clicked a dropdown appears", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: RoutePlanning())));

    final groupButton = find.byKey(ValueKey("groupSizeSelector"));

    expect(groupButton, findsOneWidget);

    await tester.tap(groupButton);
    await tester.pumpAndSettle();

    final dropdownItem = find.text('1').last;

    expect(dropdownItem, findsOneWidget);
  });

  testWidgets("RoutePlanning has optimise button", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: RoutePlanning())));

    final optimiseButton = find.widgetWithIcon(CircleButton, Icons.money_off);

    expect(optimiseButton, findsOneWidget);
  });

  testWidgets("RoutePlanning has favourite routes button when user is logged in", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: RoutePlanning(databaseManager: mockDatabaseManager,))));
    final favouriteButton = find.widgetWithIcon(CircleButton, Icons.star);
    expect(favouriteButton, findsOneWidget);
    await tester.tap(favouriteButton);
    await tester.pump();
  });

  testWidgets("Can start journey", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: RoutePlanning(databaseManager: mockDatabaseManager, routeManager: mockRouteManager,))));
    final favouriteButton = find.widgetWithIcon(ElevatedButton, Icons.directions_bike);
    expect(favouriteButton, findsOneWidget);
    await tester.tap(favouriteButton);
    await tester.pump();
  });

  /**
   * recentRouteCount not being set so history button not showing
   */
  testWidgets("Has history button when logged in and when there is recent routes", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: RoutePlanning(databaseManager: mockDatabaseManager, userSettings: mockUserSettings,))));
    await tester.pump();
    final historyButton = find.widgetWithIcon(CircleButton, Icons.history);
    expect(historyButton, findsOneWidget);
    await tester.tap(historyButton);
    await tester.pumpAndSettle();
  });
}