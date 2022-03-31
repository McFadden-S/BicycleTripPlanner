import 'dart:async';
import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/managers/MarkerManager.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/models/stop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
        routeClicked(applicationBloc, widget.valueRoute, context);
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
                          "\t\t${widget.valueRoute.getStart().getStop().description}",
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
                            "\t\t${widget.valueRoute.getWaypoints().map((e) => e.getStop().description).join(", ")}",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15.0,
                              color: ThemeStyle.secondaryFontColor,
                            ))),
                    SizedBox(width: 20),
                  ]),
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
                          "\t\t${widget.valueRoute.getDestination().getStop().description}",
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
  MarkerManager markerManager = MarkerManager();
  routeManager.clearPathwayMarkers();
  routeManager.clearRouteMarkers();
  routeManager.getStart().setStop(pathway.getStart().getStop());
  routeManager.getDestination().setStop(pathway.getDestination().getStop());
  routeManager.removeWaypoints();
  pathway.getWaypoints().forEach((element) {
    Stop stop = routeManager.addWaypoint(element.getStop());
    markerManager.setPlaceMarker(stop.getStop(), stop.getUID());
  });
  markerManager.setPlaceMarker(
      routeManager.getStart().getStop(), routeManager.getStart().getUID());
  markerManager.setPlaceMarker(routeManager.getDestination().getStop(),
      routeManager.getDestination().getUID());

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
