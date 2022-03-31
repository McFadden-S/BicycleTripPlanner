import 'package:bicycle_trip_planner/widgets/general/other/MapWidget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import '../../../setUp.dart';

main() {
  setMocks();
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets("Map widgets returns something", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: MapWidget())));
    expect(find.byType(Scaffold), findsOneWidget);
  });
}