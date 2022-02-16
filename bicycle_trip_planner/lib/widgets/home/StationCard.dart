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
          height: 60,
          child: Card(
              child: Row(
            children: [
              const Spacer(),
              Text("${distance.toStringAsFixed(1)}mi",
                  style: const TextStyle(
                      fontSize: 15.0, fontWeight: FontWeight.bold)),
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
                    style: const TextStyle(fontSize: 20.0)),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          applicationBloc.stations[widget.index].bikes
                              .toString(),
                          style: const TextStyle(fontSize: 15.0),
                        ),
                        const Icon(
                          Icons.directions_bike,
                          size: 20.0,
                        ),
                      ],
                    ),
                    const SizedBox(width: 5.0),
                    Column(
                      children: [
                        Text(
                          applicationBloc.stations[widget.index].totalDocks
                              .toString(),
                          style: const TextStyle(fontSize: 15.0),
                        ),
                        const Icon(
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
