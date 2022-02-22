import 'dart:io';

import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/main.dart';
import 'package:bicycle_trip_planner/widgets/general/MapWidget.dart';
import 'package:bicycle_trip_planner/widgets/general/Search.dart';
import 'package:bicycle_trip_planner/widgets/home/Home.dart';
import 'package:bicycle_trip_planner/widgets/home/StationBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

Widget buildWidget(Widget widgetIn){
  return MultiProvider(
    providers: [
      ListenableProvider(create: (context) => ApplicationBloc()),
    ],
    builder: (context, child) {
      return widgetIn;
    },
  );
}


void main() {
  setUpAll(() async {
    HttpOverrides.global = null;
  });

  testWidgets('Navigation has home', (WidgetTester tester) async {
    await tester.pumpWidget(buildWidget(MyApp()));
    expect(find.text('Home'), findsOneWidget);
  });

  testWidgets("Home has a safeArea", (WidgetTester tester) async {
    await tester.pumpWidget(buildWidget(MaterialApp(home: Home())));
    expect(find.byType(SafeArea), findsOneWidget);
  });

  testWidgets("Home has a search box", (WidgetTester tester) async {
    await tester.pumpWidget(buildWidget(MaterialApp(home: Home())));
    expect(find.widgetWithText(Search, 'Search'), findsOneWidget);
  });

  testWidgets("Home has a map", (WidgetTester tester) async {
    await tester.pumpWidget(buildWidget(MaterialApp(home: Home())));
    expect(find.byType(MapWidget), findsOneWidget);
  });

  testWidgets("Home has a bottom StationBar", (WidgetTester tester) async {
    await tester.pumpWidget(buildWidget(MaterialApp(home: Home())));
    expect(find.byType(StationBar), findsOneWidget);
  });



}