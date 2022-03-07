import 'package:bicycle_trip_planner/widgets/Login/forgot_password_screen.dart';
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

  testWidgets("Reset Password screen has an email field", (WidgetTester tester) async {

    await pumpWidget(tester, MaterialApp(home: ForgotPasswordScreen()));
    expect(find.byKey(ValueKey("emailField")), findsOneWidget);
  });

  testWidgets("Reset Password screen has a reset button", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: ForgotPasswordScreen()));
    expect(find.byKey(ValueKey("reset")), findsOneWidget);
  });

  testWidgets("Reset Password screen has a back button", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: ForgotPasswordScreen()));
    expect(find.byKey(ValueKey("back")), findsOneWidget);
  });
}