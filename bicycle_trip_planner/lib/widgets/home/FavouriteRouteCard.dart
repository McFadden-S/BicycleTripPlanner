import 'dart:async';

import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/constants.dart';
<<<<<<< HEAD
import 'package:bicycle_trip_planner/managers/DialogManager.dart';
import 'package:bicycle_trip_planner/managers/LocationManager.dart';
import 'package:bicycle_trip_planner/managers/PolylineManager.dart';
=======
>>>>>>> 957c949c6c9690e897b342fbe37b5661b034907b
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../managers/DatabaseManager.dart';
import '../../models/pathway.dart';

class FavouriteRouteCard extends StatefulWidget {
  final String keyRoute;
  final Pathway valueRoute;
  final Function(String)? deleteRoute;

  const FavouriteRouteCard(
      {Key? key,
      required this.keyRoute,
      required this.valueRoute,
      required this.deleteRoute})
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
<<<<<<< HEAD
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
=======
        routeClicked(applicationBloc, widget.valueRoute, context);
      },
      onDoubleTap: () {
        if (DatabaseManager().isUserLogged()) {
          DatabaseManager().removeFavouriteRoute(widget.keyRoute);
        }
      },
      onLongPress: () {
        if (DatabaseManager().isUserLogged()) {
          DatabaseManager().removeFavouriteRoute(widget.keyRoute);
>>>>>>> 957c949c6c9690e897b342fbe37b5661b034907b
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
                        width:
                            (MediaQuery.of(context).size.width * 0.85) - 70.0,
                        child: Text(
<<<<<<< HEAD
                          "\t\t${DatabaseManager().getFavouriteRouteByIndex(widget.index)!.getStart().getStop().name}",
=======
                          "\t\t${widget.valueRoute.getStart().getStop().name}",
>>>>>>> 957c949c6c9690e897b342fbe37b5661b034907b
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 15.0,
                              color: ThemeStyle.secondaryTextColor),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Row(children: [
                    SizedBox(
                      width: 8.0,
                    ),
                    Icon(
                      Icons.circle,
                      size: 4.0,
                      color: ThemeStyle.secondaryIconColor,
                    )
                  ]),
                  Spacer(),
<<<<<<< HEAD
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
=======
                  Row(children: [
                    SizedBox(
                      width: 8.0,
                    ),
                    Icon(
                      Icons.circle,
                      size: 4.0,
                      color: ThemeStyle.secondaryIconColor,
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    SizedBox(
                        width:
                            (MediaQuery.of(context).size.width * 0.85) - 70.0,
                        child: Text(
                            "\t\t${widget.valueRoute.getWaypoints().map((e) => e.getStop().name).join(", ")}",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15.0,
                              color: ThemeStyle.secondaryFontColor,
                            ))),
                    SizedBox(width: 20),
                  ]),
>>>>>>> 957c949c6c9690e897b342fbe37b5661b034907b
                  Spacer(),
                  Row(children: [
                    SizedBox(
                      width: 8.0,
                    ),
                    Icon(
                      Icons.circle,
                      size: 4.0,
                      color: ThemeStyle.secondaryIconColor,
                    )
                  ]),
                  Spacer(),
                  Row(
                    children: [
                      Icon(
                        Icons.place,
                        size: 20.0,
                        color: ThemeStyle.secondaryIconColor,
                      ),
                      SizedBox(
                        width:
                            (MediaQuery.of(context).size.width * 0.85) - 80.0,
                        child: Text(
<<<<<<< HEAD
                          "\t\t${DatabaseManager().getFavouriteRouteByIndex(widget.index)!.getDestination().getStop().name}",
=======
                          "\t\t${widget.valueRoute.getDestination().getStop().name}",
>>>>>>> 957c949c6c9690e897b342fbe37b5661b034907b
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 15.0,
                              color: ThemeStyle.secondaryTextColor),
                        ),
                      ),
                      Spacer(
                        flex: 5,
                      ),
                      SizedBox(
                        width: 20,
                        height: 30,
                        child: IconButton(
                          icon: Icon(
                            Icons.delete_forever,
                            size: 20,
                            color: ThemeStyle.secondaryIconColor,
                          ),
                          onPressed: () {
                            widget.deleteRoute!(widget.keyRoute);
                          },
                        ),
                      ),
                      const Spacer(flex: 1),
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
  RouteManager routeManager = RouteManager();
  routeManager.getStart().setStop(pathway.getStart().getStop());
  routeManager.getDestination().setStop(pathway.getDestination().getStop());
  routeManager.removeWaypoints();
  pathway.getWaypoints().forEach((element) {
    routeManager.addWaypoint(element.getStop());
  });

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
