import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/managers/StationManager.dart';
import 'package:bicycle_trip_planner/models/station.dart';
import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bicycle_trip_planner/widgets/home/StationCard.dart';

class StartIntermediateEndDialog extends StatefulWidget {
  const StartIntermediateEndDialog({ Key? key }) : super(key: key);

  @override
  _StartIntermediateEndDialogState createState() => _StartIntermediateEndDialogState();
}

class _StartIntermediateEndDialogState extends State<StartIntermediateEndDialog> {

  final StationManager stationManager = StationManager();
  final RouteManager routeManager = RouteManager();

  void setStart(Station start) {
    //get the place from the station
    // routeManager.addStart();
  }

  void setIntermediate(Station intermediate) {

  }

  void setEnd(Station end) {

  }

  @override
  Widget build(BuildContext context) {

    final applicationBloc = Provider.of<ApplicationBloc>(context);

    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(20.0)
      ),
      child: Container(
          height: 200,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                Expanded(child: Text("Set as:", textAlign: TextAlign.center)),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size.fromWidth(double.infinity)
                    ),
                    // onPressed: () => setStart(station),
                      onPressed: (){},
                    child: Text("Starting point"),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size.fromWidth(double.infinity)
                      ),
                      // onPressed: () => setIntermediate(station),
                      onPressed: (){},
                      child: Text("Intermediate stop")
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size.fromWidth(double.infinity)
                      ),
                      // onPressed: () => setEnd(station),
                      onPressed: (){},
                      child: Text("Destination")
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          )
      ),
    );
  }
}