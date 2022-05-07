import 'package:flutter/material.dart';
import 'package:bicycle_trip_planner/constants.dart';

/// Custom input text field class that builds a rounded text field with
/// a given hint text and icon to display and updates a value of a string
/// with a new inputted text in text field.
class RoundedInputField extends StatefulWidget {
  /// The hint text to be displayed for the user to state what value should
  /// entered in here
  final String hintText;

  /// The icon displayed in the text field. This is an Icons.person by default
  final IconData icon;

  /// A method that takes in the inputted string from the user. Typically
  /// used to set a new value for a variable
  final ValueChanged<String> onChanged;

  /// Constructor of the widget requiring the specified variables
  const RoundedInputField({
    Key? key,
    required this.hintText,
    this.icon = Icons.person,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<RoundedInputField> createState() => _RoundedInputFieldState();
}

class _RoundedInputFieldState extends State<RoundedInputField> {
  @override
  Widget build(BuildContext context) {
    // Container that is responsible for the size of the text field
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        color: ThemeStyle.kPrimaryLightColor,
        borderRadius: BorderRadius.circular(29),
      ),
      // Text field that takes in the user's text input
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          hintText: widget.hintText,
          border: InputBorder.none,
          icon: Icon(
            widget.icon,
            color: ThemeStyle.kPrimaryColor,
          ),
        ),
      ),
    );
  }
}
