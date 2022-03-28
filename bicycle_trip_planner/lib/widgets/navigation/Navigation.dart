import 'dart:async';

import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/managers/CameraManager.dart';
import 'package:bicycle_trip_planner/managers/DirectionManager.dart';
import 'package:bicycle_trip_planner/managers/LocationManager.dart';
import 'package:bicycle_trip_planner/managers/NavigationManager.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/widgets/general/other/CustomBottomSheet.dart';
import 'package:bicycle_trip_planner/widgets/general/other/DistanceETACard.dart';
import 'package:bicycle_trip_planner/widgets/general/buttons/EndRouteButton.dart';
import 'package:bicycle_trip_planner/widgets/navigation/CostEffTimerButton.dart';
import 'package:bicycle_trip_planner/widgets/navigation/CountdownCard.dart';
import 'package:bicycle_trip_planner/widgets/navigation/WalkOrCycleToggle.dart';
import 'package:flutter/material.dart';
import 'package:bicycle_trip_planner/widgets/navigation/Directions.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:timer_count_down/timer_controller.dart';

import '../../managers/MarkerManager.dart';
import '../../managers/StationManager.dart';
import '../general/buttons/CircleButton.dart';
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
  final CameraManager cameraManager = CameraManager.instance;

  late final ApplicationBloc applicationBloc;
  late StreamSubscription<LocationData> navigationSubscription;

  @override
  void initState() {
    super.initState();
    applicationBloc = Provider.of<ApplicationBloc>(context, listen: false);
    zoomOnUser();
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
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          setState(() {});
        },
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Directions(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CircleButton(
                            iconIn: Icons.center_focus_strong,
                            onButtonClicked: () => zoomOnUser()),
                        SizedBox(height: 10),
                        CircleButton(
                            iconIn: Icons.zoom_out_map,
                            onButtonClicked: () => zoomOnRoute()),
                        SizedBox(height: 10),
                      routeManager.ifCostOptimised()
                            ? Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  CostEffTimerButton(
                                      ctdwnController: controller),
                                  SizedBox(height: 10),
                                  CountdownCard(
                                      ctdwnController: controller),


                                ],
                              )
                            : SizedBox.shrink()
                      ],
                    ),
                  ],
                ),
              ],
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
                    Expanded(child: WalkOrCycleToggle()),
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
      ),
    );
  }

  zoomOnUser() {
    navigationSubscription = locationManager
        .onUserLocationChange(5)
        .listen((LocationData currentLocation) {
      cameraManager.viewUser(zoomIn: 20.0);
    });
  }

  zoomOnRoute() {
    navigationSubscription.cancel();
    cameraManager.viewRoute();
  }
}
