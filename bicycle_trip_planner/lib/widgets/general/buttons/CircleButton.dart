import 'package:bicycle_trip_planner/constants.dart';
import 'package:flutter/material.dart';

class CircleButton extends StatefulWidget {

  final IconData iconIn;
  final VoidCallback onButtonClicked;
  Color? buttonColor = ThemeStyle.buttonPrimaryColor;
  Color? iconColor = ThemeStyle.primaryIconColor;

  CircleButton({ Key? key,
    required this.iconIn, 
    required this.onButtonClicked, 
    this.buttonColor,
    this.iconColor,
  }) : super(key: key);

  @override
  _StationCardState createState() => _StationCardState();
}

class _StationCardState extends State<CircleButton> {

  @override
  Widget build(BuildContext context) {

    return ElevatedButton(
      onPressed: widget.onButtonClicked,
      child: Icon(
          widget.iconIn,
          color: widget.iconColor,
        size: 30,
      ),
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(10),
        primary: widget.buttonColor,
        fixedSize: Size(50, 50),
      ),
    );
  }
}
