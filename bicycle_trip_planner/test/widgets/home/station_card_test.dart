import 'dart:io';
import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/models/station.dart';
import 'package:bicycle_trip_planner/widgets/home/StationCard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../bloc/application_bloc_test.mocks.dart';
import '../../managers/firebase_mocks/firebase_auth_mocks.dart';
import '../../setUp.dart';
import 'station_card_test.mocks.dart';

@GenerateMocks([ApplicationBloc])
void main() {

  final mockAppBloc = MockApplicationBloc();
  setupFirebaseAuthMocks();
  setMocks();
  MockDatabaseManager mockDatabaseManager = getAppBloc().getDatabaseManager();

  when(mockDatabaseManager.isUserLogged()).thenAnswer((_) => true);

  setUpAll(() async {
    HttpOverrides.global = null;
    await Firebase.initializeApp();
  });

  Station station = Station(
      id: 1,
      name: 'Holborn Station',
      lat: 1.0,
      lng: 2.0,
      bikes: 10,
      emptyDocks: 2,
      totalDocks: 8,
      distanceTo: 1
  );

  testWidgets("StationCard has a title of the station name", (WidgetTester tester) async {
    await tester.runAsync(
            () async {
              await pumpWidget(tester, MaterialApp(
                  home: Material(child: StationCard(station: station, ))));
              expect(find.text(station.name), findsWidgets);
            });
  });

  testWidgets("StationCard has a number of bikes displayed", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child:StationCard(station: station))));
    expect(find.text("\t\t${station.bikes.toString()} bikes available"), findsWidgets);
  });

  testWidgets("StationCard has a number of docks displayed", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child:StationCard(station: station))));
    expect(find.text("\t\t${station.totalDocks.toString()} free docks"), findsWidgets);
  });

  testWidgets("StationCard has an icon directions_bike", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child:StationCard(station: station))));
    expect(find.byIcon(Icons.directions_bike), findsWidgets);
  });

  testWidgets("StationCard has an icon chair", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child:StationCard(station: station))));
    expect(find.byIcon(Icons.chair_alt), findsWidgets);
  });

  testWidgets("StationCard has contents inside", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child:StationCard(station: station))));
    expect(find.byType(InkWell), findsWidgets);
  });

  testWidgets("Tapping widget moves to another widget", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child:StationCard(station: station))));
    final widget = find.byType(InkWell);
    expect(widget, findsOneWidget);

    await tester.tap(widget);
    await tester.pump();
    expect(widget, findsOneWidget);
  });

  testWidgets("StationCard favourite button has icon star, when favourite is true", (WidgetTester tester) async {
    when(mockAppBloc.isUserLogged()).thenAnswer((_) => true);

    await pumpWidget(tester, MaterialApp(
        home: Material(
            child:StationCard(
                station: station,
                isFavourite: true,
                toggleFavourite: (Station station) {},
            )
        )
    ));
    final widget = find.byType(InkWell);
    expect(widget, findsOneWidget);

    expect(find.byType(IconButton), findsWidgets);
    expect(find.byIcon(Icons.star), findsWidgets);
  });

  testWidgets("StationCard favourite button has icon star, when favourite is false", (WidgetTester tester) async {
    when(mockAppBloc.isUserLogged()).thenAnswer((_) => true);

    await pumpWidget(tester, MaterialApp(
        home: Material(
            child:StationCard(
                station: station,
                isFavourite: false,
                toggleFavourite: (Station station) {},
            )
        )
    ));    final widget = find.byType(InkWell);
    expect(widget, findsOneWidget);

    expect(find.byType(IconButton), findsWidgets);
    expect(find.byIcon(Icons.star), findsWidgets);
  });

  testWidgets("StationCard favorite button opens another widget when pressed and favourite is true", (WidgetTester tester) async {
    when(mockAppBloc.isUserLogged()).thenAnswer((_) => true);

    await pumpWidget(tester, MaterialApp(
        home: Material(
            child:StationCard(
                station: station,
                isFavourite: true,
                toggleFavourite: (Station station) {},
            )
        )
    ));
    final widget = find.byType(IconButton);
    expect(widget, findsOneWidget);

    await tester.press(widget);
    await tester.pump();
    expect(widget, findsOneWidget);
  });

  testWidgets("StationCard favorite button opens another widget when pressed and favourite is false", (WidgetTester tester) async {
    when(mockAppBloc.isUserLogged()).thenAnswer((_) => true);

    await pumpWidget(tester, MaterialApp(
        home: Material(
            child:StationCard(
                station: station,
                isFavourite: false,
                toggleFavourite: (Station station) {},
            )
        )
    ));
    final widget = find.byType(IconButton);
    expect(widget, findsOneWidget);

    await tester.press(widget);
    await tester.pump();
    expect(widget, findsOneWidget);
  });
}