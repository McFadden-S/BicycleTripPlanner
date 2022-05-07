import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/widgets/settings/components/PasswordField.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../setUp.dart';
import 'mocks/mock.dart';

void main() {
  ThemeStyle();
  String testPassword = "";

  setUp(() {
    testPassword = "";
  });

  Future<void> _createPasswordFieldWidget(
      WidgetTester tester, String text, ValueChanged<String> press) async {
    await pumpWidget(
        tester,
        MaterialApp(
            home: Material(
                child: RoundedPasswordField(text: text, onChanged: press))));
  }

  void testOnCalled(String value) {
    testPassword = value;
  }

  testWidgets("Password field exists", (WidgetTester tester) async {
    await _createPasswordFieldWidget(tester, "text", testOnCalled);
    final button = find.byType(RoundedPasswordField);
    expect(button, findsOneWidget);
  });

  testWidgets("Input Field initialises onChanged correctly",
      (WidgetTester tester) async {
    await _createPasswordFieldWidget(tester, "text", testOnCalled);
    final inputField =
        tester.widget<RoundedPasswordField>(find.byType(RoundedPasswordField));
    expect(inputField.onChanged, testOnCalled);
  });

  testWidgets("Password field builds a text field",
      (WidgetTester tester) async {
    await _createPasswordFieldWidget(tester, "text", testOnCalled);
    final button = find.byType(TextField);
    expect(button, findsOneWidget);
  });

  testWidgets("Password field builds an ink well", (WidgetTester tester) async {
    await _createPasswordFieldWidget(tester, "text", testOnCalled);
    final button = find.byType(InkWell);
    expect(button, findsOneWidget);
  });

  testWidgets("Password field has correct text", (WidgetTester tester) async {
    await _createPasswordFieldWidget(tester, "Correct Text", testOnCalled);
    final textFinder = find.text("Correct Text");
    expect(textFinder, findsOneWidget);
  });

  testWidgets("Rounded Text Button does not have incorrect text",
      (WidgetTester tester) async {
    await _createPasswordFieldWidget(tester, "Correct Text", testOnCalled);
    final textFinder = find.text("Incorrect Text");
    expect(textFinder, findsNothing);
  });

  testWidgets("Field starts with visibility icon", (WidgetTester tester) async {
    await _createPasswordFieldWidget(tester, "text", testOnCalled);

    final textFinder = find.byIcon(Icons.visibility);
    expect(textFinder, findsOneWidget);
  });

  testWidgets("Visibility icon changes when tapped",
      (WidgetTester tester) async {
    await _createPasswordFieldWidget(tester, "text", testOnCalled);
    final icon = find.byIcon(Icons.visibility);

    await tester.tap(icon);
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.visibility_off), findsOneWidget);
  });

  testWidgets("Password field icon color is set to correct color",
      (WidgetTester tester) async {
    await _createPasswordFieldWidget(tester, "text", testOnCalled);
    final textField = tester.widget<TextField>(find.byType(TextField));

    expect(textField.decoration?.icon.toString(),
        contains(ThemeStyle.kPrimaryColor.toString()));
  });

  testWidgets("Password Field Text field on changed value", (WidgetTester tester) async {
    await _createPasswordFieldWidget(tester, "text", testOnCalled);
    final textField = tester.widget<TextField>(find.byType(TextField));
    var x = textField.onChanged;

    expect(x.toString(), "Closure: (String) => void");
  });

  testWidgets("Password field text changes to correct text",
      (WidgetTester tester) async {
    await _createPasswordFieldWidget(tester, "text", testOnCalled);
    final textFinder = find.byType(RoundedPasswordField);

    await tester.enterText(textFinder, "Correct text");
    await tester.pumpAndSettle();

    expect(find.text("Correct text"), findsOneWidget);
  });

  testWidgets("Password field text does not have incorrect text",
      (WidgetTester tester) async {
    await _createPasswordFieldWidget(tester, "text", testOnCalled);
    final textFinder = find.byType(RoundedPasswordField);

    await tester.enterText(textFinder, "Wrong text");
    await tester.pumpAndSettle();

    expect(find.text("test"), findsNothing);
  });

  testWidgets(
      "Password Text Field correctly changes string when input field onChanged is called twice for different values",
      (WidgetTester tester) async {
    await _createPasswordFieldWidget(tester, "text", testOnCalled);
    final textField = find.byType(TextField);

    expect(testPassword, "");
    await tester.enterText(textField, "password");
    await tester.pumpAndSettle();
    expect(testPassword, "password");

    await tester.enterText(textField, "newpassword");
    await tester.pumpAndSettle();
    expect(testPassword, "newpassword");
  });

  testWidgets("Password field has a container", (WidgetTester tester) async {
    await _createPasswordFieldWidget(tester, "text", testOnCalled);
    final container = find.byType(Container);
    expect(container, findsOneWidget);
  });

  testWidgets("Container has correct color", (WidgetTester tester) async {
    await _createPasswordFieldWidget(tester, "text", testOnCalled);
    final container = tester.widget<Container>(find.byType(Container));

    expect(container.decoration.toString(),
        contains(ThemeStyle.kPrimaryLightColor.toString()));
  });

  testWidgets("Container has circular border radius of 29.0",
      (WidgetTester tester) async {
    await _createPasswordFieldWidget(tester, "text", testOnCalled);
    final container = tester.widget<Container>(find.byType(Container));

    expect(container.decoration.toString(),
        contains(BorderRadius.circular(29.0).toString()));
  });

  testWidgets("Container has margin edge insets with vertical of 10",
      (WidgetTester tester) async {
    await _createPasswordFieldWidget(tester, "text", testOnCalled);
    final container = tester.widget<Container>(find.byType(Container));

    expect(container.margin, EdgeInsets.symmetric(vertical: 10));
  });

  testWidgets(
      "Container has padding edge insets with vertical of 5 and horizontal of 20",
      (WidgetTester tester) async {
    await _createPasswordFieldWidget(tester, "text", testOnCalled);
    final container = tester.widget<Container>(find.byType(Container));

    expect(
        container.padding, EdgeInsets.symmetric(horizontal: 20, vertical: 5));
  });

  testWidgets(
      "Container has padding edge insets with vertical of 5 and horizontal of 20",
      (WidgetTester tester) async {
    await _createPasswordFieldWidget(tester, "text", testOnCalled);
    final container = tester.widget<Container>(find.byType(Container));
    final BuildContext context =
        tester.element(find.byType(RoundedPasswordField));
    Size size = MediaQuery.of(context).size;
    expect(container.constraints?.maxWidth, size.width * 0.8);
  });

  testWidgets("Password Field Container is rounded",
      (WidgetTester tester) async {
    await _createPasswordFieldWidget(tester, "text", testOnCalled);
    final container = tester.widget<Container>(find.byType(Container));
    final decoration = container.decoration as BoxDecoration;
    expect(decoration.borderRadius != BorderRadius.zero, true);
  });

  testWidgets("Password Field Text Field is of type text",
      (WidgetTester tester) async {
    await _createPasswordFieldWidget(tester, "text", testOnCalled);
    final textField = tester.widget<TextField>(find.byType(TextField));
    expect(textField.keyboardType, TextInputType.text);
  });

  testWidgets("Password Field Text Field border is of type none",
      (WidgetTester tester) async {
    await _createPasswordFieldWidget(tester, "text", testOnCalled);
    final textField = tester.widget<TextField>(find.byType(TextField));
    expect(textField.decoration?.border, InputBorder.none);
  });
}
