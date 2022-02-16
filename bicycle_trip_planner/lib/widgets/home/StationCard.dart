import 'dart:async';

import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
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
  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.best, // How accurate the location is
    distanceFilter:
        150, // The distance needed to travel until the next update (0 means it will always update)
  );

  double distance = 0;

  @override
  void initState() {
    super.initState();

    final ApplicationBloc applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);

    // Obtain initial distances from current position (for quicker loading)
    Station station = applicationBloc.stations[widget.index];
    LatLng stationPos = LatLng(station.lat, station.long);
    Locater.Locator locator = Locater.Locator();
    locator.locate().then((pos) {
      setState(() {
        distance = _convertMetresToMiles(_calculateDistance(pos, stationPos));
      });
    });

    locatorSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      LatLng pos = LatLng(position.latitude, position.longitude);
      station = applicationBloc.stations[widget.index];
      setState(() {
        distance = _convertMetresToMiles(_calculateDistance(pos, stationPos));
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

  double _convertMetresToMiles(double distance) {
    return distance * 0.000621;
  }

  // Returns the distance between the two points in metres
  double _calculateDistance(LatLng pos1, LatLng pos2) {
    return Geolocator.distanceBetween(
        pos1.latitude, pos1.longitude, pos2.latitude, pos2.longitude);
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
