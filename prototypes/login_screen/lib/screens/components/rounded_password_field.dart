import 'package:flutter/material.dart';
import 'package:prototypes/constants.dart';
import 'package:prototypes/screens/components/text_field_container.dart';

class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String text;
  const RoundedPasswordField({
    Key? key,
    required this.onChanged,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isPasswordHidden = true;
    return TextFieldContainter(
      child: TextField(
        obscureText: isPasswordHidden,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: text,
          icon: Icon(
            Icons.lock,
            color: kPrimaryColor,
          ),
          suffixIcon: Icon(
            Icons.visibility,
            color: kPrimaryColor,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}