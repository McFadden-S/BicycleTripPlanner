import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/managers/DirectionManager.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DistanceETACard extends StatefulWidget {
  const DistanceETACard({Key? key}) : super(key: key);

  // This is not station card needs renaming
  @override
  _StationCardState createState() => _StationCardState();
}

class _StationCardState extends State<DistanceETACard> {
  final DirectionManager _directionManager = DirectionManager();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ApplicationBloc>(context);
    return Card(
        color: ThemeStyle.cardColor,
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
        child: Container(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: [
              RouteManager().ifLoading()
                  ? CircularProgressIndicator(color: Colors.white)
                  : Column(children: [
                      Icon(Icons.access_time_outlined,
                          color: ThemeStyle.secondaryIconColor),
                      Text(
                        _directionManager.getDuration(),
                        style: TextStyle(color: ThemeStyle.secondaryTextColor),
                      )
                    ]),
              Text(_directionManager.getDistance(),
                  style: TextStyle(color: ThemeStyle.secondaryTextColor))
            ],
          ),
        ));
  }
}
