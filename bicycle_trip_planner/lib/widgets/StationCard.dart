

import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StationCard extends StatefulWidget {

  final int index; 

  const StationCard({ Key? key, required this.index }) : super(key: key);

  @override
  _StationCardState createState() => _StationCardState();
}

class _StationCardState extends State<StationCard> { 

  @override
  Widget build(BuildContext context) {

    final ApplicationBloc applicationBloc = Provider.of<ApplicationBloc>(context);  

    return InkWell(
      onTap: () => stationClicked(widget.index),
      child: SizedBox(
          height: 60, 
          child: Card(
              child: Row(
                children: [
                  const Spacer(),
                  const Text(
                    "1.1 mi",
                    style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)
                  ),
                  const Spacer(),
                  Container(
                    width: 2,
                    color: Colors.black54,
                  ),
                  const Spacer(),
                    Container(
                      width: 150, 
                      child: Text(applicationBloc.stations[widget.index].name,
                             overflow: TextOverflow.ellipsis,
                             style: TextStyle(fontSize: 20.0)),
                    ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Text(
                              applicationBloc.stations[widget.index].bikes.toString(),
                              style: TextStyle(fontSize: 15.0),
                            ),
                            Icon(
                              Icons.directions_bike,
                              size: 20.0,
                            ),
                          ],
                        ),
                        const SizedBox(width: 5.0),
                        Column(
                          children: [
                            Text(
                              applicationBloc.stations[widget.index].totalDocks.toString(),
                              style: TextStyle(fontSize: 15.0),
                            ),
                            Icon(
                              Icons.chair_alt,
                              size: 20.0,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                ],
              ))),
    );
  }
}

void stationClicked(int index) {
  print("Station of index $index was tapped"); 
}