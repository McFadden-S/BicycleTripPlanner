import 'dart:async';

import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/managers/CameraManager.dart';
import 'package:bicycle_trip_planner/managers/DirectionManager.dart';
import 'package:bicycle_trip_planner/managers/LocationManager.dart';
import 'package:bicycle_trip_planner/widgets/general/CircleButton.dart';
import 'package:bicycle_trip_planner/widgets/general/DistanceETACard.dart';
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
  bool bottomSheetShown = true;
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
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
                child: Column(
                  children: [
                    Directions(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          children: [
                            CircleButton(
                                iconIn: Icons.location_searching,
                                onButtonClicked: () => CameraManager.instance.viewUser()),
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
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0)),
                ),
                height: bottomSheetShown
                    ? MediaQuery.of(context).size.height * 0.15
                    : MediaQuery.of(context).size.height * 0.05,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                            alignment: Alignment.topCenter,
                            icon: bottomSheetShown
                                ? Icon(Icons.keyboard_arrow_down)
                                : Icon(Icons.keyboard_arrow_up),
                            tooltip: 'Shrink',
                            onPressed: () {
                              print("icon pressed ******");
                              setState(() {
                                bottomSheetShown = !bottomSheetShown;
                              });
                            },
                          )),
                    ),
                    Visibility(
                      visible: bottomSheetShown,
                      child: Container(
                        margin:
                        EdgeInsets.only(bottom: 25.0, right: 15, left: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const DistanceETACard(),
                            WalkOrCycleToggle(directionManager: directionManager),
                            TextButton(
                                onPressed: () => applicationBloc.endRoute(),
                                child: Text("End",
                                    style: TextStyle(color: Colors.white)),
                                style: ButtonStyle(
                                    padding:
                                    MaterialStateProperty.all<EdgeInsets>(
                                        EdgeInsets.all(15)),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(18.0),
                                            side: BorderSide(color: Colors.red))),
                                    backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.red)))
                            // CircleButton(
                            //     iconIn: Icons.cancel_outlined,
                            //     onButtonClicked: () {
                            //       applicationBloc.endRoute();
                            //     },
                            //     buttonColor: Colors.red
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
