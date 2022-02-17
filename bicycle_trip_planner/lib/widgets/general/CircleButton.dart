import 'package:flutter/material.dart';

class CircleButton extends StatefulWidget {

  final IconData iconIn;
  final VoidCallback onButtonClicked;
  final Color buttonColor; 
  final Color iconColor; 

  const CircleButton({ Key? key, 
    required this.iconIn, 
    required this.onButtonClicked, 
    this.buttonColor = const Color.fromRGBO(12, 156, 238, 1.0), 
    this.iconColor = const Color.fromRGBO(255, 255, 255, 1.0),
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
