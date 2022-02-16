import 'package:bicycle_trip_planner/widgets/IntermediateSearchList.dart';
import 'package:flutter/material.dart';
import 'Search.dart';

class RouteCard extends StatefulWidget {

  final TextEditingController startSearchController;
  final TextEditingController destinationSearchController;

  const RouteCard({
    Key? key,
    required this.startSearchController,
    required this.destinationSearchController
  }) : super(key: key);

  @override
  _RouteCardState createState() => _RouteCardState();
}

class _RouteCardState extends State<RouteCard> {

  @override
  Widget build(BuildContext context) {
        return Card(
          child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Search(
                              labelTextIn: "Starting Point",
                              searchController: widget.startSearchController
                          ),
                          IntermediateSearchList(),
                          Search(
                            labelTextIn: "Destination",
                            searchController: widget.destinationSearchController,
                          ),
                            // const Icon(Icons.expand_more),
                        ],
                      ),
                    ),
                  ],
                ),
        );
  }
}