import 'package:bicycle_trip_planner/widgets/Map.dart';
import 'package:bicycle_trip_planner/widgets/RouteCard.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'CircleButton.dart';
import 'Search.dart';

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
        child: Stack(
          children: [
            MapWidget(),
            Column(
              children: [
                const Spacer(),
                RouteCard(),
                const Spacer(),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  //TODO: an empty function is being passed here for now
                  CircleButton(
                      iconIn: Icons.location_searching,
                      onButtonClicked: () => {print("location_searching icon")})
                ]),
                const Spacer(),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  //TODO: an empty function is being passed here for now
                  CircleButton(
                      iconIn: Icons.group,
                      onButtonClicked: () => {print("group icon")})
                ]),
                const Spacer(flex: 50),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Card(
                      child: Container(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          children: [
                            Column(
                              children: const [Icon(Icons.timer), Text("[ETA]")]),
                            const Text("3.5 miles")
                      ],
                    ),
                  )),
                  const Spacer(flex: 10),
                  //TODO: an empty function is being passed here for now
                  CircleButton(
                      iconIn: Icons.directions_bike,
                      onButtonClicked: () => {print("directions_bike icon")})
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
