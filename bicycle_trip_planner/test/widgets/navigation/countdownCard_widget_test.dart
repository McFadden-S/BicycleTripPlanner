
import 'package:bicycle_trip_planner/widgets/navigation/CountdownCard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timer_count_down/timer_controller.dart';

import '../../managers/firebase_mocks/firebase_auth_mocks.dart';
import '../../setUp.dart';

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    HttpOverrides.global = null;
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  });

  testWidgets("Countdown card contains a card", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: CountdownCard(ctdwnController: CountdownController(),))));
    final card = find.byType(Card);

    expect(card, findsOneWidget);
  });
}