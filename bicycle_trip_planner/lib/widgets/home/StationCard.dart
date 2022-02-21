import 'dart:async';

import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/managers/LocationManager.dart';
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

  double distance = 0;

  @override
  void initState() {
    super.initState();

    final ApplicationBloc applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);

    // Obtain initial distances from current position (for quicker loading)
    Station station = applicationBloc.stations[widget.index];
    LatLng stationPos = LatLng(station.lat, station.long);

    locationManager.distanceTo(stationPos).then((distance) => {
     setState(() {this.distance = distance;}) 
    });

    locatorSubscription =
        Geolocator.getPositionStream(locationSettings: locationManager.locationSettings)
            .listen((Position position) {
      LatLng pos = LatLng(position.latitude, position.longitude);
      setState(() {
        distance = locationManager.distanceFromTo(pos, stationPos);
      });
    });
  }

  @override
  void setState(fn) {
    try {
      super.setState(fn);
    } catch (e) {};
  }

  @override
  void dispose() {
    try {
      final ApplicationBloc applicationBloc =
          Provider.of<ApplicationBloc>(context, listen: false);
      applicationBloc.dispose();
    } catch (e) {}
    ;
    locatorSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    final applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);

    return InkWell(
      onTap: () => stationClicked(widget.index),
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
                              applicationBloc.stations[widget.index].name,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)
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
                          "\t\t${applicationBloc.stations[widget.index].bikes.toString()} bikes available",
                          style: TextStyle(fontSize: 15.0),
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
                          "\t\t${applicationBloc.stations[widget.index].totalDocks.toString()} free docks",
                          style: TextStyle(fontSize: 15.0),
                        ),
                        Spacer(),
                        Container(
                          child: Text(
                              "${distance.toStringAsFixed(1)}mi",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 12.0, color: Colors.blueAccent)
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

void stationClicked(int index) {
  print("Station of index $index was tapped");
}
