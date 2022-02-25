import 'package:bicycle_trip_planner/managers/DirectionManager.dart';
import 'package:bicycle_trip_planner/models/steps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

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
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 150),
        child: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Spacer(flex: 1),
              directionManager.directionIcon(widget.currentDirection.instruction),
              Flexible(
                flex: 15,
                child: Html(
                  data: widget.currentDirection.instruction,
                )
              ),
              const Spacer(flex: 1),
              Text("${widget.currentDirection.distance} m"),
                  // : const Spacer(),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}