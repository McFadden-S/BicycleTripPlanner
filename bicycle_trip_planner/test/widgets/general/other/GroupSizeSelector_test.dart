import 'dart:io';

import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/widgets/general/other/GroupSizeSelector.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../setUp.dart';
import '../../login/mock.dart';

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    HttpOverrides.global = null;
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  });

  testWidgets("GroupSizeSelector is a container", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: GroupSizeSelector())));

    final container = find.byType(Container);

    expect(container, findsWidgets);
  });

  testWidgets("GroupSizeSelector container has padding of 5,5,10,5 from LTRB", (WidgetTester tester)async{
    await pumpWidget(tester, MaterialApp(home: Material(child: GroupSizeSelector())));
    final container = tester.widget<Container>(find.byKey(Key("primaryContainer")));

    expect(container.padding,  const EdgeInsets.fromLTRB(5.0, 5.0, 10.0, 5.0));
  });

  testWidgets("GroupSizeSelector decoration has correct colour", (WidgetTester tester)async{
    await pumpWidget(tester, MaterialApp(home: Material(child: GroupSizeSelector())));
    final container = tester.widget<Container>(find.byKey(Key("primaryContainer")));

    expect(container.decoration.toString(), contains(ThemeStyle.buttonPrimaryColor.toString()));
  });

  testWidgets("GroupSizeSelector decoration has correct border radius", (WidgetTester tester)async{
    await pumpWidget(tester, MaterialApp(home: Material(child: GroupSizeSelector())));
    final container = tester.widget<Container>(find.byKey(Key("primaryContainer")));

    expect(container.decoration.toString(), contains(BorderRadius.all(Radius.circular(30.0)).toString()));
  });

  testWidgets("GroupSizeSelector contains a DropdownButtonHideUnderline", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: GroupSizeSelector())));

    final dropdownButtonHideUnderline = find.byType(DropdownButtonHideUnderline);

    expect(dropdownButtonHideUnderline, findsOneWidget);
  });

  testWidgets("GroupSizeSelector shows a group icon", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: GroupSizeSelector())));

    final icon = find.byIcon(Icons.group);

    expect(icon, findsOneWidget);
  });

  testWidgets("GroupSizeSelector contains Text widgets", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: GroupSizeSelector())));

    final textWidget = find.byType(Text);

    expect(textWidget, findsWidgets);
  });

  testWidgets("GroupSizeSelector contains a Dropdown menu bar", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: GroupSizeSelector())));

    final dropDownItemWidget = find.byKey(ValueKey("groupSizeSelector"));

    final x = tester.widget<DropdownButton<int>>(find.byKey(ValueKey("groupSizeSelector")));

    expect(dropDownItemWidget, findsOneWidget);
  });

  testWidgets("GroupSizeSelector Dropdown contains correct values", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: GroupSizeSelector())));

    final dropDownItem = tester.widget<DropdownButton<int>>(find.byKey(ValueKey("groupSizeSelector")));
    final items = dropDownItem.items?.toList();
    final size = dropDownItem.items?.length;

    DropdownMenuItem<int> x;
    for(int i =0; i < size!; i++){
      x =items![i];
      expect(x.value, i+1);
    }
  });

  testWidgets("GroupSizeSelector Dropdown has correct colour", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: GroupSizeSelector())));

    final dropDownItem = tester.widget<DropdownButton<int>>(find.byKey(ValueKey("groupSizeSelector")));
    expect(dropDownItem.dropdownColor,ThemeStyle.cardColor);
  });

  testWidgets("GroupSizeSelector Dropdown is dense", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: GroupSizeSelector())));

    final dropDownItem = tester.widget<DropdownButton<int>>(find.byKey(ValueKey("groupSizeSelector")));
    expect(dropDownItem.isDense,true);
  });

  testWidgets("GroupSizeSelector Dropdown has correct value", (WidgetTester tester) async {
    RouteManager().setGroupSize(7);
    await pumpWidget(tester, MaterialApp(home: Material(child: GroupSizeSelector())));
    final dropDownItem = tester.widget<DropdownButton<int>>(find.byKey(ValueKey("groupSizeSelector")));
    expect(dropDownItem.value,7);
  });

  testWidgets("GroupSizeSelector Dropdown has an icon size of 30", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: GroupSizeSelector())));
    final dropDownItem = tester.widget<DropdownButton<int>>(find.byKey(ValueKey("groupSizeSelector")));
    expect(dropDownItem.iconSize,30);
  });

  testWidgets("GroupSizeSelector Dropdown has an elevation of 16", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: GroupSizeSelector())));
    final dropDownItem = tester.widget<DropdownButton<int>>(find.byKey(ValueKey("groupSizeSelector")));
    expect(dropDownItem.elevation,16);
  });

  testWidgets("GroupSizeSelector Dropdown has a correct style color", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: GroupSizeSelector())));
    final dropDownItem = tester.widget<DropdownButton<int>>(find.byKey(ValueKey("groupSizeSelector")));
    expect(dropDownItem.style?.color, ThemeStyle.primaryTextColor);
  });

  testWidgets("GroupSizeSelector Dropdown has a correct style font size", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: GroupSizeSelector())));
    final dropDownItem = tester.widget<DropdownButton<int>>(find.byKey(ValueKey("groupSizeSelector")));
    expect(dropDownItem.style?.fontSize, 18);
  });

  testWidgets("GroupSizeSelector Dropdown has a menu max height of 200", (WidgetTester tester) async {
    await pumpWidget(tester, MaterialApp(home: Material(child: GroupSizeSelector())));
    final dropDownItem = tester.widget<DropdownButton<int>>(find.byKey(ValueKey("groupSizeSelector")));
    expect(dropDownItem.menuMaxHeight, 200);
  });
}