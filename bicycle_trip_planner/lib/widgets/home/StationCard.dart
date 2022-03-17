import 'dart:async';

import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/managers/DialogManager.dart';
import 'package:bicycle_trip_planner/managers/LocationManager.dart';
import 'package:bicycle_trip_planner/managers/StationManager.dart';
import 'package:bicycle_trip_planner/models/station.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../managers/DatabaseManager.dart';

class StationCard extends StatefulWidget {
  final int index;
  final bool?  isFavourite;
  final Function(int)? toggleFavourite;

  const StationCard({Key? key, required this.index, this.isFavourite, this.toggleFavourite}) : super(key: key);

  @override
  _StationCardState createState() => _StationCardState();
}

class _StationCardState extends State<StationCard> {
  late StreamSubscription locatorSubscription;

  final LocationManager locationManager = LocationManager();
  final StationManager stationManager = StationManager();

  @override
  Widget build(BuildContext context) {
    final applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);
    return InkWell(
      onTap: () {
        Navigator.of(context).maybePop();
        stationClicked(applicationBloc,
            stationManager.getStationByIndex(widget.index), context);
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.85,
        child: Card(
            color: ThemeStyle.cardColor,
            child: Container(
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
                            style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                                color: ThemeStyle.secondaryTextColor)),
                      ),
                      const Spacer(flex: 1),
                      if(applicationBloc.isUserLogged())
                        if(widget.isFavourite != null)
                        IconButton(
                          constraints: BoxConstraints(maxHeight: 25),
                          padding: EdgeInsets.all(0),
                          iconSize: 20,
                          onPressed: () {widget.toggleFavourite!(widget.index);},
                          icon: widget.isFavourite!
                              ? Icon(Icons.star, color: ThemeStyle.buttonPrimaryColor)
                              : Icon(Icons.star, color: ThemeStyle.secondaryIconColor),
                        ),
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
                        style: TextStyle(
                            fontSize: 15.0,
                            color: ThemeStyle.secondaryTextColor),
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
                        style: TextStyle(
                            fontSize: 15.0,
                            color: ThemeStyle.secondaryTextColor),
                      ),
                      const Spacer(),
                      Container(
                        child: Text(
                            "${stationManager.getStationByIndex(widget.index).distanceTo.toStringAsFixed(1)}mi",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 12.0, color: Colors.blueAccent)),
                      ),
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

Future<void> stationClicked(
    ApplicationBloc appBloc, Station station, context) async {
    appBloc.showSelectedStationDialog(station);
}
