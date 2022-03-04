import 'package:flutter/material.dart';

import '../../constants.dart';

class RoundedRectangleButton extends StatefulWidget {

  final IconData iconIn;
  final VoidCallback onButtonClicked;
  final Color buttonColor;

  const RoundedRectangleButton({ Key? key, required this.iconIn, required this.onButtonClicked, required this.buttonColor}) : super(key: key);

  @override
  _StationCardState createState() => _StationCardState();
}

class _StationCardState extends State<RoundedRectangleButton> {

  @override
  Widget build(BuildContext context) {

    return ElevatedButton(
      onPressed: widget.onButtonClicked,
      child: Icon(
          widget.iconIn,
          color: ThemeStyle.primaryIconColor,
      ),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(17.0),
        ),
        padding: const EdgeInsets.only(left: 30, top: 10, bottom: 10, right: 30),
        primary: widget.buttonColor,
      ),
    );
  }
}
