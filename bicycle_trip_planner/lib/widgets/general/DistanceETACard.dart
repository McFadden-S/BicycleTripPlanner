import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/managers/DirectionManager.dart';
import 'package:flutter/material.dart';

class DistanceETACard extends StatefulWidget {

  const DistanceETACard({ Key? key}) : super(key: key);

  @override
  _StationCardState createState() => _StationCardState();
}

class _StationCardState extends State<DistanceETACard> {

  final DirectionManager _directionManager = DirectionManager();

  @override
  Widget build(BuildContext context) {

    return Card(
      color: ThemeStyle.cardColor,
      elevation: 5,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13)),
      child: Container(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          children: [
            Column(children: [
              Icon(Icons.access_time_outlined, color: ThemeStyle.secondaryIconColor),
              Text(_directionManager.getDuration(), style: TextStyle(color: ThemeStyle.secondaryTextColor),)
            ]),
            Text(_directionManager.getDistance(), style: TextStyle(color: ThemeStyle.secondaryTextColor))
          ],
        ),
      )
    );
  }
}
