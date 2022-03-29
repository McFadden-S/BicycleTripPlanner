import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/widgets/settings/ForgotPasswordScreen.dart';
import 'package:bicycle_trip_planner/widgets/settings/components/RoundedTextButton.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../setUp.dart';
import 'mock.dart';

void main() {
  ThemeStyle();
  Color buttonColor = ThemeStyle.buttonPrimaryColor;
  bool testCalled = false;

  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  setUp(() {
    testCalled = false;
  });

  Future<void> _createRoundedTextButtonWidget(
      WidgetTester tester, String text, VoidCallback press, Color color) async {
    await pumpWidget(
        tester,
        MaterialApp(
            home: Material(
                child: RoundedTextButton(
                    text: text, press: press, color: color))));
  }

  void testFunction() {
    testCalled = true;
  }

  testWidgets("Rounded Text Button exists", (WidgetTester tester) async {
    await _createRoundedTextButtonWidget(tester, "text", () {}, buttonColor);
    final button = find.byType(RoundedTextButton);
    expect(button, findsOneWidget);
  });

  testWidgets("Rounded Text Button builds an elevated button",
      (WidgetTester tester) async {
    await _createRoundedTextButtonWidget(tester, "text", () {}, buttonColor);
    final button = find.byType(ElevatedButton);
    expect(button, findsOneWidget);
  });

  testWidgets("Rounded Text Button has correct text",
      (WidgetTester tester) async {
    await _createRoundedTextButtonWidget(
        tester, "Correct Text", () {}, buttonColor);
    final textFinder = find.text("Correct Text");
    expect(textFinder, findsOneWidget);
  });

  testWidgets("Rounded Text Button does not have incorrect text",
      (WidgetTester tester) async {
    await _createRoundedTextButtonWidget(
        tester, "Correct Text", () {}, buttonColor);
    final textFinder = find.text("Incorrect Text");
    expect(textFinder, findsNothing);
  });

  testWidgets("Rounded Text Button is of the correct colour",
      (WidgetTester tester) async {
    await _createRoundedTextButtonWidget(tester, "Input", () {}, buttonColor);

    final button =
        tester.widget<RoundedTextButton>(find.byType(RoundedTextButton));

    expect(button.color, buttonColor);
  });

  testWidgets("Rounded Text Button text is of the correct colour",
      (WidgetTester tester) async {
    await _createRoundedTextButtonWidget(tester, "Input", () {}, buttonColor);

    final text = tester.widget<Text>(find.text("Input"));

    expect(text.style?.color, ThemeStyle.primaryTextColor);
  });

  testWidgets(
      "Rounded Text Button text style in ElevatedButton has font size of 14",
      (WidgetTester tester) async {
    await _createRoundedTextButtonWidget(tester, "Input", () {}, buttonColor);

    final elevatedButton =
        tester.widget<ElevatedButton>(find.byType(ElevatedButton));

    expect(
        elevatedButton.style?.textStyle.toString().contains("size: 14"), true);
  });

  testWidgets(
      "Rounded Text Button text style in ElevatedButton has font weight of 500",
      (WidgetTester tester) async {
    await _createRoundedTextButtonWidget(tester, "Input", () {}, buttonColor);

    final elevatedButton =
        tester.widget<ElevatedButton>(find.byType(ElevatedButton));

    expect(elevatedButton.style?.textStyle.toString().contains("weight: 500"),
        true);
  });

  testWidgets(
      "Rounded Text Button text style in ElevatedButton has correct font color",
      (WidgetTester tester) async {
    await _createRoundedTextButtonWidget(tester, "Input", () {}, buttonColor);

    final elevatedButton =
        tester.widget<ElevatedButton>(find.byType(ElevatedButton));

    expect(
        elevatedButton.style?.textStyle
            .toString()
            .contains("color: ${ThemeStyle.primaryTextColor}"),
        true);
  });

  testWidgets(
      "Rounded Text Button text style in ElevatedButton has correct padding",
      (WidgetTester tester) async {
    await _createRoundedTextButtonWidget(tester, "Input", () {}, buttonColor);

    final elevatedButton =
        tester.widget<ElevatedButton>(find.byType(ElevatedButton));

    EdgeInsetsGeometry insets =
        const EdgeInsets.symmetric(horizontal: 40, vertical: 20);

    expect(elevatedButton.style?.padding.toString(),
        MaterialStateProperty.all(insets).toString());
  });

  testWidgets("Rounded Text Button has rounded borders",
      (WidgetTester tester) async {
    await _createRoundedTextButtonWidget(tester, "Input", () {}, buttonColor);

    final rect = tester.widget<ClipRRect>(find.byType(ClipRRect));

    expect(rect.borderRadius != BorderRadius.zero, true);
  });

  testWidgets("Rounded Text Button has rounded borders of radius 30",
      (WidgetTester tester) async {
    await _createRoundedTextButtonWidget(tester, "Input", () {}, buttonColor);

    final rect = tester.widget<ClipRRect>(find.byType(ClipRRect));

    expect(rect.borderRadius == BorderRadius.circular(30), true);
  });

  testWidgets("Rounded Text Button has rounded borders",
      (WidgetTester tester) async {
    await _createRoundedTextButtonWidget(tester, "Input", () {}, buttonColor);

    final rect = tester.widget<ClipRRect>(find.byType(ClipRRect));

    expect(rect.borderRadius != BorderRadius.zero, true);
  });

  testWidgets("Rounded Text Button has a container",
      (WidgetTester tester) async {
    await _createRoundedTextButtonWidget(tester, "Input", () {}, buttonColor);

    final container = find.byType(Container);

    expect(container, findsOneWidget);
  });

  testWidgets(
      "Rounded Text Button Container is 0.6 width of the size available to it",
      (WidgetTester tester) async {
    await _createRoundedTextButtonWidget(tester, "Input", () {}, buttonColor);

    final BuildContext context = tester.element(find.byType(RoundedTextButton));
    final container = tester.widget<Container>(find.byType(Container));
    Size size = MediaQuery.of(context).size;

    expect(container.constraints?.maxWidth, size.width * 0.6);
  });

  testWidgets(
      "Rounded Text Button Container has correct symmertrical vertical margin 10",
      (WidgetTester tester) async {
    await _createRoundedTextButtonWidget(tester, "Input", () {}, buttonColor);

    final container = tester.widget<Container>(find.byType(Container));

    expect(container.margin, const EdgeInsets.symmetric(vertical: 10));
  });

  testWidgets("Rounded Text Button has correct method",
      (WidgetTester tester) async {
    await _createRoundedTextButtonWidget(
        tester, "Input", testFunction, buttonColor);

    final button =
        tester.widget<RoundedTextButton>(find.byType(RoundedTextButton));

    expect(button.press, testFunction);
  });

  testWidgets("Rounded Text Button ElevatedButton onPressed has correct method",
      (WidgetTester tester) async {
    await _createRoundedTextButtonWidget(
        tester, "Input", testFunction, buttonColor);

    final elevatedButton =
        tester.widget<ElevatedButton>(find.byType(ElevatedButton));

    expect(elevatedButton.onPressed, testFunction);
  });

  testWidgets("Pressing Rounded Text Button calls method correctly",
      (WidgetTester tester) async {
    await _createRoundedTextButtonWidget(
        tester, "Input", testFunction, buttonColor);

    final button = find.byType(ElevatedButton);

    expect(testCalled, false);

    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(testCalled, true);
  });
}
