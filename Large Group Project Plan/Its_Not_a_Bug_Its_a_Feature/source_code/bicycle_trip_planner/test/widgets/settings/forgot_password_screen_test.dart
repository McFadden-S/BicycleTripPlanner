import 'package:bicycle_trip_planner/widgets/settings/ForgotPasswordScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../setUp.dart';
import 'mocks/mock.dart';
import 'mocks/reset_password_test.mocks.dart';

@GenerateMocks([FirebaseAuth])
void main() {
  setupFirebaseAuthMocks();

  final auth = MockFirebaseAuth();
  String email = "Email";

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets("Reset Password screen initialises email correctly",
      (WidgetTester tester) async {
    await pumpWidget(tester,
        MaterialApp(home: ForgotPasswordScreen(auth: auth, email: email)));
    final forgotPasswordScreen =
        tester.widget<ForgotPasswordScreen>(find.byType(ForgotPasswordScreen));

    expect(forgotPasswordScreen.email, email);
  });

  testWidgets("Reset Password screen initialises email correctly by default",
      (WidgetTester tester) async {
    await pumpWidget(
        tester, MaterialApp(home: ForgotPasswordScreen(auth: auth)));
    final forgotPasswordScreen =
        tester.widget<ForgotPasswordScreen>(find.byType(ForgotPasswordScreen));

    expect(forgotPasswordScreen.email, "");
  });

  testWidgets(
      "Reset Password screen initialises auth correctly when given an email",
      (WidgetTester tester) async {
    await pumpWidget(tester,
        MaterialApp(home: ForgotPasswordScreen(auth: auth, email: email)));
    final forgotPasswordScreen =
        tester.widget<ForgotPasswordScreen>(find.byType(ForgotPasswordScreen));

    expect(forgotPasswordScreen.auth, auth);
  });

  testWidgets("Reset Password screen has an email field",
      (WidgetTester tester) async {
    await pumpWidget(tester,
        MaterialApp(home: ForgotPasswordScreen(auth: auth, email: email)));
    expect(find.byKey(const ValueKey("emailField")), findsOneWidget);
  });

  testWidgets("Reset Password screen has a reset button",
      (WidgetTester tester) async {
    await pumpWidget(tester,
        MaterialApp(home: ForgotPasswordScreen(auth: auth, email: email)));

    final widget = find.byKey(ValueKey("reset"));
    expect(widget, findsOneWidget);
  });

  testWidgets(
      "Pressing Reset Password with a valid email displays correct message",
      (WidgetTester tester) async {
    email = "valid@example.org";
    await pumpWidget(tester,
        MaterialApp(home: ForgotPasswordScreen(auth: auth, email: email)));

    final widget = find.byKey(ValueKey("reset"));

    await tester.tap(widget);
    await tester.pumpAndSettle();

    final text = find.text("Email sent to reset password");
    expect(text, findsOneWidget);

    verify(auth.sendPasswordResetEmail(email: email));
  });

  testWidgets(
      "Pressing Reset Password with a blank email displays correct error message",
      (WidgetTester tester) async {
    await pumpWidget(
        tester, MaterialApp(home: ForgotPasswordScreen(auth: auth)));

    final widget = find.byKey(ValueKey("reset"));

    FirebaseException exception =
        FirebaseException(plugin: "Firebase", code: "unknown");

    when(auth.sendPasswordResetEmail(email: "")).thenThrow(exception);

    await tester.tap(widget);
    await tester.pump();

    final textDoesNotExist = find.text("Email sent to reset password");
    expect(textDoesNotExist, findsNothing);

    final textExists =
        find.text("One of the fields is empty. Please try again");
    expect(textExists, findsOneWidget);
  });

  testWidgets(
      "Pressing Reset Password with an invalid email does not send it to their email",
      (WidgetTester tester) async {
    email = "invalidEmail";
    clearInteractions(auth);
    await pumpWidget(tester,
        MaterialApp(home: ForgotPasswordScreen(auth: auth, email: email)));

    final widget = find.byKey(ValueKey("reset"));

    FirebaseException exception =
        FirebaseException(plugin: "Firebase", code: "invalid-email");

    when(auth.sendPasswordResetEmail(email: email)).thenThrow(exception);

    await tester.tap(widget);
    await tester.pump();

    final textDoesNotExist = find.text("Email sent to reset password");
    expect(textDoesNotExist, findsNothing);

    final textExists = find.text("Email address entered is invalid");
    expect(textExists, findsOneWidget);
  });

  testWidgets("Reset Password screen has a back button",
      (WidgetTester tester) async {
    await pumpWidget(tester,
        MaterialApp(home: ForgotPasswordScreen(auth: auth, email: email)));
    expect(find.byKey(ValueKey("back")), findsOneWidget);
  });
}
