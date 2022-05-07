import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/managers/DialogManager.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/models/route_types.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../bloc/application_bloc.dart';

class WalkOrCycleToggle extends StatefulWidget {
  const WalkOrCycleToggle({Key? key}) : super(key: key);

  @override
  _WalkOrCycleToggleState createState() => _WalkOrCycleToggleState();
}

class _WalkOrCycleToggleState extends State<WalkOrCycleToggle> {
  final DialogManager _dialogManager = DialogManager();
  final RouteManager _routeManager = RouteManager();

  void setCycling() {
    setState(() {
      RouteType routeType = _routeManager.getCurrentRoute().routeType;
      if (routeType == RouteType.walk) {
        _routeManager.showBikeRoute();
      } else {
        _routeManager.showCurrentWalkingRoute();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context);
    RouteType routeType = _routeManager.getCurrentRoute().routeType;

    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(ThemeStyle.buttonSecondaryColor)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.directions_walk,
            color: routeType == RouteType.bike ? Colors.black26 : Colors.red,
            size: 30,
          ),
          const Text(
            '/',
            style: TextStyle(fontSize: 25, color: Colors.black),
          ),
          Icon(
            Icons.directions_bike,
            color: routeType == RouteType.bike ? Colors.red : Colors.black26,
            size: 30,
          ),
        ],
      ),
      onPressed: () {
        _dialogManager.setBinaryChoice(
          "Toggle between walking and cycling?",
          "Toggle",
          () {
            setCycling();
          },
          "Cancel",
          () {},
        );

        applicationBloc.showBinaryDialog();
        applicationBloc.notifyListeningWidgets();
      },
    );
  }
}
