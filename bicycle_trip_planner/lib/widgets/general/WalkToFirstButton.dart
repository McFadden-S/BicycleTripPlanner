import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../bloc/application_bloc.dart';
import '../../constants.dart';
import '../../managers/DialogManager.dart';
import 'CircleButton.dart';

class WalkToFirstButton extends StatefulWidget {

  const WalkToFirstButton({ Key? key}) : super(key: key);

  @override
  _WalkToFirstButtonState createState() => _WalkToFirstButtonState();
}

class _WalkToFirstButtonState extends State<WalkToFirstButton> {

  final DialogManager dialogManager = DialogManager();
  final RouteManager routeManager = RouteManager();

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context);

    return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CircleButton(
                iconIn: Icons.directions_walk,
                onButtonClicked: () {
                  dialogManager.setBinaryChoice(
                    "Do you want to walk to start or be routed to it?",
                    "Walk",
                        (){routeManager.setWalkToFirstWaypoint(true);},
                    "Route",
                        (){routeManager.setWalkToFirstWaypoint(false);},
                  );

                  applicationBloc.showBinaryDialog();

                },
                iconColor: routeManager.getWalkToFirstWaypoint() ? Colors.amber : ThemeStyle.primaryIconColor,
              ),
            ],
          ),
        ]
    );
  }

}