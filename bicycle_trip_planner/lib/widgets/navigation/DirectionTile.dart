import 'package:bicycle_trip_planner/managers/DirectionManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class DirectionTile extends StatefulWidget {
  final int index; 
  final DirectionManager directionManager; 

  const DirectionTile({ Key? key, required this.index, required this.directionManager }) : super(key: key);

  @override
  _DirectionTileState createState() => _DirectionTileState();
}

class _DirectionTileState extends State<DirectionTile> {
  @override
  Widget build(BuildContext context) {
     return Expanded(
       child: ListTile(
        leading: widget.directionManager.directionIcon(
            widget.directionManager.directions[widget.index].instruction),
        trailing:
            Text("${widget.directionManager.directions[widget.index].distance} m"),
        title: Html(
          data: widget.directionManager.directions[widget.index].instruction,
    )),
     );
  }
}
