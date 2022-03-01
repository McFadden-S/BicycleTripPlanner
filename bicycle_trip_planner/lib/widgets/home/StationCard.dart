import 'dart:async';

import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/managers/LocationManager.dart';
import 'package:bicycle_trip_planner/managers/StationManager.dart';
import 'package:bicycle_trip_planner/models/search_types.dart';
import 'package:bicycle_trip_planner/models/station.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StationCard extends StatefulWidget {
  final int index;

  const StationCard({Key? key, required this.index}) : super(key: key);

  @override
  _StationCardState createState() => _StationCardState();
}

class _StationCardState extends State<StationCard> {

  late StreamSubscription locatorSubscription;

  final LocationManager locationManager = LocationManager();
  final StationManager stationManager = StationManager();

  @override
  void setState(fn) {
    try {
      super.setState(fn);
    } catch (e) {};
  }

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context, listen: false);
    return InkWell(
      onTap: () => stationClicked(widget.index, applicationBloc, stationManager.getStationByIndex(widget.index)),
      child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.85,
          child: Card(
            color: ThemeStyle.cardColor,
            child:
              Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Expanded(
                          flex: 25,
                          child: Text(
                              stationManager.getStationByIndex(widget.index).name,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold, color: ThemeStyle.secondaryTextColor)
                          ),
                        ),
                        const Spacer(flex: 1),
                      ],
                    ),
                    const Divider(),
                    Row(
                      children: [
                        Icon(
                          Icons.directions_bike,
                          size: 20.0,
                            color: ThemeStyle.secondaryIconColor,
                        ),
                        Text(
                          "\t\t${stationManager.getStationByIndex(widget.index).bikes.toString()} bikes available",
                          style: TextStyle(fontSize: 15.0, color: ThemeStyle.secondaryTextColor),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.chair_alt,
                          size: 20.0,
                            color: ThemeStyle.secondaryIconColor,
                        ),
                        Text(
                          "\t\t${stationManager.getStationByIndex(widget.index).totalDocks.toString()} free docks",
                          style: TextStyle(fontSize: 15.0, color: ThemeStyle.secondaryTextColor),
                        ),
                        const Spacer(),
                        Container(
                          child: Text(
                              "${stationManager.getStationByIndex(widget.index).distanceTo.toStringAsFixed(1)}mi",
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12.0, color: Colors.blueAccent)
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
          ),
      ),
    );
  }
}

void stationClicked(int index, ApplicationBloc appBloc, Station station) {
  appBloc.searchSelectedStation(station);
  appBloc.setSelectedScreen('routePlanning');
  appBloc.pushPrevScreen('home');
}
