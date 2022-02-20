import 'package:flutter/material.dart';


class Countdown extends StatefulWidget {

  const Countdown({Key? key}) : super(key: key);

  @override
  _CountdownState createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(5.0),
        child: const Text(
          "12 : 02",
          style: TextStyle(
            color: Color(0xFF8B0000),
          ),
        )
    );
  }
}
