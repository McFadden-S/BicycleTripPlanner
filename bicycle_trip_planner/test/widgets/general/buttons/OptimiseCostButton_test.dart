import 'dart:io';

import 'package:bicycle_trip_planner/managers/DialogManager.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/widgets/general/buttons/CircleButton.dart';
import 'package:bicycle_trip_planner/widgets/general/buttons/OptimiseCostButton.dart';
import 'package:bicycle_trip_planner/widgets/general/buttons/RoundedRectangleButton.dart';
import 'package:bicycle_trip_planner/widgets/general/dialogs/BinaryChoiceDialog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../bloc/application_bloc_test.mocks.dart';
import '../../../setUp.dart';
import '../../../managers/firebase_mocks/firebase_auth_mocks.dart';

void main() {

  setupFirebaseAuthMocks();

  setUpAll(() async {
    HttpOverrides.global = null;
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  });

  testWidgets("OptimiseCostButton is a button", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: OptimiseCostButton())));

    final button = find.byType(OptimiseCostButton);

    expect(button, findsOneWidget);
  });

  testWidgets("OptimiseCostButton has an icon", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: OptimiseCostButton())));

    final icon = find.byIcon(Icons.money_off);

    expect(icon, findsOneWidget);
  });

  testWidgets("OptimiseCostButton has an icon button", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: OptimiseCostButton())));

    final button = find.widgetWithIcon(CircleButton, Icons.money_off);

    expect(button, findsOneWidget);
  });

  testWidgets("OptimiseCostButton shows a binary choice when pressed", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: Stack(children: [OptimiseCostButton(), BinaryChoiceDialog()],))));

    final button = find.widgetWithIcon(CircleButton, Icons.money_off);
    expect(button, findsOneWidget);

    MockDialogManager dialogManager = getAppBloc().getDialogManager();
    when(dialogManager.showBinaryChoice()).thenAnswer((realInvocation) {DialogManager().showBinaryChoice();});

    await tester.tap(button);
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(Duration(seconds: 4));

    expect(DialogManager.instance.ifShowingBinaryChoice(), true);
  });

  testWidgets("OptimiseCostButton optimises route when yes button clicked", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: Stack(children: [OptimiseCostButton(), BinaryChoiceDialog()],))));

    final button = find.widgetWithIcon(CircleButton, Icons.money_off);
    expect(button, findsOneWidget);

    MockDialogManager dialogManager = getAppBloc().getDialogManager();
    when(dialogManager.showBinaryChoice()).thenAnswer((realInvocation) {DialogManager().showBinaryChoice();});

    await tester.tap(button);
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(Duration(seconds: 4));

    expect(DialogManager.instance.ifShowingBinaryChoice(), true);

    final yesButton = find.widgetWithText(ElevatedButton, 'Yes');
    expect(yesButton, findsOneWidget);

    MockRouteManager routeManager = getAppBloc().getRouteManager();
    when(routeManager.setCostOptimised(true)).thenAnswer((realInvocation) {RouteManager().setCostOptimised(true);});

    await tester.tap(yesButton);
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(Duration(seconds: 4));

    expect(RouteManager.instance.ifCostOptimised(), true);
  });

}