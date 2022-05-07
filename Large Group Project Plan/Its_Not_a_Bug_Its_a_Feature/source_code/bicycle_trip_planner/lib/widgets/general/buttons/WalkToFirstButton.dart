import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/managers/DialogManager.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/widgets/general/buttons/CircleButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WalkToFirstButton extends StatefulWidget {
  const WalkToFirstButton({Key? key}) : super(key: key);

  @override
  _WalkToFirstButtonState createState() => _WalkToFirstButtonState();
}

class _WalkToFirstButtonState extends State<WalkToFirstButton> {
  final DialogManager dialogManager = DialogManager();
  final RouteManager routeManager = RouteManager();

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context);

    return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CircleButton(
            key: Key("walkTo"),
            iconIn: Icons.directions_walk,
            onButtonClicked: () {
              print("I've been clicked");
              DialogManager().setBinaryChoice(
                "Do you want to walk to start or be routed to it?",
                "Walk",
                () {
                  RouteManager().setWalkToFirstWaypoint(true);
                },
                "Route",
                () {
                  RouteManager().setWalkToFirstWaypoint(false);
                },
              );

              applicationBloc.showBinaryDialog();
            },
            iconColor: routeManager.ifWalkToFirstWaypoint()
                ? Colors.amber
                : ThemeStyle.primaryIconColor,
          ),
        ],
      ),
    ]);
  }
}
