import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/managers/DirectionManager.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


/// Displays the estimated distance and time it'll take on journey
class DistanceETACard extends StatefulWidget {
  const DistanceETACard({Key? key}) : super(key: key);

  @override
  _DistanceETACardState createState() => _DistanceETACardState();
}

class _DistanceETACardState extends State<DistanceETACard> {
  final DirectionManager _directionManager = DirectionManager();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ApplicationBloc>(context);
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        children: [
          RouteManager().ifLoading()
              ? CircularProgressIndicator(color: Colors.blueGrey)
              : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child:
                  Row(
                    children: [
                      Icon(
                          Icons.access_time_outlined,
                          color: ThemeStyle.secondaryIconColor,
                          key: Key("accessTime"),
                      ),
                      //Displays duration
                      Text(' ${_directionManager.getDuration()}',
                        style: TextStyle(color: ThemeStyle.secondaryTextColor),
                        key: Key("duration"),
                      )
                    ],
                  ),
                ),
                  Expanded(
                    child:
                    Row(
                    children: [
                      Icon(Icons.pin_drop,
                          color: ThemeStyle.secondaryIconColor,
                          key: Key("pinDrop"),
                      ),
                      //Displays distance
                      Text(' ${_directionManager.getDistance()}',
                        style: TextStyle(color: ThemeStyle.secondaryTextColor),
                        key: Key("distance")
                      ),
                    ],
                  ),
                )
          ]),
        ],
      ),
    );
  }
}
