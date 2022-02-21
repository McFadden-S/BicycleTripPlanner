import 'dart:io';

import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
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

  testWidgets("StationBar has a title 'Nearby Stations'", (WidgetTester tester) async {
    await tester.pumpWidget(buildWidget(MaterialApp(home: Material(child:StationBar()))));
    expect(find.text('Nearby Stations'), findsOneWidget);
  });

  testWidgets("StationBar has an icon button 'firstPage'", (WidgetTester tester) async {
    await tester.pumpWidget(buildWidget(MaterialApp(home: Material(child:StationBar()))));
    expect(find.widgetWithIcon(IconButton, Icons.first_page), findsOneWidget);
  });

  testWidgets("StationBar has an icon button 'expanded station list'", (WidgetTester tester) async {
    await tester.pumpWidget(buildWidget(MaterialApp(home: Material(child:StationBar()))));
    expect(find.widgetWithIcon(IconButton, Icons.menu), findsOneWidget);
  });

  testWidgets("StationBar has a stations listView", (WidgetTester tester) async {
    await tester.pumpWidget(buildWidget(MaterialApp(home: Material(child:StationBar()))));
    expect(find.byType(ListView), findsOneWidget);
  });

}