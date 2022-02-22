import 'dart:async';

import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/managers/LocationManager.dart';
import 'package:bicycle_trip_planner/managers/StationManager.dart';
import 'package:bicycle_trip_planner/models/station.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:bicycle_trip_planner/models/locator.dart' as Locater;
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
      onTap: () => stationClicked(widget.index, applicationBloc, stationManager.getStationByIndex(widget.index).name),
      child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.85,
          child: Card(
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
                              style: const TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)
                          ),
                        ),
                        const Spacer(flex: 1),
                      ],
                    ),
                    const Divider(),
                    Row(
                      children: [
                        const Icon(
                          Icons.directions_bike,
                          size: 20.0,
                        ),
                        Text(
                          "\t\t${stationManager.getStationByIndex(widget.index).bikes.toString()} bikes available",
                          style: const TextStyle(fontSize: 15.0),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.chair_alt,
                          size: 20.0,
                        ),
                        Text(
                          "\t\t${stationManager.getStationByIndex(widget.index).totalDocks.toString()} free docks",
                          style: const TextStyle(fontSize: 15.0),
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

void stationClicked(int index, ApplicationBloc appBloc, String stationName) {
  appBloc.setSelectedScreen('routePlanning', selectedStartStation: stationName);
}
