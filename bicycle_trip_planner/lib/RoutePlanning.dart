import 'package:flutter/material.dart';


class RoutePlanning extends StatefulWidget {
  const RoutePlanning({Key? key}) : super(key: key);

  @override
  _RoutePlanningState createState() => _RoutePlanningState();
}

class _RoutePlanningState extends State<RoutePlanning> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
            color: Colors.deepPurple,
            child: Column(
              children: <Widget> [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(),
                        labelText: 'Starting Point',
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: TextButton(
                      child: const Text("Add Stop(s)"),
                      onPressed: () => {
                        // display more textfields for users to enter intermediate stops
                      }
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(),
                        labelText: 'Destination',
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                          flex: 1,
                          child: IconButton(
                            alignment: Alignment.centerRight,
                            icon: const Icon(Icons.location_searching),
                            onPressed: () => {
                              // this button recenters the map on the user's current location
                            },
                          )),
                      Expanded(
                          flex: 1,
                          child: IconButton(
                            alignment: Alignment.centerRight,
                            icon: const Icon(Icons.group),
                            onPressed: () => {
                              // this should expand the group menu to allow the user the select their group's size
                            },
                          )),
                      Expanded(
                          flex: 4,
                          child: SizedBox(
                            height: 1000,
                          )
                          ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () => {
                          // this should expand the menu to show the user their distance and ETA
                        },
                        icon: const Icon(Icons.arrow_right_rounded)
                    ),
                    IconButton(
                        onPressed: () => {
                          // this should start the journey and redirect the user to the navigation screen
                        },
                        icon: const Icon(Icons.directions_bike)
                    )
                  ],
                )
              ],
            ),
          )
      ),
    );
  }
}