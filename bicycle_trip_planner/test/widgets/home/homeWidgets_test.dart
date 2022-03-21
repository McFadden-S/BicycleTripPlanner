import 'dart:io';

import 'package:bicycle_trip_planner/widgets/general/CurrentLocationButton.dart';
import 'package:bicycle_trip_planner/widgets/general/GroupSizeSelector.dart';
import 'package:bicycle_trip_planner/widgets/home/Home.dart';
import 'package:bicycle_trip_planner/widgets/home/HomeWidgets.dart';
import 'package:bicycle_trip_planner/widgets/home/StationBar.dart';
import 'package:bicycle_trip_planner/widgets/routeplanning/RouteCard.dart';
import 'package:bicycle_trip_planner/widgets/routeplanning/RoutePlanning.dart';
import 'package:bicycle_trip_planner/widgets/settings/SettingsScreen.dart';
import 'package:bicycle_trip_planner/widgets/weather/weather.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../setUp.dart';
import '../login/mock.dart';


void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    HttpOverrides.global = null;
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

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

  testWidgets("HomeWidgets has a bottom StationBar", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: HomeWidgets())));
    expect(find.byType(StationBar), findsOneWidget);
  });

  testWidgets("HomeWidgets has a weather widget", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: HomeWidgets())));
    expect(find.byType(Weather), findsOneWidget);
  });


  testWidgets('settings button navigate user to settings screen',
          (WidgetTester tester) async {
        await pumpWidget(tester, MaterialApp(
            home: Material(child: HomeWidgets()),
        ));

        expect(find.byKey(Key('settingsButton')), findsOneWidget);
        await tester.tap(find.byKey(Key('settingsButton')));
        await tester.pumpAndSettle();

        // check that we are in settings screen
        expect(find.byType(SettingsScreen), findsOneWidget);

        //check that we are no longer in home screen
        expect(find.byType(Home), findsNothing);
        //check that there are no homeWidgets on the screen
        expect(find.byKey(Key('settingsButton')), findsNothing);
        expect(find.byType(CurrentLocationButton), findsNothing);
        expect(find.byType(GroupSizeSelector), findsNothing);
        expect(find.byKey(Key("navigateToRoutePlanningScreenButton")), findsNothing);

      });


  testWidgets('Go to routePlanning button loads routePlanning widgets',
          (WidgetTester tester) async {
        await pumpWidget(tester, MaterialApp(
          home: Material(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Home(),
            ),
          ),
        ));

        expect(find.byKey(Key('navigateToRoutePlanningScreenButton')), findsOneWidget);
        await tester.tap(find.byKey(Key('navigateToRoutePlanningScreenButton')));
        await tester.pumpAndSettle();

        // // check that we have routePlanning widgets on screen
         expect(find.byType(RoutePlanning), findsOneWidget);
        //
        // //check that we no longer have homeWidgets
        expect(find.byType(HomeWidgets), findsNothing);

        //check that there are no homeWidgets on the screen
        expect(find.byKey(Key('settingsButton')), findsNothing);
        expect(find.byKey(Key("navigateToRoutePlanningScreenButton")), findsNothing);

      });

  //
  // testWidgets('GroupSizeSelector has correct initial value and behaves correctly',
  //         (WidgetTester tester) async {
  //       await pumpWidget(tester, MaterialApp(
  //         home: Material(child: GroupSizeSelector()),
  //       ));
  //
  //       expect(find.byKey(Key("groupSizeSelector")), findsOneWidget);
  //       expect(find.text("1"), findsOneWidget);
  //       await tester.tap(find.byKey(Key("groupSizeSelector")));
  //       // await tester.pumpAndSettle();
  //
  //
  //
  //     });

}

