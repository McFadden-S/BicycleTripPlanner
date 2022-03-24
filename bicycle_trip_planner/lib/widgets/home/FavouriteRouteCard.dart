import 'dart:async';

import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/managers/DialogManager.dart';
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

class FavouriteRouteCard extends StatefulWidget {
  final int index;
  final Function(int)? deleteRoute;

  const FavouriteRouteCard(
      {Key? key, required this.index, required this.deleteRoute})
      : super(key: key);

  @override
  _FavouriteRouteCardState createState() => _FavouriteRouteCardState();
}

class _FavouriteRouteCardState extends State<FavouriteRouteCard> {
  late StreamSubscription locatorSubscription;

  @override
  Widget build(BuildContext context) {
    final applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);
    return InkWell(
      onTap: () {
        Navigator.of(context).maybePop();
        routeClicked(applicationBloc,
            DatabaseManager().getFavouriteRouteByIndex(widget.index)!, context);
      },
      onDoubleTap: () {
        if(DatabaseManager().isUserLogged()) {
          DatabaseManager().removeFavouriteRoute(DatabaseManager().getRouteKeyByIndex(widget.index));
        }
      },
      onLongPress: () {
        if(DatabaseManager().isUserLogged()) {
          DatabaseManager().removeFavouriteRoute(DatabaseManager().getRouteKeyByIndex(widget.index));
        }
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
                    children: [
                      Icon(
                        Icons.place_outlined,
                        size: 20.0,
                        color: ThemeStyle.secondaryIconColor,
                      ),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width * 0.85) - 70.0,
                        child: Text(
                          "\t\t${DatabaseManager().getFavouriteRouteByIndex(widget.index)!.getStart().getStop().name}",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 15.0,
                              color: ThemeStyle.secondaryTextColor),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Row(children: [SizedBox(width: 8.0,), Icon(Icons.circle, size: 4.0, color: ThemeStyle.secondaryIconColor,)]),
                  Spacer(),
                  Row(
                      children: [
                        SizedBox(width: 8.0,),
                        Icon(Icons.circle, size: 4.0, color: ThemeStyle.secondaryIconColor,),
                        SizedBox(width: 8.0,),
                        SizedBox(
                          width: (MediaQuery.of(context).size.width * 0.85) - 70.0,
                          child:
                            Text("\t\t${DatabaseManager().getFavouriteRouteByIndex(widget.index)!.getWaypoints().map((e) => e.getStop().name).join(", ")}",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 15.0, color: ThemeStyle.secondaryFontColor,)
                            )
                          ),
                        SizedBox(width: 20),
                        ]
                  ),
                  Spacer(),
                  Row(children: [SizedBox(width: 8.0,), Icon(Icons.circle, size: 4.0, color: ThemeStyle.secondaryIconColor,)]),
                  Spacer(),
                  Row(
                    children: [
                      Icon(
                        Icons.place,
                        size: 20.0,
                        color: ThemeStyle.secondaryIconColor,
                      ),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width * 0.85) - 80.0,
                        child: Text(
                          "\t\t${DatabaseManager().getFavouriteRouteByIndex(widget.index)!.getDestination().getStop().name}",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 15.0,
                              color: ThemeStyle.secondaryTextColor),
                        ),
                      ),
                      Spacer(flex: 5,),
                      SizedBox(
                        width:20,
                        height: 34,
                        child: IconButton(
                          icon: Icon(Icons.delete_forever, size:20, color: ThemeStyle.secondaryIconColor,),
                          onPressed: (){widget.deleteRoute!(widget.index);},
                        ),
                      ),
                      const Spacer(flex: 1),
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

Future<void> routeClicked(
    ApplicationBloc appBloc, Pathway pathway, context) async {
      RouteManager routeManager = RouteManager();
      routeManager.getStart().setStop(pathway.getStart().getStop());
      routeManager.getDestination().setStop(pathway.getDestination().getStop());
      routeManager.removeWaypoints();
      pathway.getWaypoints().forEach((element) {routeManager.addWaypoint(element.getStop());});

      appBloc.setSelectedScreen('routePlanning');

      appBloc.findRoute(
          routeManager.getStart().getStop(),
          routeManager.getDestination().getStop(),
          routeManager
              .getWaypoints()
              .map((waypoint) => waypoint.getStop())
              .toList(),
          routeManager.getGroupSize());
}
