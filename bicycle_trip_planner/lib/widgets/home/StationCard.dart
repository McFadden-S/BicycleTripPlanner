import 'dart:async';
import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/managers/LocationManager.dart';
import 'package:bicycle_trip_planner/managers/StationManager.dart';
import 'package:bicycle_trip_planner/models/distance_types.dart';
import 'package:bicycle_trip_planner/models/station.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StationCard extends StatefulWidget {
  final Station station;
  final bool? isFavourite;
  final Function(Station)? toggleFavourite;
  final ApplicationBloc? bloc;

  const StationCard(
      {Key? key, required this.station, this.isFavourite, this.toggleFavourite, this.bloc})
      : super(key: key);

  @override
  _StationCardState createState() => _StationCardState();
}

class _StationCardState extends State<StationCard> {
  late StreamSubscription locatorSubscription;

  final LocationManager locationManager = LocationManager();
  final StationManager stationManager = StationManager();
  late ApplicationBloc applicationBloc;

  @override
  void initState() {
    applicationBloc = widget.bloc ?? Provider.of<ApplicationBloc>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () {
        Navigator.of(context).maybePop();
        stationClicked(applicationBloc, widget.station, context);
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
                        child: Text(widget.station.name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                                color: ThemeStyle.secondaryTextColor)),
                      ),
                      const Spacer(flex: 1),
                      if (applicationBloc.isUserLogged())
                        if (widget.isFavourite != null)
                          IconButton(
                            constraints: const BoxConstraints(maxHeight: 25),
                            padding: const EdgeInsets.all(0),
                            iconSize: 20,
                            onPressed: () {
                              setState(() {
                                widget.toggleFavourite!(widget.station);
                              });
                            },
                            icon: widget.isFavourite!
                                ? Icon(Icons.star,
                                    color: ThemeStyle.buttonPrimaryColor)
                                : Icon(Icons.star,
                                    color: ThemeStyle.secondaryIconColor),
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
                        "\t\t${widget.station.bikes.toString()} bikes available",
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
                        "\t\t${widget.station.totalDocks.toString()} free docks",
                        style: TextStyle(
                            fontSize: 15.0,
                            color: ThemeStyle.secondaryTextColor),
                      ),
                      const Spacer(),
                      Container(
                        child: Text(
                            "${widget.station.distanceTo.toStringAsFixed(1)}${locationManager.getUnits().units}",
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
