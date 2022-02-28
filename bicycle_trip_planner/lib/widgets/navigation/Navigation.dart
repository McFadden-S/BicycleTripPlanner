import 'dart:async';

import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/managers/CameraManager.dart';
import 'package:bicycle_trip_planner/managers/DirectionManager.dart';
import 'package:bicycle_trip_planner/managers/LocationManager.dart';
import 'package:bicycle_trip_planner/widgets/general/CircleButton.dart';
import 'package:bicycle_trip_planner/widgets/general/CustomBottomSheet.dart';
import 'package:bicycle_trip_planner/widgets/general/DistanceETACard.dart';
import 'package:bicycle_trip_planner/widgets/general/currentLocationButton.dart';
import 'package:bicycle_trip_planner/widgets/navigation/Countdown.dart';
import 'package:bicycle_trip_planner/widgets/navigation/WalkOrCycleToggle.dart';
import 'package:flutter/material.dart';
import 'package:bicycle_trip_planner/widgets/navigation/Directions.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  bool mapZoomed = true;
  DirectionManager directionManager = DirectionManager();
  late StreamSubscription locatorSubscription;

  void _toggleMapZoomInOut() {
    setState(() => {mapZoomed = !mapZoomed});
  }

  @override
  void initState() {
    super.initState();

    // Move to the user when navigation starts
    CameraManager.instance.viewUser();

    // TODO: POTENTIAL REFACTOR INTO MANAGER AND MAKE TOGGLEABLE
    locatorSubscription = Geolocator.getPositionStream(
        locationSettings: LocationManager().locationSettings())
        .listen((Position position) {
      setState(() {
        CameraManager.instance.viewUser();
      });
    });
  }

  @override
  void dispose() {
    locatorSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context);

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
                          CircleButton(
                            iconIn: mapZoomed
                                ? Icons.zoom_out_map
                                : Icons.fullscreen_exit,
                            onButtonClicked: () {
                              _toggleMapZoomInOut();
                            },
                          ),
                          SizedBox(height: 10),
                          Card(
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    color: Color(0xFF8B0000), width: 1),
                                borderRadius: BorderRadius.circular(9.0),
                              ),
                              child: Countdown(duration: directionManager.duration)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          CustomBottomSheet(
              child: Container(
                margin: EdgeInsets.only(bottom: 10, right: 5, left: 5),
                child: Row(
                  children: [
                    Expanded(child: DistanceETACard()),
                    Expanded(
                      child: Column(
                        children: [
                            Expanded(child: ElevatedButton(
                                onPressed: () => applicationBloc.endRoute(),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("End",
                                          style: TextStyle(color: Colors.white)),
                                    ],
                                  ),
                                ),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.red))),
                            ),
                            Expanded(child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: WalkOrCycleToggle(directionManager: directionManager),
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
