import 'package:bicycle_trip_planner/managers/DirectionManager.dart';
import 'package:bicycle_trip_planner/models/steps.dart';
import 'package:flutter/material.dart';

class CurrentDirection extends StatefulWidget {

  final Steps currentDirection; 
  const CurrentDirection({ Key? key, required this.currentDirection }) : super(key: key);

  @override
  _CurrentDirectionState createState() => _CurrentDirectionState();
}

class _CurrentDirectionState extends State<CurrentDirection> {

  final DirectionManager directionManager = DirectionManager();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Spacer(flex: 1),
          directionManager.directionIcon(widget.currentDirection.instruction),
          Flexible(
            flex: 15,
            child: Text(
              widget.currentDirection.instruction,
              textAlign: TextAlign.left,
            ),
          ),
              // : const Padding(
              //     padding: EdgeInsets.all(10.0),
              //     child: Text(
              //       "No given directions",
              //       textAlign: TextAlign.center,
              //       style: TextStyle(fontSize: 30),
              //     ),
              //   ),
          const Spacer(flex: 1),
          Text("${widget.currentDirection.distance} m"),
              // : const Spacer(),
          const Spacer(flex: 1),
        ],
      ),
    );
  }
}