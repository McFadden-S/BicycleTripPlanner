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
    setState(() => {widget.directionManager.toggleCycling()});
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white)),
        child: Row(
        children: [
          Icon(
            Icons.directions_walk,
            color: widget.directionManager.ifCycling() ? Colors.black26 : Colors.red,
            size: 30,
          ),
          const Text(
            '/',
            style: TextStyle(fontSize: 25, color: Colors.black),
          ),
          Icon(
            Icons.directions_bike,
            color: widget.directionManager.ifCycling() ? Colors.red : Colors.black26,
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