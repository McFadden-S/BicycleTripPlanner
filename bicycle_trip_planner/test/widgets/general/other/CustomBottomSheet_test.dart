import 'dart:io';

import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/widgets/general/buttons/EndRouteButton.dart';
import 'package:bicycle_trip_planner/widgets/general/other/CustomBottomSheet.dart';
import 'package:bicycle_trip_planner/widgets/general/other/DistanceETACard.dart';
import 'package:bicycle_trip_planner/widgets/navigation/Navigation.dart';
import 'package:bicycle_trip_planner/widgets/navigation/WalkOrCycleToggle.dart';
import 'package:bicycle_trip_planner/widgets/routeplanning/RoutePlanning.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../setUp.dart';
import '../../login/mock.dart';

void main() {
  setupFirebaseAuthMocks();

  bool ifLoading =true;

  setUpAll(() async {
    HttpOverrides.global = null;
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  });

  ApplicationBloc appBloc = getAppBloc();

  bool isLoading(){
    return ifLoading;
  }

  Future<void> _createDefaultCustomBottomSheet(WidgetTester tester) async{
    await pumpWidget(tester, MaterialApp(home:
    Material(child:
    CustomBottomSheet(child:
    Container(
    margin: EdgeInsets.only(bottom: 10, right: 5, left: 5),
      child: Row(
        children: [
          Expanded(child: DistanceETACard()),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: EndRouteButton(onPressed: (){},),
                ),
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: WalkOrCycleToggle(),
                    )),
              ],
            ),
          ),
        ],
      ),
    )))));
  }

  Future<void> _createNavigationCustomBottomSheet(WidgetTester tester) async{
    await pumpWidget(tester, MaterialApp(home:
    Material(child:
    CustomBottomSheet(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            SizedBox(width: 10),
            DistanceETACard(),
            SizedBox(width: 10),
            Expanded(child: WalkOrCycleToggle()),
            SizedBox(width: 10),
            Expanded(
              child: EndRouteButton(onPressed: (){}),
            ),
          ],
        ),
      ),
    ),
    )));
  }

  testWidgets("CustomBottomSheet has a container",(WidgetTester tester) async{

    await _createDefaultCustomBottomSheet(tester);
    final detector = find.byType(Container);
    expect(detector, findsWidgets);
  });

  testWidgets("CustomBottomSheet shows an arrow icon", (WidgetTester tester) async {
    await _createNavigationCustomBottomSheet(tester);

    final icon = find.byIcon(Icons.keyboard_arrow_down);

    expect(icon, findsWidgets);
  });

  testWidgets("CustomBottomSheet shows a different arrow icon when tapped", (WidgetTester tester) async {
    await _createNavigationCustomBottomSheet(tester);

    final icon = find.byIcon(Icons.keyboard_arrow_up);

    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();

    expect(icon, findsOneWidget);
  });

  testWidgets("CustomBottomSheet shrinks when first tapped to the correct size", (WidgetTester tester) async {
    await _createNavigationCustomBottomSheet(tester);
    final BuildContext context = tester.element(find.byType(CustomBottomSheet));

    final container = tester.widget<Container>(find.byKey(ValueKey("Secondary internal container")));
    SizedBox? box = container.child as SizedBox;

    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();

    final container2 = tester.widget<Container>(find.byKey(ValueKey("Primary internal container")));

    expect(box.height,MediaQuery.of(context).size.height * 0.12);
    expect(container2.constraints?.maxHeight, MediaQuery.of(context).size.height * 0.05);
  });

  testWidgets("CustomBottomSheet shrinks when first tapped, then expands when tapped again", (WidgetTester tester) async {
    await _createNavigationCustomBottomSheet(tester);
    final BuildContext context = tester.element(find.byType(CustomBottomSheet));

    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();

    final container2 = tester.widget<Container>(find.byKey(ValueKey("Primary internal container")));
    expect(container2.constraints?.maxHeight, MediaQuery.of(context).size.height * 0.05);

    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();

    final container = tester.widget<Container>(find.byKey(ValueKey("Secondary internal container")));
    SizedBox? box = container.child as SizedBox;
    expect(box.height,MediaQuery.of(context).size.height * 0.12);
  });

  testWidgets("CustomBottomSheet has rounded corners with circular radius 30", (WidgetTester tester) async{
    await _createNavigationCustomBottomSheet(tester);
    final container = tester.widget<Container>(find.byKey(ValueKey("Primary container")));
    BoxDecoration? decoration = container.decoration as BoxDecoration;

    expect(decoration.toString(), contains("topLeft: Radius.circular(30.0)"));
    expect(decoration.toString(), contains("topRight: Radius.circular(30.0)"));
  });

  testWidgets("CustomBottomSheet Border Decoration has correct colour", (WidgetTester tester) async{
    await _createNavigationCustomBottomSheet(tester);
    final container = tester.widget<Container>(find.byKey(ValueKey("Primary container")));
    BoxDecoration? decoration = container.decoration as BoxDecoration;

    expect(decoration.color, ThemeStyle.cardColor);
  });

  testWidgets("CustomBottomSheet Border Decoration has correct shadow values", (WidgetTester tester) async{
    await _createNavigationCustomBottomSheet(tester);
    final container = tester.widget<Container>(find.byKey(ValueKey("Primary container")));
    BoxDecoration? decoration = container.decoration as BoxDecoration;

    expect(decoration.boxShadow?.first.color,ThemeStyle.stationShadow);
    expect(decoration.boxShadow?.first.offset,const Offset(0, 0));
    expect(decoration.boxShadow?.first.blurRadius,6.0);
    expect(decoration.boxShadow?.first.spreadRadius,8.0);
  });

  testWidgets("CustomBottomSheet AnimatedSizeAndFade exists ", (WidgetTester tester) async{
    await _createNavigationCustomBottomSheet(tester);
    expect(find.byType(AnimatedSizeAndFade), findsOneWidget);
  });

  testWidgets("CustomBottomSheet AnimatedSizeAndFade has fade duration 300ms of and sizeduration of 300 ms ", (WidgetTester tester) async{
    await _createNavigationCustomBottomSheet(tester);
    final sizeandfade = tester.widget<AnimatedSizeAndFade>(find.byType(AnimatedSizeAndFade));

    expect(sizeandfade.sizeDuration,const Duration(milliseconds: 300));
    expect(sizeandfade.fadeDuration,const Duration(milliseconds: 300));
  });

  testWidgets("CustomBottomSheet minimized container alignment is correct", (WidgetTester tester) async{
    await _createNavigationCustomBottomSheet(tester);
    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();

    final align = tester.widget<Align>(find.byKey(ValueKey("internalAlign1")));

    expect(align.alignment, Alignment.topCenter);
  });

  testWidgets("CustomBottomSheet minimized container icon button has correct values ", (WidgetTester tester) async{
    await _createNavigationCustomBottomSheet(tester);

    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();

    final align = tester.widget<Align>(find.byKey(ValueKey("internalAlign1")));
    IconButton? icon = align.child as IconButton;
    expect(icon.padding,EdgeInsets.zero);
    expect(icon.constraints,BoxConstraints());
    expect(icon.alignment,Alignment.topCenter);
    expect(icon.tooltip,'Expand');
    expect(icon.icon.toString(),Icon(Icons.keyboard_arrow_up, color: ThemeStyle.secondaryIconColor).toString());
  });

  testWidgets("CustomBottomSheet expanded container icon button has correct values ", (WidgetTester tester) async{
    await _createNavigationCustomBottomSheet(tester);

    final align = tester.widget<Align>(find.byKey(ValueKey("internalAlign2")));
    IconButton? icon = align.child as IconButton;
    expect(icon.padding,EdgeInsets.zero);
    expect(icon.constraints,BoxConstraints());
    expect(icon.alignment,Alignment.topCenter);
    expect(icon.tooltip,'Shrink');
    expect(icon.icon.toString(),Icon(Icons.keyboard_arrow_down, color: ThemeStyle.secondaryIconColor).toString());
  });

}