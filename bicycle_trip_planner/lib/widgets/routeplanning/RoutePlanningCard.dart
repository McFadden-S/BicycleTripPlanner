import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/managers/PolylineManager.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/models/place.dart';
import 'package:bicycle_trip_planner/models/search_types.dart';
import 'package:flutter/material.dart';

import 'package:bicycle_trip_planner/widgets/routeplanning/IntermediateSearchList.dart';
import 'package:bicycle_trip_planner/widgets/general/other/Search.dart';
import 'package:provider/provider.dart';

class RoutePlanningCard extends StatefulWidget {
  const RoutePlanningCard({Key? key}) : super(key: key);

  @override
  _RoutePlanningCardState createState() => _RoutePlanningCardState();
}

class _RoutePlanningCardState extends State<RoutePlanningCard> {
  final TextEditingController startSearchController = TextEditingController();
  final TextEditingController endSearchController = TextEditingController();

  final RouteManager routeManager = RouteManager();
  final PolylineManager polylineManager = PolylineManager();

  bool isShowingIntermediate = false;

  void toggleShowingIntermediate() {
    setState(() => {isShowingIntermediate = !isShowingIntermediate});
  }

  ///@param void
  ///@return bool
  ///@effect - Returns whether the route has a start, destination and has been changed
  bool ifRouteSetAndChanged() {
    return routeManager.ifStartSet() &&
        routeManager.ifDestinationSet() &&
        routeManager.ifChanged();
  }

  ///@param void
  ///@return bool
  ///@effect - Returns whether the route has not been set but has been changed
  bool ifNoRouteAndChanged() {
    return (!routeManager.ifStartSet() || !routeManager.ifDestinationSet()) &&
        routeManager.ifChanged();
  }

  ///@param void
  ///@return bool
  ///@effect - Returns whether the user is starting from their current location
  bool ifStartFromCurrentLocation() {
    return routeManager.getStart().getStop().description ==
        SearchType.current.description;
  }

  ///@param ApplicationBloc
  ///@return void
  ///@effect - Sets and views the new route based on whether the cost
  ///          is optimised or not
  void findRoute(ApplicationBloc applicationBloc) {
    Place origin = routeManager.getStart().getStop();
    Place destination = routeManager.getDestination().getStop();
    int groupSize = routeManager.getGroupSize();
    bool ifCostOptimised = routeManager.ifCostOptimised();
    List<Place> places = routeManager
        .getWaypoints()
        .map((waypoint) => waypoint.getStop())
        .toList();
    ifCostOptimised
        ? applicationBloc.findCostEfficientRoute(origin, destination, groupSize)
        : applicationBloc.findRoute(origin, destination, places, groupSize);
  }

  //TODO:Look into preventing rebuild
  //Build method is called one more time before navigation starts resulting in a waste of api calls
  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context);

    if (ifRouteSetAndChanged()) {
      polylineManager.clearPolyline();
      ifStartFromCurrentLocation()
          ? routeManager.setStartFromCurrentLocation(true)
          : routeManager.setStartFromCurrentLocation(false);
      findRoute(applicationBloc);
      routeManager.clearChanged();
    } else if (ifNoRouteAndChanged()) {
      polylineManager.clearPolyline();
      routeManager.clearRouteMarkers();
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
