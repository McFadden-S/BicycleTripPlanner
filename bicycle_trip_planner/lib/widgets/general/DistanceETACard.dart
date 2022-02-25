import 'package:bicycle_trip_planner/constants.dart';
import 'package:flutter/material.dart';

class DistanceETACard extends StatefulWidget {

  const DistanceETACard({ Key? key}) : super(key: key);

  @override
  _StationCardState createState() => _StationCardState();
}

class _StationCardState extends State<DistanceETACard> {

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
            Column(children: const [
              Icon(Icons.timer),
              Text("[ETA]")
            ]),
          const Text("3.5 miles")
          ],
        ),
      )
    );
  }
}
