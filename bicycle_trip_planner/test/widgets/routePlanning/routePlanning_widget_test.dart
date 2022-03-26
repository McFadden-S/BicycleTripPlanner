import 'dart:io';

import 'package:bicycle_trip_planner/widgets/general/buttons/CircleButton.dart';
import 'package:bicycle_trip_planner/widgets/general/other/DistanceETACard.dart';
import 'package:bicycle_trip_planner/widgets/general/buttons/RoundedRectangleButton.dart';
import 'package:bicycle_trip_planner/widgets/routeplanning/RoutePlanning.dart';
import 'package:flutter/material.dart';
import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/widgets/routeplanning/RoutePlanningCard.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../../setUp.dart';

void main() {
  setUpAll(() async {
    HttpOverrides.global = null;
  });

  testWidgets("RoutePlanning has current location button", (WidgetTester tester) async {
    await pumpWidget(tester, RoutePlanning());

    final currentLocation = find.widgetWithIcon(CircleButton, Icons.location_searching);

    expect(currentLocation, findsOneWidget);
  });

  testWidgets("RoutePlanning has group button", (WidgetTester tester) async {
    await pumpWidget(tester, RoutePlanning());

    final groupButton = find.widgetWithIcon(CircleButton, Icons.group);

    expect(groupButton, findsOneWidget);
  });


  testWidgets("RoutePlanning has bike button", (WidgetTester tester) async {
    await pumpWidget(tester, RoutePlanning());

    final bikeButton = find.widgetWithIcon(RoundedRectangleButton, Icons.directions_bike);

    expect(bikeButton, findsOneWidget);
  });


  testWidgets("RoutePlanning has DistanceETACard", (WidgetTester tester) async {
    await pumpWidget(tester, RoutePlanning());

    final distanceETACard = find.byType(DistanceETACard);

    expect(distanceETACard, findsOneWidget);
  });


  testWidgets("RoutePlanning has RouteCard", (WidgetTester tester) async {
    await pumpWidget(tester, RoutePlanning());

    final routeCard = find.byType(RoutePlanningCard);

    expect(routeCard, findsOneWidget);
  });


  testWidgets("RoutePlanning has two search bars in the RouteCard when first opened", (WidgetTester tester) async {
    await pumpWidget(tester, RoutePlanning());

    final startSearch = find.text('Starting Point');
    final destinationSearch = find.text('Destination');

    expect(startSearch, findsOneWidget);
    expect(destinationSearch, findsOneWidget);
  });


  testWidgets("RoutePlanning has 'Add Stop(s)' button in the RouteCard when first opened", (WidgetTester tester) async {
    await pumpWidget(tester, RoutePlanning());

    final addStopsButton = find.text('Add Stop(s)');

    expect(addStopsButton, findsOneWidget);
  });


  testWidgets("RoutePlanning has Expand button in the RouteCard when first opened", (WidgetTester tester) async {
    await pumpWidget(tester, RoutePlanning());

    final startSearch = find.byIcon(Icons.expand_more);

    expect(startSearch, findsOneWidget);
  });


  testWidgets("When Add Stop(s) button is clicked a new search bar for an intermediate stop appears", (WidgetTester tester) async {
    await pumpWidget(tester, RoutePlanning());

    final addStopsButton = find.text('Add Stop(s)');
    final stopSearchBar = find.text('Stop 1');

    expect(stopSearchBar, findsNothing);

    await tester.tap(addStopsButton);
    await tester.pump();

    expect(stopSearchBar, findsOneWidget);
  });


  testWidgets("When Add Stop(s) button is clicked twice, two new search bars for an intermediate stops appear", (WidgetTester tester) async {
    await pumpWidget(tester, RoutePlanning());

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
    await pumpWidget(tester, RoutePlanning());

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
    await pumpWidget(tester, RoutePlanning());

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


  //TODO finish test for clicking location button
  // testWidgets('When location button is clicked the map should centre on the current location of the user', (WidgetTester tester) async {
  //
  // await pumpWidget(tester, RoutePlanning());
  //
  // expect(updated map widget with the map centred on the user, findsOneWidget)
  //
  // });

  //TODO finish test for clicking group button
  // testWidgets('When the group button is clicked the group options menu should expand outwards', (WidgetTester tester) async {
  //
  // await pumpWidget(tester, RoutePlanning());
  //
  // expect(expended group options menu widget, findsOneWidget);
  //
  // });

  //TODO finish test for clicking bike button
  // testWidgets('When the bike button is clicked the user should be taken to the navigation screen', (WidgetTester tester) async {
  //
  // await pumpWidget(tester, RoutePlanning());
  //
  // expect(navigation widget, findsOneWidget);
  // });

  //TODO finish test for ETA update
  // testWidgets('When the ETA is updated, the ETA field in the distanceETA card should update accordingly', (WidgetTester tester) async {
  //
  // await pumpWidget(tester, RoutePlanning());
  //
  // expect(ETA field in ETA card widget, findsOneWidget);
  // });

}