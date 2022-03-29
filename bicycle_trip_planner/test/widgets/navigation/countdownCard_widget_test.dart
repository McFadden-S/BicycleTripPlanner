
import 'dart:io';

import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/models/legs.dart';
import 'package:bicycle_trip_planner/models/route.dart' as R;
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/models/bounds.dart';
import 'package:bicycle_trip_planner/models/overview_polyline.dart';
import 'package:bicycle_trip_planner/models/route_types.dart';
import 'package:bicycle_trip_planner/models/steps.dart';
import 'package:bicycle_trip_planner/widgets/navigation/CountdownCard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:clock/clock.dart';
import 'package:fake_async/fake_async.dart';

import '../../managers/firebase_mocks/firebase_auth_mocks.dart';
import '../../setUp.dart';

void main() {
  setupFirebaseAuthMocks();
  final bounds = Bounds(
      northeast: <String, dynamic>{}, southwest: <String, dynamic>{});
  const startLocation = LatLng(1, -1);
  const endLocation = LatLng(2, -2);
  final steps = Steps(instruction: "right", distance: 1, duration: 1);
  final polyline = OverviewPolyline(points: []);
  final legs = Legs(
      startLocation: startLocation,
      endLocation: endLocation,
      steps: [steps],
      distance: 1,
      duration: 1);
  final route = R.Route(
      bounds: bounds,
      legs: [legs],
      polyline: polyline,
      routeType: RouteType.bike);

  setUpAll(() async {
    HttpOverrides.global = null;
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  });

  /// Runs [callback] and prints how long it took.
  T runWithTiming<T>(T Function() callback, FakeAsync async, int seconds ) {
    var stopwatch = clock.stopwatch()..start();
    async.elapse(Duration(seconds: seconds));
    var result = callback();
    print('It took ${stopwatch.elapsed}!');
    return result;
  }

  testWidgets("Countdown card contains a card", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: CountdownCard(ctdwnController: CountdownController(),))));
    final card = find.byType(Card);

    expect(card, findsOneWidget);
    expect((tester.firstWidget(card) as Card).color, ThemeStyle.cardColor);
  });

  testWidgets("Countdown card does not contain a coundown if no cost optimised", (WidgetTester tester) async {
    RouteManager().setCostOptimised(false);

    await pumpWidget(tester, MaterialApp(home: Material(child: CountdownCard(ctdwnController: CountdownController(),))));
    final countdown = find.byType(Countdown);

    expect(countdown, findsNothing);
  });

  testWidgets("Countdown card does not contain a coundown if no biking", (WidgetTester tester) async {
    RouteManager().setCostOptimised(true);

    await pumpWidget(tester, MaterialApp(home: Material(child: CountdownCard(ctdwnController: CountdownController(),))));
    final countdown = find.byType(Countdown);

    expect(countdown, findsNothing);
  });

  testWidgets("Countdown card contains a countdown if cost optimised", (WidgetTester tester) async {
    RouteManager().setCostOptimised(true);
    RouteManager().setCurrentRoute(route, false);

    await pumpWidget(tester, MaterialApp(home: Material(child: CountdownCard(ctdwnController: CountdownController(),))));
    final countdown = find.byType(Countdown);

    expect(countdown, findsOneWidget);
  });

  testWidgets("Countdown card contains a countdown with some minutes in it", (WidgetTester tester) async {
    RouteManager().setCostOptimised(true);
    RouteManager().setCurrentRoute(route, false);

    await pumpWidget(tester, MaterialApp(home: Material(child: CountdownCard(ctdwnController: CountdownController(),))));
    final countdown = find.byType(Countdown);
    final text = find.descendant(of: countdown, matching: find.byType(Text)).first;
    Text t = text.evaluate().single.widget as Text;

    expect(t.data?.contains("min"), true);
    expect(t.style?.color, ThemeStyle.primaryTextColor);
  });

  testWidgets("Countdown card contains a countdown that notifies when time's up", (WidgetTester tester) async {
    RouteManager().setCostOptimised(true);
    RouteManager().setCurrentRoute(route, false);

    final controller = CountdownController();


    FakeAsync().run((async) async {
      controller.start();
      var stopwatch = clock.stopwatch()..start();
      async.elapse(Duration(seconds: 1815));

    });

    final countdownWidget = CountdownCard(ctdwnController: controller,);
    await pumpWidget(tester, MaterialApp(home: Material(child: countdownWidget)));
    final snackbar = find.byType(SnackBar);
    //expect(snackbar, findsOneWidget);
  });


}