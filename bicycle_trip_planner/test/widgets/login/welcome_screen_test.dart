import 'package:bicycle_trip_planner/widgets/Login/AuthenticationScreen.dart';
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

  testWidgets("Welcome screen has a login button", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: AuthenticationScreen()));
    expect(find.byKey(ValueKey("Login")), findsOneWidget);
  });

  testWidgets("Welcome screen has a signup button", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: AuthenticationScreen()));
    expect(find.byKey(ValueKey("SignUp")), findsOneWidget);
  });

  // testWidgets("Login Screen has a logout button", (WidgetTester tester) async {
  //   await pumpWidget(tester, MaterialApp(home: WelcomeScreen()));
  //   expect(find.byKey(ValueKey("LogOut")), findsOneWidget);
  // });

  testWidgets("Welcome screen has a google sign in button", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: AuthenticationScreen()));
    expect(find.byKey(ValueKey("googleLogin")), findsOneWidget);
  });
}


