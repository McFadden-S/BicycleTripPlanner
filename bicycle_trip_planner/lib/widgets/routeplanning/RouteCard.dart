import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/managers/PolylineManager.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
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

  void toggleShowingIntermediate(){
    setState(()=> {isShowingIntermediate = !isShowingIntermediate});
  }

  @override
  Widget build(BuildContext context) {

    final applicationBloc = Provider.of<ApplicationBloc>(context, listen: false);
    print("StartID ${routeManager.getStart().getUID()}"); 
    print("EndID ${routeManager.getDestination().getUID()}"); 
    print(routeManager.getStart() == routeManager.getDestination());

    if(routeManager.ifStartSet() && routeManager.ifDestinationSet() && routeManager.ifChanged()){
      polylineManager.clearPolyline();
      applicationBloc.findRoute(
          routeManager.getStart().getStop(),
          routeManager.getDestination().getStop(),
          routeManager.getWaypoints().map((waypoint) => waypoint.getStop()).toList()
      );
      routeManager.clearChanged();

    } else if((!routeManager.ifStartSet() || !routeManager.ifDestinationSet()) && routeManager.ifChanged()){
      polylineManager.clearPolyline();
      routeManager.clearChanged();
    }

    //TODO Find way to get current location faster
    // if(!routeManager.ifStartSet()){
    //   applicationBloc.setSelectedCurrentLocation(SearchType.start);
    // }

        return Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                offset: Offset(0,10),
                color: Colors.black45,
                blurRadius: 30.0,
              ),
            ],
          ),
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
              side: const BorderSide(color: Color.fromRGBO(38, 36, 36, 1.0), width: 1.0),
            ),
            child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                    ],
                  ),
          ),
        );
  }
}
