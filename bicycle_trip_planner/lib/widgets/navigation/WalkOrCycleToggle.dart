import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/managers/DirectionManager.dart';
import 'package:flutter/material.dart';

class WalkOrCycleToggle extends StatefulWidget {

  final DirectionManager directionManager; 

  const WalkOrCycleToggle({ Key? key, required this.directionManager }) : super(key: key);

  @override
  _WalkOrCycleToggleState createState() => _WalkOrCycleToggleState();
}

class _WalkOrCycleToggleState extends State<WalkOrCycleToggle> {

  void setCycling() {
    setState(() => {widget.directionManager.isCycling = !widget.directionManager.isCycling});
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(ThemeStyle.buttonSecondaryColor)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.directions_walk,
            color: widget.directionManager.isCycling ? Colors.black26 : Colors.red,
            size: 30,
          ),
          const Text(
            '/',
            style: TextStyle(fontSize: 25, color: Colors.black),
          ),
          Icon(
            Icons.directions_bike,
            color: widget.directionManager.isCycling ? Colors.red : Colors.black26,
            size: 30,
          ),
        ],
      ),
      onPressed: () {
        setCycling();
      },
    );
  }
}