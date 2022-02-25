import 'package:flutter/material.dart';

import '../../constants.dart';

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
      ),
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(10),
        primary: widget.buttonColor,
      ),
    );
  }
}
