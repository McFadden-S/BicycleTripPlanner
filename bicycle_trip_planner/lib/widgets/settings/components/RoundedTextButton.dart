import 'package:flutter/material.dart';
import 'package:bicycle_trip_planner/constants.dart';

class RoundedTextButton extends StatefulWidget {
  final String text;
  final VoidCallback press;
  Color? color = ThemeStyle.buttonPrimaryColor;

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
  Color textColor = ThemeStyle.primaryTextColor;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10 ),
      width: size.width * 0.6,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: newElevatedButton(),
      ),
    );
  }

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