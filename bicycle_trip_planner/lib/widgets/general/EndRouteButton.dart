import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../bloc/application_bloc.dart';
import '../../constants.dart';
import '../../managers/DialogManager.dart';
import 'CircleButton.dart';

class EndRouteButton extends StatefulWidget {
  const EndRouteButton({Key? key}) : super(key: key);

  @override
  _EndRouteButtonState createState() => _EndRouteButtonState();
}

class _EndRouteButtonState extends State<EndRouteButton> {
  final DialogManager dialogManager = DialogManager();
  final RouteManager routeManager = RouteManager();

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context);

    return ElevatedButton(
        onPressed: () {
          dialogManager.setBinaryChoice(
            "Would you like to end your route?",
            "Yes",
            () {
              applicationBloc.endRoute();
              applicationBloc.setSelectedScreen('home');
            },
            "No",
            () {
              routeManager.setWalkToFirstWaypoint(false);
            },
          );

          applicationBloc.showBinaryDialog();
        },
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("End", style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red)));
  }
}
