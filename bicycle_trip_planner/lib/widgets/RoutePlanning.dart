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

class RoutePlanningDirection extends StatelessWidget {
  RoutePlanningDirection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        color: Colors.cyanAccent,
        child: ListView(
          children: [
            TextField(
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(),
                labelText: 'Stop',
              ),
            ),
          ],
        )
      ),
    );
  }
}