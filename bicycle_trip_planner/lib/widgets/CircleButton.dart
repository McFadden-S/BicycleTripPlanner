import 'package:flutter/material.dart';

class CircleButton extends StatefulWidget {

  final IconData iconIn;
  final VoidCallback onButtonClicked;


  const CircleButton({ Key? key, required this.iconIn, required this.onButtonClicked }) : super(key: key);

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
          color: Colors.white,
      ),
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(10),
        primary: Color.fromRGBO(12, 156, 238, 1.0),
      ),
    );
  }
}
