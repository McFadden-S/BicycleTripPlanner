import 'dart:io';

import 'package:bicycle_trip_planner/widgets/general/CircleButton.dart';
import 'package:bicycle_trip_planner/widgets/general/DistanceETACard.dart';
import 'package:bicycle_trip_planner/widgets/general/RoundedRectangleButton.dart';
import 'package:bicycle_trip_planner/widgets/navigation/Navigation.dart';
import 'package:bicycle_trip_planner/widgets/routeplanning/RoutePlanning.dart';
import 'package:flutter/material.dart';
import 'package:bicycle_trip_planner/widgets/routeplanning/RoutePlanningCard.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../setUp.dart';
import 'package:firebase_core/firebase_core.dart';
import '../login/mock.dart';

void main() {

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
    // await pumpWidget(tester, RoutePlanning());
    await pumpWidget(tester, MaterialApp(home: Material(child: RoutePlanning())));

    // final currentLocationButton = find.byKey(ValueKey("currentLocationButton"));

    expect(find.byKey(ValueKey("currentLocationButton")), findsOneWidget);
  });

  testWidgets("RoutePlanning has group button", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: RoutePlanning())));

    final groupButton = find.byKey(ValueKey("groupSizeSelector"));

    expect(groupButton, findsOneWidget);
  });

  testWidgets("When group button is clicked a dropdown appears", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: RoutePlanning())));

    final groupButton = find.byKey(ValueKey("groupSizeSelector"));
    //final dropdown = find.byType(DropdownButtonHideUnderline())

    expect(groupButton, findsOneWidget);

    await tester.tap(groupButton);
    await tester.pumpAndSettle();

    final dropdownItem = find.text('First Item').last;

    expect(dropdownItem, findsOneWidget);
  });

  testWidgets("RoutePlanning has optimise button", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: RoutePlanning())));

    final optimiseButton = find.widgetWithIcon(CircleButton, Icons.alt_route);

    expect(optimiseButton, findsOneWidget);
  });

  testWidgets("RoutePlanning has bike button", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: RoutePlanning())));

    final bikeButton = find.widgetWithIcon(RoundedRectangleButton, Icons.directions_bike);

    expect(bikeButton, findsOneWidget);
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


  testWidgets("RoutePlanning has two search bars in the RouteCard when first opened", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: RoutePlanning())));

    final startSearch = find.text('Starting Point');
    final destinationSearch = find.text('Destination');

    expect(startSearch, findsOneWidget);
    expect(destinationSearch, findsOneWidget);
  });


  testWidgets("RoutePlanning has 'Add Stop(s)' button in the RouteCard when first opened", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: RoutePlanning())));

    final addStopsButton = find.text('Add Stop(s)');

    expect(addStopsButton, findsOneWidget);
  });


  testWidgets("RoutePlanning has Expand button in the RouteCard when first opened", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: RoutePlanning())));

    final startSearch = find.byIcon(Icons.expand_more);

    expect(startSearch, findsOneWidget);
  });


  testWidgets("When Add Stop(s) button is clicked a new search bar for an intermediate stop appears", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: RoutePlanning())));

    final addStopsButton = find.text('Add Stop(s)');
    final stopSearchBar = find.text('Stop 1');

    expect(stopSearchBar, findsNothing);

    await tester.tap(addStopsButton);
    await tester.pump();

    expect(stopSearchBar, findsOneWidget);
  });


  testWidgets("When Add Stop(s) button is clicked twice, two new search bars for an intermediate stops appear", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: RoutePlanning())));

    final addStopsButton = find.text('Add Stop(s)');
    final stopSearchBar = find.text('Stop 1');
    final StopSearchBar2 = find.text('Stop 2');

    expect(stopSearchBar, findsNothing);

    await tester.tap(addStopsButton);
    await tester.pump();

    expect(stopSearchBar, findsOneWidget);

    await tester.tap(addStopsButton);
    await tester.pump();

    expect(StopSearchBar2, findsOneWidget);
  });


  testWidgets("When X button is clicked next to a stop, the stop is removed from the screen", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: RoutePlanning())));

    final addStopsButton = find.text('Add Stop(s)');
    final stopSearchBar = find.text('Stop 1');
    final removeStopButton = find.byIcon(Icons.remove_circle_outline);

    expect(stopSearchBar, findsNothing);

    await tester.tap(addStopsButton);
    await tester.pump();

    expect(stopSearchBar, findsOneWidget);

    await tester.tap(removeStopButton);
    await tester.pump();

    expect(stopSearchBar, findsNothing);
  });


  testWidgets("When X button is clicked next to Stop 1 in a list with 2 stops, stop 1 is removed and stop 2 takes it's place and the text is changed to stop 1", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: RoutePlanning())));

    final addStopsButton = find.text('Add Stop(s)');
    final stopSearchBar = find.text('Stop 1');
    final stopSearchBar2 = find.text('Stop 2');
    final removeStopButton = find.byKey(Key("Remove 2"));

    expect(stopSearchBar, findsNothing);

    await tester.tap(addStopsButton);
    await tester.pump();

    expect(stopSearchBar, findsOneWidget);

    await tester.tap(addStopsButton);
    await tester.pump();

    expect(stopSearchBar2, findsOneWidget);

    await tester.tap(removeStopButton);
    await tester.pump();

    expect(stopSearchBar2, findsNothing);
  });

  testWidgets("When the bike button is clicked the user should be taken to the navigation screen", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: RoutePlanning())));

    final bikeButton = find.widgetWithIcon(RoundedRectangleButton, Icons.directions_bike);
    final navigationWidget = find.byWidget(Navigation());

    expect(navigationWidget, findsNothing);

    await tester.tap(bikeButton);
    await tester.pump();

    expect(bikeButton, findsOneWidget);
  });

  testWidgets("When the optimise button is clicked the user should be shown a dialog box with choices", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: RoutePlanning())));

    final optimiseButton = find.widgetWithIcon(CircleButton, Icons.alt_route);
    final binaryDialog = find.byKey(ValueKey("binaryChoiceDialog"));

    expect(optimiseButton, findsOneWidget);
    expect(binaryDialog, findsNothing);

    await tester.tap(optimiseButton);
    await tester.pump();

    expect(binaryDialog, findsOneWidget);
  });

}