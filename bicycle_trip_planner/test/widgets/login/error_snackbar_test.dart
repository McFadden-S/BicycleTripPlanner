import 'package:bicycle_trip_planner/widgets/settings/LoginScreen.dart';
import 'package:bicycle_trip_planner/widgets/settings/components/ErrorSnackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../setUp.dart';

void main() {
  String errorMessage = "Error";

  Future<void> _createErrorSnackBar(WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Scaffold(body: Builder(
      builder: (BuildContext context) {
        return GestureDetector(
            onTap: () =>
                ErrorSnackBar.buildErrorSnackbar(context, errorMessage),
            behavior: HitTestBehavior.opaque);
      },
    ))));
  }

  setUp(() {
    errorMessage = "Error";
  });

  test('errorMessage "wrong-password" returns correct output', () {
    String errorOutput = ErrorSnackBar.errorMessage("wrong-password");
    expect(errorOutput, "Incorrect password. Please try again");
  });

  test('errorMessage "unknown" returns correct output', () {
    String errorOutput = ErrorSnackBar.errorMessage("unknown");
    expect(errorOutput, "One of the fields is empty. Please try again");
  });

  test('errorMessage "invalid-email" returns correct output', () {
    String errorOutput = ErrorSnackBar.errorMessage("invalid-email");
    expect(errorOutput, "Email address entered is invalid");
  });

  test('errorMessage "weak-password" returns correct output', () {
    String errorOutput = ErrorSnackBar.errorMessage("weak-password");
    expect(errorOutput, "Password must contain at least 6 characters");
  });

  test('errorMessage "passwords-do-not-match" returns correct output', () {
    String errorOutput = ErrorSnackBar.errorMessage("passwords-do-not-match");
    expect(errorOutput, "Passwords do not match");
  });

  test('errorMessage "user-not-found" returns correct output', () {
    String errorOutput = ErrorSnackBar.errorMessage("user-not-found");
    expect(errorOutput, "User not found. Please try again");
  });

  test('errorMessage "password-reset-sent" returns correct output', () {
    String errorOutput = ErrorSnackBar.errorMessage("password-reset-sent");
    expect(errorOutput, "Email sent to reset password");
  });

  testWidgets("buildErrorSnackbar shows snackbar with given message",
      (WidgetTester tester) async {
    await _createErrorSnackBar(tester);

    final detector = find.byType(GestureDetector);
    final snackbarText = find.text(errorMessage);

    expect(snackbarText, findsNothing);
    await tester.tap(detector);
    await tester.pumpAndSettle();
    expect(snackbarText, findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 5));
    expect(snackbarText, findsNothing);
  });

  testWidgets(
      "buildErrorSnackbar shows snackbar twice with two different messages",
      (WidgetTester tester) async {
    await _createErrorSnackBar(tester);

    final detector = find.byType(GestureDetector);
    var snackbarText = find.text(errorMessage);

    expect(snackbarText, findsNothing);
    await tester.tap(detector);
    await tester.pumpAndSettle();
    expect(snackbarText, findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 5));
    expect(snackbarText, findsNothing);

    errorMessage = "New error";
    snackbarText = find.text(errorMessage);

    expect(snackbarText, findsNothing);
    await tester.tap(detector);
    await tester.pumpAndSettle();
    expect(snackbarText, findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 5));
    expect(snackbarText, findsNothing);
  });
}
