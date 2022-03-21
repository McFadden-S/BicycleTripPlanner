import 'dart:async';

import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/managers/DialogManager.dart';
import 'package:bicycle_trip_planner/managers/FavouriteRoutesManager.dart';
import 'package:bicycle_trip_planner/managers/LocationManager.dart';
import 'package:bicycle_trip_planner/managers/PolylineManager.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/managers/StationManager.dart';
import 'package:bicycle_trip_planner/models/distance_types.dart';
import 'package:bicycle_trip_planner/models/station.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../managers/DatabaseManager.dart';
import '../../models/pathway.dart';

class RouteCard extends StatefulWidget {
  final int index;

  const RouteCard(
      {Key? key, required this.index})
      : super(key: key);

  @override
  _RouteCardState createState() => _RouteCardState();
}

class _RouteCardState extends State<RouteCard> {
  late StreamSubscription locatorSubscription;

  final FavouriteRoutesManager favouriteRoutesManager = FavouriteRoutesManager();


  @override
  Widget build(BuildContext context) {
    final applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);
    return InkWell(
      onTap: () {
        Navigator.of(context).maybePop();
        routeClicked(applicationBloc,
            favouriteRoutesManager.getFavouriteRouteByIndex(widget.index), context);
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.85,
        child: Card(
            color: ThemeStyle.cardColor,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  /*Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                    ],
                  ),*/
                  //const Divider(),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "From:\t${favouriteRoutesManager.getFavouriteRouteByIndex(widget.index).getStart().getStop().name}",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 15.0,
                              color: ThemeStyle.secondaryTextColor),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "To:\t${favouriteRoutesManager.getFavouriteRouteByIndex(widget.index).getDestination().getStop().name}",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 15.0,
                              color: ThemeStyle.secondaryTextColor),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

Future<void> routeClicked(
    ApplicationBloc appBloc, Pathway pathway, context) async {
    RouteManager().getStart().setStop(pathway.getStart().getStop());
    RouteManager().getDestination().setStop(pathway.getDestination().getStop());
    appBloc.setSelectedScreen('routePlanning');
    RouteManager routeManager = RouteManager();
    appBloc.findRoute(
        routeManager.getStart().getStop(),
        routeManager.getDestination().getStop(),
        routeManager
            .getWaypoints()
            .map((waypoint) => waypoint.getStop())
            .toList(),
        routeManager.getGroupSize());
}
