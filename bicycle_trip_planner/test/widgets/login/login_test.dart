import 'package:bicycle_trip_planner/widgets/settings/LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../setUp.dart';
import 'login_test.mocks.dart';
import 'mock.dart';

@GenerateMocks([FirebaseAuth, UserCredential])
void main() {
  final userCred = MockUserCredential();
  final auth = MockFirebaseAuth();
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets("Login screen has an email field", (WidgetTester tester) async {

    await pumpWidget(tester, MaterialApp(home: LoginScreen()));
    var widget = find.byKey(ValueKey("emailField"));
    expect(widget, findsOneWidget);

    await tester.enterText(widget, "test");
    await tester.pump();
    
    expect(find.text("test"), findsOneWidget);
  });

  testWidgets("Login screen has a password field", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: LoginScreen()));
    var widget = find.byKey(ValueKey("passwordField"));
    expect(widget, findsOneWidget);

    await tester.enterText(widget, "test");
    await tester.pump();

    expect(find.text("test"), findsOneWidget);
  });

  testWidgets("Login Screen has a login button and incorrect auth credentials", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: LoginScreen(auth: auth)));
    final widget = find.byKey(ValueKey("login"));
    expect(widget, findsOneWidget);

    await tester.tap(widget);
    await tester.pump();
    verifyNever(auth.signInWithEmailAndPassword());
  });

  testWidgets("Login Screen has correct auth credentials",(WidgetTester tester) async{
    const email = "hello";
    const password = "bye";

    await pumpWidget(tester, MaterialApp(home: LoginScreen(auth: auth, email: email, password: password,)));
    final widget = find.byKey(ValueKey("login"));
    expect(widget, findsOneWidget);

    when(auth.signInWithEmailAndPassword(email: email, password: password)).thenAnswer((realInvocation) async=> userCred);
    await tester.tap(widget);
    await tester.pump();

    await untilCalled(auth.signInWithEmailAndPassword(email: email, password: password));
    verify(auth.signInWithEmailAndPassword(email: email, password: password));
  });

  testWidgets("Login screen has a signup button", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: LoginScreen()));
    final widget = find.byKey(ValueKey("signUp"));
    expect(widget, findsOneWidget);

    await tester.tap(widget);
    await tester.pump();

    expect(widget, findsOneWidget);
  });

  testWidgets("Login screen has a reset password button", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: LoginScreen()));
    final widget = find.byKey(ValueKey("resetPassword"));
    expect(widget, findsOneWidget);
    await tester.tap(widget);
  });

  testWidgets("Login screen has a back button", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: LoginScreen()));
    expect(find.byKey(ValueKey("back")), findsOneWidget);
  });

}