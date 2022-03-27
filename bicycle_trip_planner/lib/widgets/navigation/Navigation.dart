import 'dart:async';

import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/managers/CameraManager.dart';
import 'package:bicycle_trip_planner/managers/DirectionManager.dart';
import 'package:bicycle_trip_planner/managers/LocationManager.dart';
import 'package:bicycle_trip_planner/managers/NavigationManager.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/widgets/general/other/CustomBottomSheet.dart';
import 'package:bicycle_trip_planner/widgets/general/other/DistanceETACard.dart';
import 'package:bicycle_trip_planner/widgets/general/buttons/CurrentLocationButton.dart';
import 'package:bicycle_trip_planner/widgets/general/buttons/EndRouteButton.dart';
import 'package:bicycle_trip_planner/widgets/general/buttons/ViewRouteButton.dart';
import 'package:bicycle_trip_planner/widgets/navigation/CostEffTimerButton.dart';
import 'package:bicycle_trip_planner/widgets/navigation/CountdownCard.dart';
import 'package:bicycle_trip_planner/widgets/navigation/WalkOrCycleToggle.dart';
import 'package:flutter/material.dart';
import 'package:bicycle_trip_planner/widgets/navigation/Directions.dart';
import 'package:provider/provider.dart';
import 'package:timer_count_down/timer_controller.dart';

import '../../managers/MarkerManager.dart';
import '../../managers/StationManager.dart';
import '../general/dialogs/EndOfRouteDialog.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  final LocationManager locationManager = LocationManager();
  final DirectionManager directionManager = DirectionManager();
  final NavigationManager navigationManager = NavigationManager();
  final RouteManager routeManager = RouteManager();
  final MarkerManager markerManager = MarkerManager();
  final CountdownController controller = CountdownController();

  late final ApplicationBloc applicationBloc;
  late StreamSubscription locatorSubscription;

  @override
  void initState() {
    super.initState();
    applicationBloc = Provider.of<ApplicationBloc>(context, listen: false);
    CameraManager.instance.viewUser();
    markerManager.clearStationMarkers(StationManager().getStations());
  }

  @override
  void dispose() {
    applicationBloc.filterStationMarkers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ApplicationBloc>(context);
    return SafeArea(
      bottom: false,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
            child: Column(
              children: [
                Directions(),
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
                          routeManager.ifCostOptimised()
                          ? Column(
                            children: [
                              SizedBox(height: 10),
                              CostEffTimerButton(ctdwnController: controller),
                              SizedBox(height: 10),
                              CountdownCard(ctdwnController: controller),
                            ],)
                          : SizedBox.shrink()
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          EndOfRouteDialog(),
          CustomBottomSheet(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  SizedBox(width: 10),
                  DistanceETACard(),
                  SizedBox(width: 10),
                  Expanded(
                      child: WalkOrCycleToggle()),
                  SizedBox(width: 10),
                  Expanded(
                    child: EndRouteButton(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
