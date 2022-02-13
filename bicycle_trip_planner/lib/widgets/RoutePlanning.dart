import 'package:bicycle_trip_planner/widgets/RouteCard.dart';
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
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
        child: Column(
          children: [
            const Spacer(),
            RouteCard(), 
            const Spacer(),
            Row (
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () => {},
                    child: const Icon(Icons.location_searching),
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(10),
                    ),
                  )
                ]
            ),
            const Spacer(),
            Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // TODO Make elevated button its own method/class? (Pass in the icon it needs)
                  ElevatedButton(
                    onPressed: () => {},
                    child: const Icon(Icons.group),
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(10),
                    ),
                  )
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
                  // TODO Button repeated here
                  ElevatedButton(
                    onPressed: () => {},
                    child: const Icon(Icons.directions_bike),
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(10),
                    ),
                  )
                ]
            ),
          ],
        ),

  ),
  ),
  );
}
}