import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ElavatedButtonWithIcon extends StatelessWidget {
  final String text;
  final VoidCallback press;
  final FaIcon icon;

  const ElavatedButtonWithIcon({
    Key? key,
    required this.text,
    required this.press,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: press,
      label: Text(text),
      icon: icon,
    );
  }
}