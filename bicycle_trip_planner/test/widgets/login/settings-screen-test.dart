import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/managers/UserSettings.dart';
import 'package:bicycle_trip_planner/models/distance_types.dart';
import 'package:bicycle_trip_planner/widgets/settings/SettingsScreen.dart';
import 'package:bicycle_trip_planner/widgets/settings/SignUpScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database_mocks/firebase_database_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../setUp.dart';
import 'settings-screen-test.mocks.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

@GenerateMocks([UserSettings, FirebaseAuth, User, ApplicationBloc])
void main(){
  setupFirebaseMocks();
  late NavigatorObserver mockObserver;
  setUpAll(() async{
    mockObserver = MockNavigatorObserver();
    await Firebase.initializeApp();
  });

  final bloc = MockApplicationBloc();
  final user = MockUser();
  final settings = MockUserSettings();
  final auth = MockFirebaseAuth();

  when(auth.currentUser).thenAnswer((realInvocation) => user);
  when(user.email).thenAnswer((realInvocation) => "mockuser@email.org");
  when(settings.stationsRefreshRate()).thenAnswer((realInvocation) => 30);
  when(settings.nearbyStationsRange()).thenAnswer((realInvocation) async=> 5.0);
  when(settings.distanceUnit()).thenAnswer((realInvocation) async=> DistanceType.km);

  testWidgets("Test information button", (WidgetTester tester) async{
    await pumpWidget(tester, MaterialApp(home: SettingsScreen(settings: settings, auth: auth, bloc: bloc,)));
    final widget = find.byKey(ValueKey("infoButton"));
    expect(widget, findsOneWidget);
    
    await tester.tap(widget);
    await tester.pump();

    final newWidget = find.byKey(ValueKey("informationText"));
    expect(newWidget, findsOneWidget);
  });

  testWidgets("Get logout button", (WidgetTester tester) async{
    await pumpWidget(tester,  MaterialApp(home: SettingsScreen(settings: settings, auth: auth, bloc: bloc)));
    final widget = find.byKey(ValueKey("logOut"));
    expect(widget, findsOneWidget);

    await untilCalled(auth.currentUser);
    when(auth.currentUser).thenAnswer((realInvocation) => null);

    await tester.tap(widget);
    await tester.pump();

    final newWidget = find.byKey(ValueKey("logIn"));
    expect(newWidget, findsOneWidget);
  });

  testWidgets("Get log in button", (WidgetTester tester) async{
    when(auth.currentUser).thenAnswer((realInvocation) => null);
    await pumpWidget(tester, MaterialApp(home: SettingsScreen(settings: settings, auth: auth, bloc: bloc)));
    final widget = find.byKey(ValueKey("logIn"));
    expect(widget, findsOneWidget);

    await untilCalled(auth.currentUser);
    when(auth.currentUser).thenAnswer((realInvocation) => user);

    await tester.tap(widget);
    await tester.pump();

    final newWidget = find.byKey(ValueKey("logOut"));
    expect(newWidget, findsOneWidget);

  });

  testWidgets("Get sign up button", (WidgetTester tester) async{
    when(auth.currentUser).thenAnswer((realInvocation) => null);
    await pumpWidget(tester, MaterialApp(home: SettingsScreen(settings: settings, auth: auth, bloc: bloc)));
    final widget = find.byKey(ValueKey("signUp"));
    expect(widget, findsOneWidget);

    await tester.tap(widget);
    await tester.pumpAndSettle();

    expect(find.byType(SignUpScreen), findsOneWidget);
  });

  testWidgets("Get stations update rate dropdown ", (WidgetTester tester) async{
    await pumpWidget(tester, MaterialApp(home: SettingsScreen(settings: settings, auth: auth, bloc: bloc)));
    final widget = find.byKey(ValueKey("stationUpdate"));
    expect(widget, findsOneWidget);
  });

  testWidgets("Get stations update rate dropdown ", (WidgetTester tester) async{
    await pumpWidget(tester, MaterialApp(home: SettingsScreen(settings: settings, auth: auth, bloc: bloc)));
    final widget = find.byKey(ValueKey("nearbyStation"));
    expect(widget, findsOneWidget);
  });

  testWidgets("Get stations update rate dropdown ", (WidgetTester tester) async{
    await pumpWidget(tester, MaterialApp(home: SettingsScreen(settings: settings, auth: auth, bloc: bloc)));
    final widget = find.byKey(ValueKey("distance"));
    expect(widget, findsOneWidget);
  });
}