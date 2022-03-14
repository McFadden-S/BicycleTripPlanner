import 'dart:io';

import 'package:bicycle_trip_planner/widgets/login/FavouriteBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../setUp.dart';

void main() {
  setUpAll(() async {
    HttpOverrides.global = null;
  });

  testWidgets("StationBar has a title 'Nearby Stations'", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child:FavouriteBar())));
    expect(find.text('Favourite Stations'), findsOneWidget);
  });

  testWidgets("StationBar has an icon button 'firstPage'", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child:FavouriteBar())));
    expect(find.widgetWithIcon(IconButton, Icons.first_page), findsOneWidget);
  });

  testWidgets("StationBar has an icon button 'expanded station list'", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child:FavouriteBar())));
    expect(find.widgetWithIcon(IconButton, Icons.menu), findsOneWidget);
  });

  testWidgets("StationBar has a stations listView", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child:FavouriteBar())));
    expect(find.byType(ListView), findsOneWidget);
  });

}