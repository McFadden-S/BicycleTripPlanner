import 'package:flutter/material.dart';


class Countdown extends StatefulWidget {
  final String duration; 
  const Countdown({Key? key, required this.duration}) : super(key: key);

  @override
  _CountdownState createState() => _CountdownState();
}
class _CountdownState extends State<Countdown> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          widget.duration,
          style: const TextStyle(
            color: Color(0xFF8B0000),
          ),
        )
    );
  }
}
