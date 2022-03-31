import 'package:bicycle_trip_planner/widgets/general/other/Loading.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import '../../../setUp.dart';

main() {
  setMocks();
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets("Loading page returns something", (WidgetTester tester) async {
    await tester.runAsync(
            () async {
              await pumpWidget(tester, MaterialApp(home: Material(child: Loading())));
              expect(find.byType(Scaffold), findsOneWidget);
        });
  });
}