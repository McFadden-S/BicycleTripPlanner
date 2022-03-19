import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/managers/PolylineManager.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/models/search_types.dart';
import 'package:flutter/material.dart';

import 'package:bicycle_trip_planner/widgets/routeplanning/IntermediateSearchList.dart';
import 'package:bicycle_trip_planner/widgets/general/Search.dart';
import 'package:provider/provider.dart';

class RouteCard extends StatefulWidget {
  const RouteCard({Key? key}) : super(key: key);

  @override
  _RouteCardState createState() => _RouteCardState();
}

class _RouteCardState extends State<RouteCard> {
  final TextEditingController startSearchController = TextEditingController();
  final TextEditingController endSearchController = TextEditingController();

  final RouteManager routeManager = RouteManager();
  final PolylineManager polylineManager = PolylineManager();

  bool isShowingIntermediate = false;

  void toggleShowingIntermediate() {
    setState(() => {isShowingIntermediate = !isShowingIntermediate});
  }

  //TODO:Look into preventing rebuild
  //Build method is called one more time before navigation starts resulting in a waste of api calls
  @override
  Widget build(BuildContext context) {
    final applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);

    if (routeManager.ifStartSet() &&
        routeManager.ifDestinationSet() &&
        routeManager.ifChanged()) {
      polylineManager.clearPolyline();
      print("Description: ${routeManager.getStart().getStop().description}");
      routeManager.getStart().getStop().description ==
              SearchType.current.description
          ? routeManager.setStartFromCurrentLocation(true)
          : routeManager.setStartFromCurrentLocation(false);
      applicationBloc.findRoute(
          routeManager.getStart().getStop(),
          routeManager.getDestination().getStop(),
          routeManager
              .getWaypoints()
              .map((waypoint) => waypoint.getStop())
              .toList(),
          routeManager.getGroupSize());
      routeManager.clearChanged();
    } else if ((!routeManager.ifStartSet() ||
            !routeManager.ifDestinationSet()) &&
        routeManager.ifChanged()) {
      polylineManager.clearPolyline();
      routeManager.clearChanged();
    }

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 10),
            color: ThemeStyle.boxShadow,
            blurRadius: 30.0,
          ),
        ],
      ),
      child: Card(
        color: ThemeStyle.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
          side: BorderSide(color: ThemeStyle.boxShadow, width: 1.0),
        ),
        child: LimitedBox(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Search(
                    labelTextIn: "Starting Point",
                    searchController: startSearchController,
                    uid: routeManager.getStart().getUID(),
                  ),
                ),
                IntermediateSearchList(),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Search(
                    labelTextIn: "Destination",
                    searchController: endSearchController,
                    uid: routeManager.getDestination().getUID(),
                  ),
                ),
                // const Icon(Icons.expand_more),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
