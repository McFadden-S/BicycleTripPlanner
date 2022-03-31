import 'dart:io';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/widgets/general/buttons/OptimiseCostButton.dart';
import 'package:bicycle_trip_planner/widgets/general/other/CustomBottomSheet.dart';
import 'package:bicycle_trip_planner/widgets/general/other/DistanceETACard.dart';
import 'package:bicycle_trip_planner/widgets/general/other/Search.dart';
import 'package:bicycle_trip_planner/widgets/routeplanning/RoutePlanning.dart';
import 'package:flutter/material.dart';
import 'package:bicycle_trip_planner/widgets/routeplanning/RoutePlanningCard.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../managers/firebase_mocks/firebase_auth_mocks.dart';
import '../../setUp.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    HttpOverrides.global = null;
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  });


  setUp(() {
    RouteManager().clear();
  });

  testWidgets("RoutePlanning has current location button",
      (WidgetTester tester) async {
    // await pumpWidget(tester, RoutePlanning());
    await pumpWidget(
        tester, MaterialApp(home: Material(child: RoutePlanning())));
    // final currentLocationButton = find.byKey(ValueKey("currentLocationButton"));
    expect(find.byKey(ValueKey("currentLocationButton")), findsOneWidget);
  });

  testWidgets("RoutePlanning has group button", (WidgetTester tester) async {
    await pumpWidget(
        tester, MaterialApp(home: Material(child: RoutePlanning())));
    final groupButton = find.byKey(ValueKey("groupSizeSelector"));

    expect(groupButton, findsOneWidget);
  });

  testWidgets("When group button is clicked a dropdown appears",
      (WidgetTester tester) async {
    await pumpWidget(
        tester, MaterialApp(home: Material(child: RoutePlanning())));

    final groupButton = find.byKey(ValueKey("groupSizeSelector"));

    expect(groupButton, findsOneWidget);

    await tester.tap(groupButton);
    await tester.pumpAndSettle();

    final dropdownItem = find.text('1').last;

    expect(dropdownItem, findsOneWidget);
  });

  testWidgets("RoutePlanning has bike button", (WidgetTester tester) async {
    await pumpWidget(
        tester, MaterialApp(home: Material(child: RoutePlanning())));

    final bottomCard = find.byType(CustomBottomSheet);

    final bikeButton = find.descendant(
        of: bottomCard,
        matching: find.widgetWithIcon(ElevatedButton, Icons.directions_bike));
    expect(bikeButton, findsOneWidget);
  });

  testWidgets("RoutePlanning has dollar icon", (WidgetTester tester) async {
    await pumpWidget(
        tester, MaterialApp(home: Material(child: RoutePlanning())));

    final bikeButton = find.widgetWithIcon(OptimiseCostButton, Icons.money_off);

    expect(bikeButton, findsOneWidget);
  });

  testWidgets("RoutePlanning has DistanceETACard", (WidgetTester tester) async {
    await pumpWidget(
        tester, MaterialApp(home: Material(child: RoutePlanning())));

    final distanceETACard = find.byType(DistanceETACard);

    expect(distanceETACard, findsOneWidget);
  });

  testWidgets("RoutePlanning has RouteCard", (WidgetTester tester) async {
    await pumpWidget(
        tester, MaterialApp(home: Material(child: RoutePlanning())));

    final routeCard = find.byType(RoutePlanningCard);

    expect(routeCard, findsOneWidget);
  });

  testWidgets(
      "RoutePlanning has two search bars in the RouteCard when first opened",
      (WidgetTester tester) async {
    await pumpWidget(
        tester, MaterialApp(home: Material(child: RoutePlanning())));

    final startSearch = find.text('Starting Point');
    final destinationSearch = find.text('Destination');

    expect(startSearch, findsOneWidget);
    expect(destinationSearch, findsOneWidget);
  });

  testWidgets(
      "RoutePlanning has 'Add Stop(s)' button in the RouteCard when first opened",
      (WidgetTester tester) async {
    await pumpWidget(
        tester, MaterialApp(home: Material(child: RoutePlanning())));

    final addStopsButton = find.text('Add Stop(s)');

    expect(addStopsButton, findsOneWidget);
  });

  testWidgets(
      "When Add Stop(s) button is clicked a new search bar for an intermediate stop appears",
      (WidgetTester tester) async {
    await pumpWidget(
        tester, MaterialApp(home: Material(child: RoutePlanning())));

    final addStopsButton = find.text('Add Stop(s)');
    final stopSearchBar = find.text('Stop');

    expect(stopSearchBar, findsNothing);

    await tester.tap(addStopsButton);
    await tester.pump();

    expect(stopSearchBar, findsOneWidget);
  });

  testWidgets(
      "When Add Stop(s) button is clicked twice, two new search bars for an intermediate stops appear",
      (WidgetTester tester) async {
    await pumpWidget(
        tester, MaterialApp(home: Material(child: RoutePlanning())));

    final addStopsButton = find.text('Add Stop(s)');
    final stopSearchBar1 = find.byKey(ValueKey('Stop 1'));
    final stopSearchBar2 = find.byKey(ValueKey('Stop 2'));

    expect(stopSearchBar1, findsNothing);
    expect(stopSearchBar2, findsNothing);

    await tester.tap(addStopsButton);
    await tester.pumpAndSettle();

    expect(stopSearchBar1, findsOneWidget);
    expect(stopSearchBar2, findsNothing);

    await tester.tap(addStopsButton);
    await tester.pumpAndSettle();

    expect(stopSearchBar1, findsOneWidget);
    expect(stopSearchBar2, findsOneWidget);
  });

  testWidgets(
      "When remove button is clicked next to an intermediate stop, the stop is removed from the screen",
      (WidgetTester tester) async {
    await pumpWidget(
        tester, MaterialApp(home: Material(child: RoutePlanning())));

    final addStopsButton = find.text('Add Stop(s)');
    final stopSearchBar = find.widgetWithText(Search, 'Stop');
    final removeStopButton = find.byIcon(Icons.remove_circle_outline);

    expect(stopSearchBar, findsNothing);

    await tester.tap(addStopsButton);
    await tester.pumpAndSettle();

    expect(stopSearchBar, findsOneWidget);

    await tester.tap(removeStopButton);
    await tester.pumpAndSettle();

    expect(stopSearchBar, findsNothing);
  });

  testWidgets(
      "When remove button is clicked next to Stop 1 in a list with 2 stops, stop 1 is removed and stop 2 takes it's place",
      (WidgetTester tester) async {
    await pumpWidget(
        tester, MaterialApp(home: Material(child: RoutePlanning())));

    final addStopsButton = find.text('Add Stop(s)');
    final stopSearchBar = find.widgetWithText(Search, 'Stop');
    final removeStopButton = find.byKey(Key("Remove 1"));

    expect(stopSearchBar, findsNothing);

    await tester.tap(addStopsButton);
    await tester.pumpAndSettle();

    expect(stopSearchBar, findsWidgets);

    await tester.tap(addStopsButton);
    await tester.pumpAndSettle();

    expect(stopSearchBar, findsWidgets);

    await tester.tap(removeStopButton);
    await tester.pumpAndSettle();

    expect(stopSearchBar, findsOneWidget);
  });

}
