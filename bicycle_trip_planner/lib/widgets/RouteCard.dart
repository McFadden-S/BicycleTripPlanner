import 'package:flutter/material.dart';
import 'Search.dart';

class RouteCard extends StatefulWidget {

  final TextEditingController originSearchController;
  final TextEditingController destinationSearchController;

  const RouteCard({
    Key? key,
    required this.originSearchController,
    required this.destinationSearchController,
  }) : super(key: key);

  @override
  _RouteCardState createState() => _RouteCardState();
}

class _RouteCardState extends State<RouteCard> {

  List<Widget> stopsList = [];
  bool isShowingIntermediate = false;

  void addStopWidget() {
    setState(() {
      stopsList.add(_textBox(text: "Stop"));
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
                              searchController: widget.originSearchController
                          ),
                          InkWell(
                            splashColor: Colors.deepPurple.withAlpha(30),
                            onTap: toggleShowingIntermediate,
                            child: Column(
                                children: [
                                  TextButton(
                                    child: const Text("Add Stop(s)"),
                                    onPressed: () {
                                      addStopWidget();
                                    },
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
        );
  }
}