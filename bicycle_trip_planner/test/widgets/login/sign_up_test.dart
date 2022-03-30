import 'package:bicycle_trip_planner/widgets/settings/SignUpScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../setUp.dart';
import 'mock.dart';
import 'sign_up_test.mocks.dart';

@GenerateMocks([FirebaseAuth, UserCredential])
void main() {
  setupFirebaseAuthMocks();

  final auth = MockFirebaseAuth();
  final credential = MockUserCredential();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets("Sign up screen has an email field", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: SignUpScreen()));
    final widget = find.byKey(ValueKey("emailField"));
    expect(widget, findsOneWidget);

    await tester.enterText(widget, "Hello");
    expect(find.text("Hello"), findsOneWidget);
  });

  testWidgets("Sign up screen has a password field", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: SignUpScreen()));
    final widget = find.byKey(ValueKey("passwordField"));
    expect(widget, findsOneWidget);

    await tester.enterText(widget, "Test");
    expect(find.text("Test"), findsOneWidget);
  });

  testWidgets("Sign up Screen has a confirm password field", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: SignUpScreen()));
    final widget = find.byKey(ValueKey("confirmPasswordField"));
    expect(widget, findsOneWidget);

    await tester.enterText(widget, "Test2");
    expect(find.text("Test2"), findsOneWidget);
  });

  testWidgets("Can sign up with correct details", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: SignUpScreen(auth: auth)));
    final widget = find.byKey(ValueKey("signUp"));
    expect(widget, findsOneWidget);

    final emailField = find.byKey(ValueKey("emailField"));
    final passwordField = find.byKey(ValueKey("passwordField"));
    final confirmPasswordField = find.byKey(ValueKey("confirmPasswordField"));

    final email = "Email";
    final password = "password";

    await tester.enterText(emailField, email);
    await tester.enterText(passwordField, password);
    await tester.enterText(confirmPasswordField, password);

    when(auth.createUserWithEmailAndPassword(email: email,password: password)).thenAnswer((realInvocation) async=> credential);
    await tester.tap(widget);

    verify(auth.createUserWithEmailAndPassword(email: email,password: password));
  });
  
  testWidgets("Passwords do not match on sign up", (WidgetTester tester) async{
    await pumpWidget(tester, MaterialApp(home: SignUpScreen(auth: auth)));
    final widget = find.byKey(ValueKey("signUp"));
    final emailField = find.byKey(ValueKey("emailField"));
    final passwordField = find.byKey(ValueKey("passwordField"));
    final confirmPasswordField = find.byKey(ValueKey("confirmPasswordField"));

    final email = "Email";
    final password = "password";

    await tester.enterText(emailField, email);
    await tester.enterText(passwordField, password);
    await tester.enterText(confirmPasswordField, password);

    when(auth.createUserWithEmailAndPassword(email: email,password: password)).thenAnswer((realInvocation) async=> credential);
    await tester.tap(widget);

    verify(auth.createUserWithEmailAndPassword(email: email,password: password));
  });

  testWidgets("Sign up screen has a back button", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: SignUpScreen()));
    expect(find.byKey(ValueKey("back")), findsOneWidget);
  });
}