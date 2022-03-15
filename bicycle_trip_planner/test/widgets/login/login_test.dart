import 'package:bicycle_trip_planner/widgets/Login/LoginScreen.dart';
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

  testWidgets("Login screen has an email field", (WidgetTester tester) async {

    await pumpWidget(tester, MaterialApp(home: LoginScreen()));
    expect(find.byKey(ValueKey("emailField")), findsOneWidget);
  });

  testWidgets("Login screen has a password field", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: LoginScreen()));
    expect(find.byKey(ValueKey("passwordField")), findsOneWidget);
  });

  testWidgets("Login Screen has a login button", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: LoginScreen()));
    expect(find.byKey(ValueKey("login")), findsOneWidget);
  });

  testWidgets("Login screen has a signup button", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: LoginScreen()));
    expect(find.byKey(ValueKey("signUp")), findsOneWidget);
  });

  testWidgets("Login screen has a reset password button", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: LoginScreen()));
    expect(find.byKey(ValueKey("resetPassword")), findsOneWidget);
  });

  testWidgets("Login screen has a back button", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: LoginScreen()));
    expect(find.byKey(ValueKey("back")), findsOneWidget);
  });
}