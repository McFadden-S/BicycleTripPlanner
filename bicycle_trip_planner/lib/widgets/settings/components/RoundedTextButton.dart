import 'package:flutter/material.dart';
import 'package:bicycle_trip_planner/constants.dart';

/// Custom button class that builds a rounded button with a given
/// text, colour and executes the given function on press.
class RoundedTextButton extends StatefulWidget {
  /// Text of the button to be displayed
  final String text;

  /// Function on the button to be executed upon pressing the button
  final VoidCallback press;

  /// Colour of the button, follows ThemeStyle colour pallete by default
  Color? color = ThemeStyle.buttonPrimaryColor;

  /// Constructor of the widget requiring the specified variables
  RoundedTextButton({
    Key? key,
    required this.text,
    required this.press,
    this.color,
  }) : super(key: key);

  @override
  State<RoundedTextButton> createState() => _RoundedTextButtonState();
}

class _RoundedTextButtonState extends State<RoundedTextButton> {
  /// Default text colour, follows ThemeStyle colour pallete
  Color textColor = ThemeStyle.primaryTextColor;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.6,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: newElevatedButton(),
      ),
    );
  }

  /// Returns an ElevatedButton with the passed in text, colour and function
  Widget newElevatedButton() {
    return ElevatedButton(
      child: Text(
        widget.text,
        style: TextStyle(color: textColor),
      ),
      onPressed: widget.press, // add on pressed function
      style: ElevatedButton.styleFrom(
          primary: widget.color,
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          textStyle: TextStyle(
              color: textColor, fontSize: 14, fontWeight: FontWeight.w500)),
    );
  }
}
