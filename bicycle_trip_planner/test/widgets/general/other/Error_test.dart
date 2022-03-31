import 'dart:io';

import 'package:bicycle_trip_planner/widgets/general/other/Error.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../setUp.dart';
import '../../../managers/firebase_mocks/firebase_auth_mocks.dart';

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    HttpOverrides.global = null;
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  });

  testWidgets("Error is a scaffold", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: Error())));

    final scaffold = find.byType(Scaffold);

    expect(scaffold, findsOneWidget);
  });

  testWidgets("Scaffold is grey 900", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: Error())));

    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));

    expect(scaffold.backgroundColor, Colors.grey[900]);
  });

  testWidgets("Error contains a column", (WidgetTester tester) async{
    await pumpWidget(tester, MaterialApp(home: Material(child: Error())));
    final columnWidget = find.byType(Column);

    expect(columnWidget, findsOneWidget);
  });

  testWidgets("Column widgets are centered", (WidgetTester tester) async{
    await pumpWidget(tester, MaterialApp(home: Material(child: Error())));
    final column = tester.widget<Column>(find.byType(Column));

    expect(column.crossAxisAlignment, CrossAxisAlignment.center);
    expect(column.mainAxisAlignment, MainAxisAlignment.center);
  });

  testWidgets("Error contains a SpinKitFadingCube", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: Error())));

    final spinKitFadingCube = find.byType(SpinKitFadingCube);

    expect(spinKitFadingCube, findsOneWidget);
  });

  testWidgets("SpinKit is white", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: Error())));

    final spinKitFadingCube = tester.widget<SpinKitFadingCube>(find.byType(SpinKitFadingCube));

    expect(spinKitFadingCube.color, Colors.white);
  });

  testWidgets("SpinKit is of size 50", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: Error())));

    final spinKitFadingCube = tester.widget<SpinKitFadingCube>(find.byType(SpinKitFadingCube));

    expect(spinKitFadingCube.size, 50.0);
  });


  testWidgets("Error contains a text widget", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: Error())));

    final textWidget = find.byType(Text);

    expect(textWidget, findsOneWidget);
  });

  testWidgets("Error text contains correct text", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: Error())));

    final text = tester.widget<Text>(find.byType(Text));

    expect(text.data, 'No connection...');
  });

  testWidgets("Error text contains a WillPopScope ", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: Error())));

    final willPopScope = find.byType(WillPopScope);

    expect(willPopScope, findsOneWidget);
  });

  testWidgets("Error contains a sized box", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: Error())));

    final sizedBoxWidget = find.byKey(ValueKey("SizedBox"));

    expect(sizedBoxWidget, findsOneWidget);
  });

  testWidgets("Sized box ha a height of 25", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: Error())));

    final sizedBox = tester.widget<SizedBox>(find.byKey(ValueKey("SizedBox")));

    expect(sizedBox.height, 25);
  });
}