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
                            InkWell(
                              splashColor: Colors.deepPurple.withAlpha(30),
                              onTap: toggleShowingIntermediate,
                              child: Column(
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        addStopWidget();
                                      } ,
                                      child: const Text(
                                        'Add Stop(s)',
                                        style: TextStyle(
                                          fontFamily: 'Outfit',
                                          fontSize: 16.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(12, 156, 238, 1.0)),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(30.0),
                                              side: BorderSide(color: Color.fromRGBO(12, 156, 238, 1.0))
                                          ),
                                        ),
                                      ),
                                    ),
                                  if(isShowingIntermediate)
                                    LimitedBox(
                                      maxHeight: MediaQuery.of(context).size.height * 0.2,
                                      child: ListView(
                                        shrinkWrap: true,
                                        children: stopsList.toList(growable: true),
                                      ),
                                    ),
                                    const Icon(Icons.expand_more),
                                ]
                              )
                            ),
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
