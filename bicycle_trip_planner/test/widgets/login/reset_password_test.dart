import 'package:bicycle_trip_planner/widgets/settings/ForgotPasswordScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../setUp.dart';
import 'mock.dart';
import 'reset_password_test.mocks.dart';

@GenerateMocks([FirebaseAuth])
void main() {
  setupFirebaseAuthMocks();

  final auth = MockFirebaseAuth();


  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets("Reset Password screen has an email field", (WidgetTester tester) async {

    await pumpWidget(tester, MaterialApp(home: ForgotPasswordScreen()));
    expect(find.byKey(ValueKey("emailField")), findsOneWidget);
  });

  testWidgets("Reset Password screen has a reset button", (WidgetTester tester) async {
    final email = "hi";
    await pumpWidget(tester, MaterialApp(home: ForgotPasswordScreen(auth: auth, email: email)));

    final widget = find.byKey(ValueKey("reset"));
    expect(widget, findsOneWidget);

    await tester.tap(widget);
    await tester.pump();

    verify(auth.sendPasswordResetEmail(email: "hi"));
  });

  testWidgets("Reset Password screen has a back button", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: ForgotPasswordScreen()));
    expect(find.byKey(ValueKey("back")), findsOneWidget);
  });
}