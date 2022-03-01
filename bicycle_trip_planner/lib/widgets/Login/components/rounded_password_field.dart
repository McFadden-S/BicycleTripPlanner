import 'package:flutter/material.dart';
import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/widgets/Login/components/text_field_container.dart';

class RoundedPasswordField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String text;
  RoundedPasswordField({Key? key,required this.onChanged, required this.text}): super(key: key);
  @override
  _RoundedPasswordField createState() => _RoundedPasswordField();
}

class _RoundedPasswordField extends State<RoundedPasswordField> {
  bool _isHidden = true;

  @override
  Widget build(BuildContext context) {
    return TextFieldContainter(
      child: TextField(
        obscureText: _isHidden,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          hintText: widget.text,
          icon: Icon(
            Icons.lock,
            color: ThemeStyle.kPrimaryColor,
          ),
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