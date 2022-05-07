import 'package:flutter/material.dart';
import 'package:bicycle_trip_planner/constants.dart';

/// Custom password field class that builds a rounded text field with
/// a given hint text and icon to display and updates a value of a string
/// with a new inputted text in text field and hides shows password when requested.
class RoundedPasswordField extends StatefulWidget {

  /// A method that takes in the inputted string from the user. Typically
  /// used to set a new value for a variable
  final ValueChanged<String> onChanged;

  /// The hint text to be displayed for the user to state what value should
  /// entered in here
  final String text;

  /// Constructor of the widget requiring the specified variables
  const RoundedPasswordField({Key? key,required this.onChanged, required this.text}): super(key: key);
  @override
  _RoundedPasswordField createState() => _RoundedPasswordField();
}

class _RoundedPasswordField extends State<RoundedPasswordField> {
  bool _isHidden = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      // Container that is responsible for the size of the text field
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        color: ThemeStyle.kPrimaryLightColor,
        borderRadius: BorderRadius.circular(29),
      ),
      // Text field that takes in the user's text input
      child: TextField(
        obscureText: _isHidden,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          hintText: widget.text,
          icon: Icon(
            Icons.lock,
            color: ThemeStyle.kPrimaryColor,
          ),
          // InkWell that displays visibility icon
          suffix: InkWell(
            onTap: _togglePasswordView,
            child: Icon(
              _isHidden
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: ThemeStyle.kPrimaryColor,
            ),
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  // Toggles visibility of the password when 'eye' icon is clicked
  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
}