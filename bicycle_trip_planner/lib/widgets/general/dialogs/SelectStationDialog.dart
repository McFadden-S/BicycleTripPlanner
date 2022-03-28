import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/managers/DialogManager.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/managers/StationManager.dart';
import 'package:bicycle_trip_planner/models/place.dart';
import 'package:bicycle_trip_planner/models/stop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectStationDialog extends StatefulWidget {

  const SelectStationDialog({ Key? key}) : super(key: key);

  @override
  _SelectStationDialogState createState() => _SelectStationDialogState();
}

class _SelectStationDialogState extends State<SelectStationDialog> {

  final StationManager stationManager = StationManager();
  final RouteManager routeManager = RouteManager();
  final DialogManager dialogManager = DialogManager();

  @override
  Widget build(BuildContext context) {

    final applicationBloc = Provider.of<ApplicationBloc>(context);

    if(!dialogManager.ifShowingSelectStation()){
      return const SizedBox.shrink();
    }else {
      return Dialog(
        backgroundColor: ThemeStyle.cardColor,
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(20.0)
        ),
        child: Container(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Expanded(child: Text("Set as:", textAlign: TextAlign.center,
                      style: TextStyle(color: ThemeStyle.primaryTextColor))),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromWidth(double.infinity)
                      ),
                      onPressed: () async {
                       _setStation(applicationBloc, routeManager.getStart().getUID());
                      },
                      child: Text("Starting point",
                          style: TextStyle(color: ThemeStyle.primaryTextColor)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromWidth(double.infinity)
                        ),
                        onPressed: () {
                          Stop waypoint = routeManager.addWaypoint(const Place.placeNotFound());
                          _setStation(applicationBloc, waypoint.getUID());
                        },
                        child: Text("Intermediate stop",
                            style: TextStyle(color: ThemeStyle.primaryTextColor))
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromWidth(double.infinity)
                        ),
                        onPressed: () {
                          _setStation(applicationBloc, routeManager.getDestination().getUID());
                        },
                        child: Text("Destination",
                        style: TextStyle(color: ThemeStyle.primaryTextColor))
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromWidth(double.infinity)
                        ),
                        onPressed: () {applicationBloc.clearSelectedStationDialog();},
                        child: Text("Cancel",
                            style: TextStyle(color: ThemeStyle.primaryTextColor))
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            )
        ),
      );
    }
  }

  Future<void> _setStation(ApplicationBloc applicationBloc, int uid) async {
    await applicationBloc.searchSelectedStation(dialogManager.getSelectedStation(), uid);
    applicationBloc.setSelectedScreen('routePlanning');
    applicationBloc.clearSelectedStationDialog();
  }

}