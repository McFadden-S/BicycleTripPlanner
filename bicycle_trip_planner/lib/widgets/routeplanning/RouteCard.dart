import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/models/search_types.dart';
import 'package:flutter/material.dart';

import 'package:bicycle_trip_planner/widgets/routeplanning/IntermediateSearchList.dart';
import 'package:bicycle_trip_planner/widgets/general/Search.dart';
import 'package:provider/provider.dart';

class RouteCard extends StatefulWidget {
  String? selectedStation;
  RouteCard({Key? key, this.selectedStation}) : super(key: key);

  @override
  _RouteCardState createState() => _RouteCardState();
}

class _RouteCardState extends State<RouteCard> {

  TextEditingController startSearchController = TextEditingController();
  final TextEditingController destinationSearchController = TextEditingController();
  final List<TextEditingController> intermediateSearchControllers = <TextEditingController>[];

  final RouteManager routeManager = RouteManager();

  bool isShowingIntermediate = false;

  void toggleShowingIntermediate(){
    setState(()=> {isShowingIntermediate = !isShowingIntermediate});

  }

  List<String> getIntermediateSearchText(){
    if(intermediateSearchControllers.isNotEmpty){
      return intermediateSearchControllers.map((controller) => controller.text).toList();
    }
    return <String>[];
  }

  @override
  Widget build(BuildContext context) {

    final applicationBloc = Provider.of<ApplicationBloc>(context, listen: false);

    if(widget.selectedStation != null) {
      routeManager.setStart(widget.selectedStation!);
      startSearchController.text = widget.selectedStation!;
      widget.selectedStation = null;
    }

    if(routeManager.ifStartSet() && routeManager.ifDestinationSet() && routeManager.ifChanged()){
      applicationBloc.findRoute(
          routeManager.getStart(),
          routeManager.getDestination(),
          routeManager.getIntermediates()
      );
      routeManager.clearChanged();
    }

        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                offset: const Offset(0,10),
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
                                searchType: SearchType.start,
                            ),
                          ),
                          IntermediateSearchList(
                            intermediateSearchControllers: intermediateSearchControllers,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Search(
                              labelTextIn: "Destination",
                              searchController: destinationSearchController,
                              searchType: SearchType.end,
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
