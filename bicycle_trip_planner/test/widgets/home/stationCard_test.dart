import 'dart:io';
import 'package:bicycle_trip_planner/models/station.dart';
import 'package:bicycle_trip_planner/widgets/home/StationCard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../managers/firebase_mocks/firebase_auth_mocks.dart';
import '../../setUp.dart';

void main() {
  setupFirebaseAuthMocks();

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
                  home: Material(child: StationCard(station: station,))));
              expect(find.text(station.name), findsWidgets);
            });
  });

  testWidgets("StationCard has a number of bikes displayed", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child:StationCard(station: station,))));
    expect(find.text("\t\t${station.bikes.toString()} bikes available"), findsWidgets);
  });

  testWidgets("StationCard has a number of docks displayed", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child:StationCard(station: station,))));
    expect(find.text("\t\t${station.totalDocks.toString()} free docks"), findsWidgets);
  });

  // testWidgets("StationCard has a distance displayed", (WidgetTester tester) async {
  //   await pumpWidget(tester, MaterialApp(home: Material(child:StationCard(station: station,))));
  //   expect(find.text("${station.distanceTo.toStringAsFixed(1)}"), findsWidgets);
  // });

  testWidgets("StationBar has an icon directions_bike", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child:StationCard(station: station))));
    expect(find.byIcon(Icons.directions_bike), findsWidgets);
  });

  testWidgets("StationBar has an icon chair", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child:StationCard(station: station))));
    expect(find.byIcon(Icons.chair_alt), findsWidgets);
  });

  // testWidgets("StationBar has favourite icon if favourite", (WidgetTester tester) async {
  //   await pumpWidget(tester, MaterialApp(home: Material(child:StationCard(station: station, isFavourite: true))));
  //   expect(find.byIcon(Icons.star), findsWidgets);
  // });

  // testWidgets("StationBar has favourite icon if not favourite", (WidgetTester tester) async {
  //   await pumpWidget(tester, MaterialApp(home: Material(child:StationCard(station: station, isFavourite: false))));
  //   expect(find.byIcon(Icons.star), findsWidgets);
  // });
}