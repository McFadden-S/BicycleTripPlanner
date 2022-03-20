import 'dart:io';

import 'package:bicycle_trip_planner/widgets/general/BinaryChoiceDialog.dart';
import 'package:bicycle_trip_planner/widgets/general/CurrentLocationButton.dart';
import 'package:bicycle_trip_planner/widgets/general/GroupSizeSelector.dart';
import 'package:bicycle_trip_planner/widgets/general/MapWidget.dart';
import 'package:bicycle_trip_planner/widgets/general/Search.dart';
import 'package:bicycle_trip_planner/widgets/general/SelectStationDialog.dart';
import 'package:bicycle_trip_planner/widgets/home/HomeWidgets.dart';
import 'package:bicycle_trip_planner/widgets/home/HomeWidgets.dart';
import 'package:bicycle_trip_planner/widgets/home/StationBar.dart';
import 'package:bicycle_trip_planner/widgets/routeplanning/RoutePlanning.dart';
import 'package:bicycle_trip_planner/widgets/settings/SettingsScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../setUp.dart';
import '../login/mock.dart';


void main() {
  setupFirebaseAuthMocks();
  late NavigatorObserver mockObserver;

  setUpAll(() async {
    HttpOverrides.global = null;
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    mockObserver = MockNavigatorObserver();
  });

  testWidgets("HomeWidgets has a stack", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: HomeWidgets())));
    expect(find.byType(Stack), findsWidgets);
  });

  testWidgets("HomeWidgets has a safeArea", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: HomeWidgets())));
    expect(find.byType(SafeArea), findsOneWidget);
  });

  testWidgets("HomeWidgets has a top Align", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: HomeWidgets())));
    expect(find.byKey(Key("topAlignment"),), findsOneWidget);
  });

  testWidgets("HomeWidgets has a bottom Align", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: HomeWidgets())));
    expect(find.byKey(Key("bottomAlignment"),), findsOneWidget);
  });

  testWidgets("HomeWidgets has a settings button", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: HomeWidgets())));
    expect(find.widgetWithIcon(IconButton, Icons.settings), findsOneWidget);
  });

  testWidgets("HomeWidgets has a CurrentLocationButton", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: HomeWidgets())));
    expect(find.byType(CurrentLocationButton), findsOneWidget);
  });

  testWidgets("HomeWidgets has GroupSizeSelector", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: HomeWidgets())));
    expect(find.byType(GroupSizeSelector), findsOneWidget);
  });

  testWidgets("HomeWidgets has a navigateToRoutePlanningScreenButton", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: HomeWidgets())));
    expect(find.byKey(Key("navigateToRoutePlanningScreenButton")), findsOneWidget);
  });

  testWidgets("Home has a bottom StationBar", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: HomeWidgets())));
    expect(find.byType(StationBar), findsOneWidget);
  });

  // testWidgets('settings button navigate user to settings screen',
  //         (WidgetTester tester) async {
  //       await pumpWidget(tester, MaterialApp(
  //           home: Material(child: HomeWidgets()),
  //           navigatorObservers: [mockObserver],
  //       ));
  //       expect(find.byKey(Key('settingsButton')), findsOneWidget);
  //       await tester.tap(find.byKey(Key('settingsButton')));
  //       await tester.pumpAndSettle();
  //
  //       /// Verify that a push event happened
  //       verify(mockObserver.didPush(
  //           MaterialPageRoute(builder: (BuildContext context) => SettingsScreen()),
  //           any));
  //
  //       /// You'd also want to be sure that your page is now
  //       /// present in the screen.
  //       expect(find.byType(SettingsScreen), findsOneWidget);
  //     });

}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}