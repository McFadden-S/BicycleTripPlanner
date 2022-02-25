import 'dart:async';

import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/managers/DirectionManager.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/models/steps.dart';
import 'package:bicycle_trip_planner/models/route.dart' as Rou;
import 'package:bicycle_trip_planner/widgets/navigation/CurrentDirection.dart';
import 'package:bicycle_trip_planner/widgets/navigation/DirectionTile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_html/flutter_html.dart';

class Directions extends StatefulWidget {
  const Directions({Key? key}) : super(key: key);

  @override
  _DirectionsState createState() => _DirectionsState();
}

class _DirectionsState extends State<Directions> {
  late final applicationBloc;

  final DirectionManager directionManager = DirectionManager();

  bool extendedNavigation = false;

  void _toggleExtendNavigationView() {
    setState(() => {extendedNavigation = !extendedNavigation});
  }

  @override
  void initState() {
    super.initState();

    applicationBloc = Provider.of<ApplicationBloc>(context, listen: false);

    var currentRoute = applicationBloc.route;

    directionManager.currentDirection = currentRoute.legs.first.steps.removeAt(0);

    // print("Current direction ${directionManager.currentDirection.instruction}");

    int duration = 0;
    int distance = 0;
    for(var i =0; i < currentRoute.legs.length; i++){
      directionManager.directions += currentRoute.legs[i].steps;
      duration = currentRoute.legs[i].duration;
      distance = currentRoute.legs[i].distance;
    }

    directionManager.setDuration(duration);
    directionManager.setDistance(distance);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () => _toggleExtendNavigationView(),
          child: SizedBox(
            height: !extendedNavigation
                ? MediaQuery.of(context).size.height * 0.16
                : directionManager.directions.length < 3
                    ? (directionManager.directions.length *
                            MediaQuery.of(context).size.height *
                            0.1) +
                        (MediaQuery.of(context).size.height * 0.16)
                    : MediaQuery.of(context).size.height * 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CurrentDirection(
                    currentDirection: directionManager.currentDirection),
                if (!extendedNavigation)
                  const Spacer()
                else if (directionManager.directions.isNotEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    child: Divider(thickness: 0.7),
                  ),
                extendedNavigation
                    ? SizedBox(
                        height: directionManager.directions.length < 3
                            ? (directionManager.directions.length) *
                                (MediaQuery.of(context).size.height * 0.08)
                            : MediaQuery.of(context).size.height * 0.3,
                        child: ListView.separated(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          itemCount: directionManager.directions.length,
                          itemBuilder: (BuildContext context, int index) {
                            return DirectionTile(
                                index: index,
                                directionManager: directionManager);
                          },
                          separatorBuilder: (context, index) {
                            return const Divider();
                          },
                        ),
                      )
                    : const Icon(Icons.expand_more),
                extendedNavigation
                    ? const Icon(Icons.expand_less)
                    : const SizedBox.shrink(),
              ],
            ),
          )),
    );
  }
}
