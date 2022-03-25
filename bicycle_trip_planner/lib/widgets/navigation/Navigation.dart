import 'dart:async';

import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/managers/CameraManager.dart';
import 'package:bicycle_trip_planner/managers/DirectionManager.dart';
import 'package:bicycle_trip_planner/managers/LocationManager.dart';
import 'package:bicycle_trip_planner/managers/NavigationManager.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/managers/StationManager.dart';
import 'package:bicycle_trip_planner/models/station.dart';
import 'package:bicycle_trip_planner/widgets/general/other/CustomBottomSheet.dart';
import 'package:bicycle_trip_planner/widgets/general/other/DistanceETACard.dart';
import 'package:bicycle_trip_planner/widgets/general/buttons/CurrentLocationButton.dart';
import 'package:bicycle_trip_planner/widgets/general/buttons/EndRouteButton.dart';
import 'package:bicycle_trip_planner/widgets/general/buttons/ViewRouteButton.dart';
import 'package:bicycle_trip_planner/widgets/general/buttons/CircleButton.dart';
import 'package:bicycle_trip_planner/widgets/navigation/CostEffTimerButton.dart';
import 'package:bicycle_trip_planner/widgets/general/dialogs/EndOfRouteDialog.dart';
import 'package:bicycle_trip_planner/widgets/general/dialogs/WalkBikeToggleDialog.dart';
import 'package:bicycle_trip_planner/widgets/navigation/CountdownCard.dart';
import 'package:bicycle_trip_planner/widgets/navigation/CustomCountdown.dart';
// import 'package:bicycle_trip_planner/widgets/navigation/CustomCountdown.dart';
import 'package:bicycle_trip_planner/widgets/navigation/WalkOrCycleToggle.dart';
import 'package:flutter/material.dart';
import 'package:bicycle_trip_planner/widgets/navigation/Directions.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  final LocationManager locationManager = LocationManager();
  final DirectionManager directionManager = DirectionManager();
  late final ApplicationBloc applicationBloc;
  late StreamSubscription locatorSubscription;
  final CountdownController _controller = new CountdownController();

  @override
  void initState() {
    super.initState();

    applicationBloc = Provider.of<ApplicationBloc>(context, listen: false);

    // Move to the user when navigation starts
    CameraManager.instance.viewUser();

    // locatorSubscription = locationManager
    //     .onUserLocationChange()
    //     .listen((LocationData currentLocation) {
    //   setState(() {
    //     CameraManager.instance.viewUser();
    //   });
    // });

    applicationBloc.clearStationMarkersNotInRoute();
  }

  @override
  void dispose() {
    applicationBloc.filterStationMarkers();
    //locatorSubscription.cancel();
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
                          SizedBox(height: 10),
                          CountdownCard(ctdwnController: _controller),
                          SizedBox(height: 10),
                          CostEffTimerButton(ctdwnController: _controller),
                          // CircleButton(
                          //     iconIn: Icons.access_alarm,
                          //     onButtonClicked: () {_controller.start();}
                          // ),
                          // CostEffTimerButton(),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          EndOfRouteDialog(),
          WalkBikeToggleDialog(),
          CustomBottomSheet(
            child: Container(
              margin: EdgeInsets.only(bottom: 10, right: 5, left: 5),
              child: Row(
                children: [
                  Expanded(child: DistanceETACard()),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: EndRouteButton(),
                        ),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: WalkOrCycleToggle(
                              directionManager: directionManager),
                        )),
                      ],
                    ),
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
