import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/managers/DirectionManager.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/widgets/general/CircleButton.dart';
import 'package:bicycle_trip_planner/widgets/general/CustomBottomSheet.dart';
import 'package:bicycle_trip_planner/widgets/general/GroupSizeSelector.dart';
import 'package:bicycle_trip_planner/widgets/general/OptimisedButton.dart';
import 'package:bicycle_trip_planner/widgets/general/ViewRouteButton.dart';
import 'package:bicycle_trip_planner/widgets/general/WalkToFirstButton.dart';
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
                  onTap: () {
                    setState(() {
                      showRouteCard = false;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Column(
                          children: [
                            !showRouteCard
                                ? CircleButton(
                                    iconIn: Icons.search,
                                    iconColor: ThemeStyle.primaryIconColor,
                                    onButtonClicked: () {
                                      setState(() {
                                        showRouteCard = true;
                                      });
                                    })
                                : Container(),
                            !showRouteCard ? SizedBox(height: 10) : Container(),
                            CurrentLocationButton(),
                            SizedBox(height: 10),
                            ViewRouteButton(),
                            SizedBox(height: 10),
                            GroupSizeSelector(),
                            SizedBox(height: 10),
                            OptimisedButton(),
                            SizedBox(height: 10),
                            WalkToFirstButton(),
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
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    CustomBackButton(context: context, backTo: 'home'),
                  ]),
                ),
                CustomBottomSheet(
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Wrap(
                      children: [DistanceETACard()],
                    ),
                    Expanded(
                      flex: 1,
                      child: RoundedRectangleButton(
                          iconIn: Icons.directions_bike,
                          buttonColor: ThemeStyle.goButtonColor,
                          onButtonClicked: () {
                            if (_routeManager.ifRouteSet()) {
                              applicationBloc.startNavigation();
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("No route could be found!"),
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
