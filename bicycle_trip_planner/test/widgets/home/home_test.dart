import 'package:bicycle_trip_planner/widgets/general/Search.dart';
import 'package:bicycle_trip_planner/widgets/home/Home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('MyWidget has a title and message', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Home()));
    //
    // final searchWidget = find.byWidget(Search(labelTextIn:'Search', searchController: TextEditingController()));
    //
    // expect(searchWidget, findsOneWidget);

  });
}

