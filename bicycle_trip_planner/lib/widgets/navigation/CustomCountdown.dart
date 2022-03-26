import 'package:flutter/material.dart';


class CustomCountdown extends StatefulWidget {
  final String duration;
  final Color color;
  const CustomCountdown({Key? key, required this.duration, required this.color}) : super(key: key);

  @override
  _CustomCountdownState createState() => _CustomCountdownState();
}
class _CustomCountdownState extends State<CustomCountdown> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          widget.duration,
          style: TextStyle(
            color: widget.color,
          ),
        )
    );
  }
}
