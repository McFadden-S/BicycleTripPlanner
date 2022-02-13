import 'package:flutter/material.dart';

class RouteCard extends StatefulWidget {
  const RouteCard({ Key? key }) : super(key: key);

  @override
  _RouteCardState createState() => _RouteCardState();
}

class _RouteCardState extends State<RouteCard> {

  List<Widget> stopsList = []; 

  // TODO Initialise the stopsList with its first widget
  _RouteCardState(){
    addStopWidget(); 
  }

  void addStopWidget() {
    stopsList.add(_textBox(text: "Stop"));
  }

  bool extendedRoutePlanning = false;
  void setExtendRoutePlanningView(){
    setState(()=> {extendedRoutePlanning = !extendedRoutePlanning});
  }

  void updateExtendedRoutePlanningView(){
    setState(()=>{extendedRoutePlanning = true});
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
          child: InkWell(
              splashColor: Colors.deepPurple.withAlpha(30),
              onTap: ()=>setExtendRoutePlanningView(),
              child: SizedBox(
                height: !extendedRoutePlanning ? 250 : 350,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _textBox(text: "Starting Point"),
                          TextButton(
                              child: const Text("Add Stop(s)"),
                              onPressed: () {
                                addStopWidget();
                                updateExtendedRoutePlanningView();
                                // setExtendRoutePlanningView();
                              },
                          ),
                          extendedRoutePlanning ?
                          SizedBox(
                            height: 100,
                            child: ListView(
                              shrinkWrap: true,
                              children: stopsList,
                            ),
                          )
                            :
                          const Icon(Icons.expand_more),
                          _textBox(text: "Destination"),
                            // const Icon(Icons.expand_more),
                        ],
                      ),
                    ),
                  ],
                ),
              )
          ),
        );
  }
}