import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/widgets/settings/components/InputField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../setUp.dart';

void main() {
  ThemeStyle();
  String testEmail = "";

  setUp(() {
    testEmail = "";
  });

  void testOnChanged(String value) {
    testEmail = value;
  }

  Future<void> _createInputFieldWidget(
      WidgetTester tester, String hintText, ValueChanged<String> onChanged,
      {IconData iconData = Icons.person}) async {
    await pumpWidget(
        tester,
        MaterialApp(
            home: Material(
                child: RoundedInputField(
                    hintText: hintText,
                    onChanged: onChanged,
                    icon: iconData))));
  }

  testWidgets("Input Field exists", (WidgetTester tester) async {
    await _createInputFieldWidget(tester, "Input", (value) {});
    final inputField = find.byType(RoundedInputField);
    expect(inputField, findsOneWidget);
  });

  testWidgets("Input Field initialises hintText correctly",
      (WidgetTester tester) async {
    await _createInputFieldWidget(tester, "Input", (value) {});
    final inputField =
        tester.widget<RoundedInputField>(find.byType(RoundedInputField));
    expect(inputField.hintText, "Input");
  });

  testWidgets("Input Field initialises icon correctly",
      (WidgetTester tester) async {
    await _createInputFieldWidget(tester, "Input", (value) {});
    final inputField =
        tester.widget<RoundedInputField>(find.byType(RoundedInputField));
    expect(inputField.icon, Icons.person);
  });

  testWidgets("Input Field initialises onChanged correctly",
      (WidgetTester tester) async {
    await _createInputFieldWidget(tester, "Input", testOnChanged);
    final inputField =
        tester.widget<RoundedInputField>(find.byType(RoundedInputField));
    expect(inputField.onChanged, testOnChanged);
  });

  testWidgets("Input Field builds a container", (WidgetTester tester) async {
    await _createInputFieldWidget(tester, "Input", (value) {});
    final container = find.byType(Container);
    expect(container, findsOneWidget);
  });

  testWidgets(
      "Input Field Container has a correct vertical symmetric margin of 10",
      (WidgetTester tester) async {
    await _createInputFieldWidget(tester, "Input", (value) {});
    final container = tester.widget<Container>(find.byType(Container));
    expect(container.margin, const EdgeInsets.symmetric(vertical: 10));
  });

  testWidgets(
      "Input Field Container has a correct symmetric padding of horizontal 20 and vertical 5",
      (WidgetTester tester) async {
    await _createInputFieldWidget(tester, "Input", (value) {});
    final container = tester.widget<Container>(find.byType(Container));
    expect(container.padding,
        const EdgeInsets.symmetric(horizontal: 20, vertical: 5));
  });

  testWidgets("Input Field Container takes 0.8 of the width available to it",
      (WidgetTester tester) async {
    await _createInputFieldWidget(tester, "Input", (value) {});
    final BuildContext context = tester.element(find.byType(RoundedInputField));
    final container = tester.widget<Container>(find.byType(Container));
    Size size = MediaQuery.of(context).size;
    expect(container.constraints?.maxWidth, size.width * 0.8);
  });

  testWidgets("Input Field Container is coloured correctly",
      (WidgetTester tester) async {
    await _createInputFieldWidget(tester, "Input", (value) {});
    final container = tester.widget<Container>(find.byType(Container));
    final decoration = container.decoration as BoxDecoration;
    expect(decoration.color, ThemeStyle.kPrimaryLightColor);
  });

  testWidgets("Input Field Container is rounded", (WidgetTester tester) async {
    await _createInputFieldWidget(tester, "Input", (value) {});
    final container = tester.widget<Container>(find.byType(Container));
    final decoration = container.decoration as BoxDecoration;
    expect(decoration.borderRadius != BorderRadius.zero, true);
  });

  testWidgets("Input Field Container is rounded with a radius of 29",
      (WidgetTester tester) async {
    await _createInputFieldWidget(tester, "Input", (value) {});
    final container = tester.widget<Container>(find.byType(Container));
    final decoration = container.decoration as BoxDecoration;
    expect(decoration.borderRadius, BorderRadius.circular(29));
  });

  testWidgets("Input Field builds a text field", (WidgetTester tester) async {
    await _createInputFieldWidget(tester, "Input", (value) {});
    final textField = find.byType(TextField);
    expect(textField, findsOneWidget);
  });

  testWidgets("Input Field Text Field is of type email address",
      (WidgetTester tester) async {
    await _createInputFieldWidget(tester, "Input", (value) {});
    final textField = tester.widget<TextField>(find.byType(TextField));
    expect(textField.keyboardType, TextInputType.emailAddress);
  });

  testWidgets("Input Field Text Field takes in correct method",
      (WidgetTester tester) async {
    await _createInputFieldWidget(tester, "Input", testOnChanged);
    final textField = tester.widget<TextField>(find.byType(TextField));
    expect(textField.onChanged, testOnChanged);
  });

  testWidgets(
      "Input Field Text Field correctly changes string when input field onChanged is called",
      (WidgetTester tester) async {
    await _createInputFieldWidget(tester, "Input", testOnChanged);
    final textField = find.byType(TextField);

    expect(testEmail, "");
    await tester.enterText(textField, "johndoe@example.org");
    expect(testEmail, "johndoe@example.org");
  });

  testWidgets(
      "Input Field Text Field correctly changes string when input field onChanged is called twice for different values",
      (WidgetTester tester) async {
    await _createInputFieldWidget(tester, "Input", testOnChanged);
    final textField = find.byType(TextField);

    expect(testEmail, "");
    await tester.enterText(textField, "johndoe@example.org");
    await tester.pumpAndSettle();
    expect(testEmail, "johndoe@example.org");

    await tester.enterText(textField, "newjanedoe@example.org");
    await tester.pumpAndSettle();
    expect(testEmail, "newjanedoe@example.org");
  });

  testWidgets("Input Field Text Field displays correct hint text",
      (WidgetTester tester) async {
    await _createInputFieldWidget(tester, "Email Address", testOnChanged);
    final textField = tester.widget<TextField>(find.byType(TextField));
    expect(textField.decoration?.hintText, "Email Address");
  });

  testWidgets("Input Field Text Field border is of type none",
      (WidgetTester tester) async {
    await _createInputFieldWidget(tester, "Email Address", testOnChanged);
    final textField = tester.widget<TextField>(find.byType(TextField));
    expect(textField.decoration?.border, InputBorder.none);
  });

  testWidgets("Input Field Text Field icon displays person icon by default",
      (WidgetTester tester) async {
    await _createInputFieldWidget(tester, "Email Address", testOnChanged);
    final textField = tester.widget<TextField>(find.byType(TextField));
    final icon = textField.decoration?.icon as Icon;
    expect(icon.icon, Icons.person);
  });

  testWidgets("Input Field Text Field icon displays correct input icon",
      (WidgetTester tester) async {
    await _createInputFieldWidget(tester, "Email Address", testOnChanged,
        iconData: Icons.email);
    final textField = tester.widget<TextField>(find.byType(TextField));
    final icon = textField.decoration?.icon as Icon;
    expect(icon.icon, Icons.email);
  });

  testWidgets("Input Field Text Field icon colour is correct",
      (WidgetTester tester) async {
    await _createInputFieldWidget(tester, "Email Address", testOnChanged);
    final textField = tester.widget<TextField>(find.byType(TextField));
    final icon = textField.decoration?.icon as Icon;
    expect(icon.color, ThemeStyle.kPrimaryColor);
  });
}
