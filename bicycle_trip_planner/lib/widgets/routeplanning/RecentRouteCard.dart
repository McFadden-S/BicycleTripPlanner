import 'dart:async';
import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/managers/UserSettings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/pathway.dart';

class RecentRouteCard extends StatefulWidget {
  final int index;

  const RecentRouteCard({Key? key, required this.index}) : super(key: key);

  @override
  _RouteCardState createState() => _RouteCardState();
}

class _RouteCardState extends State<RecentRouteCard> {
  late String startDescription = 'No DATA';
  late String endDescription= 'No DATA';
  late List<String> stopsDescriptions = [];
  final UserSettings _userSettings = UserSettings();

  @override
  void initState() {
    super.initState();
    setState(() {
      initVariables();
    });
  }

  @override
  Widget build(BuildContext context) {
    // final applicationBloc = Provider.of<ApplicationBloc>(context, listen: false);
    return InkWell(
      // onTap: () {
      //   Navigator.of(context).maybePop();
      //   routeClicked(applicationBloc,
      //       favouriteRoutesManager.getFavouriteRouteByIndex(widget.index)!, context);
      // },
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
                          //"\t\t${favouriteRoutesManager.getFavouriteRouteByIndex(widget.index)!.getStart().getStop().name}",
                          startDescription,
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
                            "\t\t${stopsDescriptions.join(", ")}",
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
                          endDescription,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 15.0,
                              color: ThemeStyle.secondaryTextColor),
                        ),
                      ),
                      Spacer(
                        flex: 5,
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

  Future<void> initVariables() async {
    Pathway recentRoute = await _userSettings.getRecentRoute(widget.index);
    startDescription = recentRoute.getStart().getStop().description;
    endDescription = recentRoute.getDestination().getStop().description;
    for(var stop in recentRoute.getWaypoints()){
      stopsDescriptions.add(stop.getStop().description);
    }
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
