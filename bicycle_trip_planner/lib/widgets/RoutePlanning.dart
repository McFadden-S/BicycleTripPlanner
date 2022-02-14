import 'package:bicycle_trip_planner/widgets/RouteCard.dart';
import 'package:flutter/material.dart';
import 'CircleButton.dart';


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
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
        child: Column(
          children: [
            const Spacer(),
            RouteCard(), 
            const Spacer(),
            Row (
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  //TODO: an empty function is being passed here for now
                  CircleButton(iconIn: Icons.location_searching, onButtonClicked: () => {print("location_searching icon")})
                ]
            ),
            const Spacer(),
            Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  //TODO: an empty function is being passed here for now
                  CircleButton(iconIn: Icons.group, onButtonClicked: () => {print("group icon")})
                ]
            ),
            const Spacer(flex: 50),
            Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Card(
                      child:
                      Container(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          children: [
                            Column(
                                children: const [
                                  Icon(Icons.timer),
                                  Text("[ETA]")
                                ]
                            ),
                            const Text("3.5 miles")
                          ],
                        ),
                      )
                  ),
                  const Spacer(flex: 10),
                  //TODO: an empty function is being passed here for now
                  CircleButton(iconIn: Icons.directions_bike, onButtonClicked: () => {print("directions_bike icon")})
                ]
            ),
          ],
        ),

  ),
  ),
  );
}
}