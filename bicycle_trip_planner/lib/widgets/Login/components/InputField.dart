import 'package:flutter/material.dart';
import 'package:bicycle_trip_planner/widgets/Login/components/text_field_container.dart';
import 'package:bicycle_trip_planner/constants.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  const RoundedInputField({
    Key? key,
    required this.hintText,
    this.icon = Icons.person,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainter(
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          icon: Icon(
            icon,
            color: ThemeStyle.kPrimaryColor,
          ),
        ),
      ),
    );
  }
}

