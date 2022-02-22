import 'package:flutter/material.dart';
import 'package:prototypes/screens/Login/body.dart';
import 'package:prototypes/screens/components/rounded_password_field.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prototypes/screens/Login/login_screen.dart';


final auth = MockFirebaseAuth();


Widget makeTestableWidget({required Widget child, required MockFirebaseAuth auth}) {
  return AuthProvider(
    auth: auth,
    child: MaterialApp(
      home: child,
    ),
  );
}

void main(){
  Firebase.initializeApp();
  testWidgets("test password field in login page", (WidgetTester tester) async{

    await tester.pumpWidget(MaterialApp(home: LoginScreen()));
    Finder field = find.byKey(ValueKey("test"));

    expect(field,findsOneWidget);


  });
}