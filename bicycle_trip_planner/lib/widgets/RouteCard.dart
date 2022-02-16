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

  List<Widget> stopsList = [];
  bool isShowingIntermediate = false;

  void addStopWidget() {
    setState(() {
      stopsList.add(Search(
        labelTextIn: "Stop",
        searchController: widget.startSearchController,
      ),);
      isShowingIntermediate = true;
    });
  }

  void toggleShowingIntermediate(){
    setState(()=> {isShowingIntermediate = !isShowingIntermediate});
  }

  // TODO Should this be abstracted as well?
  Widget _textBox({String text = ""}){
    return Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(),
                labelText: text,
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
        return Container(
          decoration: new BoxDecoration(
            boxShadow: [
              new BoxShadow(
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
              side: BorderSide(color: Color.fromRGBO(38, 36, 36, 1.0), width: 1.0),
            ),
            child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Search(
                                labelTextIn: "Starting Point",
                                searchController: widget.startSearchController,
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
          ),
        );
  }
}
