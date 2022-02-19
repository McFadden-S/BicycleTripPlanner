import 'package:bicycle_trip_planner/widgets/general/DistanceETACard.dart';
import 'package:bicycle_trip_planner/widgets/general/MapWidget.dart';
import 'package:bicycle_trip_planner/widgets/routeplanning/RoutePlanning.dart';
import 'package:flutter/material.dart';
import 'package:bicycle_trip_planner/bloc/application_bloc.dart';

import 'package:bicycle_trip_planner/widgets/routeplanning/IntermediateSearchList.dart';
import 'package:bicycle_trip_planner/widgets/general/Search.dart';

import 'package:bicycle_trip_planner/widgets/routeplanning/RouteCard.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:bicycle_trip_planner/main.dart';

void main() {

  testWidgets('check the RoutePlanning screen loads with the correct widgets displayed', (WidgetTester tester) async {

    final TextEditingController startSearchController = TextEditingController();
    final TextEditingController destinationSearchController = TextEditingController();

    final routeCard = find.byWidget(RouteCard(startSearchController: startSearchController, destinationSearchController: destinationSearchController));
    final map = find.byWidget(MapWidget());
    final locationButton = find.byIcon(Icons.location_searching);
    final groupButton = find.byIcon(Icons.group);
    final distanceETA = find.byWidget(DistanceETACard());
    final bikeButton = find.byIcon(Icons.directions_bike);

    await tester.pumpWidget(const MaterialApp(home: RoutePlanning()));
    await tester.pump();

    expect(routeCard, findsOneWidget);
    expect(map, findsOneWidget);
    expect(locationButton, findsOneWidget);
    expect(groupButton, findsOneWidget);
    expect(distanceETA, findsOneWidget);
    expect(bikeButton, findsOneWidget);

  });


  testWidgets('Given user in RoutePlanning When the screen loads Then RouteCard includes two search bars', (WidgetTester tester) async {
    final TextEditingController startSearchController = TextEditingController();
    final TextEditingController destinationSearchController = TextEditingController();
    final routeCard = find.byWidget(RouteCard(startSearchController: startSearchController, destinationSearchController: destinationSearchController));


    // await tester.pumpWidget(RouteCard(startSearchController: startSearchController, destinationSearchController: destinationSearchController));
    await tester.pumpWidget(const MaterialApp(home: RoutePlanning()));
    await tester.pump();

    final startSearchControllerFinder = find.text('Starting Point');
    final destinationSearchControllerFinder = find.text('Destination');

    expect(startSearchControllerFinder, findsOneWidget);
    expect(destinationSearchControllerFinder, findsOneWidget);
  });


  testWidgets('When Add Stop(s) button is clicked a new search bar for an intermediate destination appears', (WidgetTester tester) async {
    final TextEditingController startSearchController = TextEditingController();
    //final TextEditingController intermediateSearchController = TextEditingController();
    final TextEditingController destinationSearchController = TextEditingController();
    //final routeCard = find.byWidget(RouteCard(startSearchController: startSearchController, destinationSearchController: destinationSearchController));

    // await tester.pumpWidget(RouteCard(startSearchController: startSearchController, destinationSearchController: destinationSearchController));
    await tester.pumpWidget(const MaterialApp(home: RoutePlanning()));
    await tester.tap(find.text('Add Stop(s)'));
    await tester.pump();

    expect(find.text('Stop 1'), findsOneWidget);
  });


  //TODO finish test for clicking location button
  // testWidgets('When location button is clicked the map should centre on the current location of the user', (WidgetTester tester) async {
  //   // final ...
  //
  //   await tester.pumpWidget(const MaterialApp(home: RoutePlanning()));
  //   await tester.tap(find.byIcon(Icons.location_searching));
  //   await tester.pump();
  //
  //   // expect(updated map widget with the map centred on the user, findsOneWidget)
  //
  // });

  //TODO finish test for clicking group button
  // testWidgets('When the group button is clicked the group options menu should expand outwards', (WidgetTester tester) async {
  //   // final ...
  //
  //   await tester.pumpWidget(const MaterialApp(home: RoutePlanning()));
  //   await tester.tap(find.byIcon(Icons.group));
  //   await tester.pump();
  //
  //   // expect(expended group options menu widget, findsOneWidget);
  //
  // });

  //TODO finish test for clicking bike button
  // testWidgets('When the bike button is clicked the user should be taken to the navigation screen', (WidgetTester tester) async {
  //   // final ...
  //
  //   await tester.pumpWidget(const MaterialApp(home: RoutePlanning()));
  //   await tester.tap(find.byIcon(Icons.directions_bike));
  //   await tester.pump();
  //
  //   // expect(navigation widget, findsOneWidget);
  // });

}