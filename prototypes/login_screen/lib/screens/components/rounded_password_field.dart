import 'package:flutter/material.dart';
import 'package:prototypes/constants.dart';
import 'package:prototypes/screens/components/text_field_container.dart';

class RoundedPasswordField extends StatefulWidget {
  final ValueChanged<String> onChanged; // unused
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
            color: kPrimaryColor,
          ),
          suffix: InkWell(
            onTap: _togglePasswordView,
            child: Icon(
              _isHidden
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: kPrimaryColor,
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