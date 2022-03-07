import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/managers/DirectionManager.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/widgets/general/CircleButton.dart';
import 'package:bicycle_trip_planner/widgets/general/CustomBottomSheet.dart';
import 'package:bicycle_trip_planner/widgets/general/GroupSizeSelector.dart';
import 'package:bicycle_trip_planner/widgets/general/ViewRouteButton.dart';
import 'package:wakelock/wakelock.dart';
import 'package:bicycle_trip_planner/widgets/general/DistanceETACard.dart';
import 'package:bicycle_trip_planner/widgets/general/CustomBackButton.dart';
import 'package:bicycle_trip_planner/widgets/general/RoundedRectangleButton.dart';
import 'package:bicycle_trip_planner/widgets/general/CurrentLocationButton.dart';
import 'package:bicycle_trip_planner/widgets/routeplanning/RouteCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';

class RoutePlanning extends StatefulWidget {
  const RoutePlanning({Key? key}) : super(key: key);

  @override
  _RoutePlanningState createState() => _RoutePlanningState();
}

class _RoutePlanningState extends State<RoutePlanning> {

  final RouteManager _routeManager = RouteManager();
  final DirectionManager _directionManager = DirectionManager();

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context);

    return SafeArea(
      bottom: false,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                RouteCard(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        children: [
                          CurrentLocationButton(),
                          SizedBox(height: 10),
                          ViewRouteButton(),
                          SizedBox(height: 10),
                          GroupSizeSelector(),
                          SizedBox(height: 10),
                          CircleButton(
                              iconIn: Icons.alt_route,
                              iconColor: _routeManager.ifOptimised() ? Colors.amber : ThemeStyle.primaryIconColor,
                              onButtonClicked: () => setState(() => {_routeManager.toggleOptimised()}),
                          ),
                          CircleButton(
                            iconIn: Icons.directions_walk,
                            iconColor: _routeManager.getWalkToFirstWaypoint() ? Colors.amber : ThemeStyle.primaryIconColor,
                            onButtonClicked: () => setState(() => {_routeManager.toggleWalkToFirstWaypoint()}),
                          ),
                          CircleButton(
                            iconIn: Icons.location_on_outlined,
                            iconColor: _routeManager.getStartFromCurrentLocation() ? Colors.amber : ThemeStyle.primaryIconColor,
                            onButtonClicked: () => setState(() => {_routeManager.toggleStartFromCurrentLocation()}),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomBackButton(backTo: 'home'),
                      ]),
                ),
                CustomBottomSheet(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Wrap(
                          children: [ DistanceETACard() ],
                        ),
                        Expanded(
                          flex: 1,
                          child: RoundedRectangleButton(
                              iconIn: Icons.directions_bike,
                              buttonColor: ThemeStyle.goButtonColor,
                              onButtonClicked: () {
                                if (RouteManager().ifStartSet() &&
                                    RouteManager().ifDestinationSet()) {
                                  applicationBloc.setNavigating(true);
                                  applicationBloc.setSelectedScreen('navigation');
                                  _directionManager.showStartRoute();
                                  Wakelock.enable();
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content:
                                    Text("Start and Destination have not been set!"),
                                  ));
                                }
                              }),
                        )
                      ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
