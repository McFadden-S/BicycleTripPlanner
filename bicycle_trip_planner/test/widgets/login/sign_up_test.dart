import 'package:bicycle_trip_planner/widgets/Login/SignUpScreen.dart';
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

  testWidgets("Sign up screen has an email field", (WidgetTester tester) async {

    await pumpWidget(tester, MaterialApp(home: SignUpScreen()));
    expect(find.byKey(ValueKey("emailField")), findsOneWidget);
  });

  testWidgets("Sign up screen has a password field", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: SignUpScreen()));
    expect(find.byKey(ValueKey("passwordField")), findsOneWidget);
  });

  testWidgets("Sign up Screen has a confirm password field", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: SignUpScreen()));
    expect(find.byKey(ValueKey("confirmPasswordField")), findsOneWidget);
  });

  testWidgets("Sign up screen has a signup button", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: SignUpScreen()));
    expect(find.byKey(ValueKey("signUp")), findsOneWidget);
  });

  testWidgets("Sign up screen has a back button", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: SignUpScreen()));
    expect(find.byKey(ValueKey("back")), findsOneWidget);
  });
}