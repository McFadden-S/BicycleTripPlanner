import 'package:flutter/material.dart';


class RoutePlanning extends StatefulWidget {
  const RoutePlanning({Key? key}) : super(key: key);

  @override
  _RoutePlanningState createState() => _RoutePlanningState();
}

class _RoutePlanningState extends State<RoutePlanning> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
            color: Colors.deepPurple,
          )
      ),
    );
  }
}
