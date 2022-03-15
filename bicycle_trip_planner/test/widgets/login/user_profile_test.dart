import 'package:bicycle_trip_planner/widgets/Login/UserProfile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../setUp.dart';
import 'mock.dart';

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets("Authentication screen has a logout button",
      (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: UserProfile()));
    expect(find.byKey(ValueKey("Logout")), findsOneWidget);
  });

  testWidgets("Authentication screen has a back button",
      (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: UserProfile()));
    expect(find.byKey(ValueKey("Back")), findsOneWidget);
  });
}
