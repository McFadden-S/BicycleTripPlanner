import 'package:bicycle_trip_planner/widgets/routeplanning/RoutePlanningCard.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bicycle_trip_planner/widgets/routeplanning/RoutePlanning.dart';


void main() {

  testWidgets('Find', (WidgetTester tester) async {
    await tester.pumpWidget(const RoutePlanningCard(loadRoute: "hello"));

    final titleFinder = find.text("Starting Point");

    expect(titleFinder, findsOneWidget);

  });
}