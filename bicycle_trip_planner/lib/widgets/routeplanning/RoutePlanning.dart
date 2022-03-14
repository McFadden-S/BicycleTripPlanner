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
  RoutePlanning({Key? key}) : super(key: key);

  @override
  _RoutePlanningState createState() => _RoutePlanningState();
}

class _RoutePlanningState extends State<RoutePlanning> {
  bool showRouteCard = true;
  bool isOptimised = false;

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
                showRouteCard ? RouteCard() : Container(),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {setState(() {
                    showRouteCard = false;
                  });},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Column(
                          children: [
                            !showRouteCard ?
                            CircleButton(
                                iconIn: Icons.search,
                                iconColor: ThemeStyle.primaryIconColor,
                                onButtonClicked: () {setState(() {
                                  showRouteCard = true;
                                }
                                );}) : Container(),
                            !showRouteCard ? SizedBox(height: 10) : Container(),
                            CurrentLocationButton(),
                            SizedBox(height: 10),
                            ViewRouteButton(),
                            SizedBox(height: 10),
                            GroupSizeSelector(),
                            SizedBox(height: 10),
                            CircleButton(
                              iconIn: Icons.alt_route,
                              onButtonClicked: () => setState(() {
                                showOptimisedBinaryDialog();
                              }),
                              iconColor: _routeManager.ifOptimised() ? Colors.amber : ThemeStyle.primaryIconColor,
                              // onButtonClicked: () => setState(() => {_routeManager.toggleOptimised()}),
                            ),
                            CircleButton(
                              iconIn: Icons.directions_walk,
                              iconColor: _routeManager.getWalkToFirstWaypoint() ? Colors.amber : ThemeStyle.primaryIconColor,
                              onButtonClicked: () => setState(() => {_routeManager.toggleWalkToFirstWaypoint()}),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
                        CustomBackButton(context: context, backTo: 'home'),
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

  void showOptimisedBinaryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(20.0)
          ),
          child: Container(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 10),
                    // isOptimised ?
                    Expanded(child: Text("Do you want to toggle route optimization?", textAlign: TextAlign.center)), //:
                    // Expanded(child: Text("Do you want to unoptimise the route?", textAlign: TextAlign.center)),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size.fromWidth(double.infinity)
                        ),
                        // onPressed: (){},
                        onPressed: () {
                          setState(() => {_routeManager.toggleOptimised()});
                          Navigator.pop(context);
                        },
                        child: Text("Yes"),
                      ),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size.fromWidth(double.infinity)
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: Text("No"),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              )
          ),
        );
      },
    );
  }

}

