import 'dart:async';

import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/managers/CameraManager.dart';
import 'package:bicycle_trip_planner/managers/DirectionManager.dart';
import 'package:bicycle_trip_planner/managers/LocationManager.dart';
import 'package:bicycle_trip_planner/widgets/general/CircleButton.dart';
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
  void initState(){

    super.initState();
    
    // Move to the user when navigation starts
    CameraManager.instance.viewUser(); 

    // TODO: POTENTIAL REFACTOR INTO MANAGER AND MAKE TOGGLEABLE 
    locatorSubscription =
      Geolocator.getPositionStream(locationSettings: LocationManager().locationSettings())
          .listen((Position position) {
          setState(() {
            CameraManager.instance.viewUser(); 
          });
      });
  }

  @override
  void dispose(){
    locatorSubscription.cancel();
    super.dispose(); 
  }

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context);

    return SafeArea(
        child: Stack(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
          // TODO: Potential abstraction of the column?
          // TODO: Routeplanning also has 2 button at the side (can make a reusable widget of sorts)
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Directions(),
              const Spacer(),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                  child: CurrentLocationButton(),
                ),
              ]),
              const Spacer(),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                CircleButton(
                  iconIn:
                      mapZoomed ? Icons.zoom_out_map : Icons.fullscreen_exit,
                  onButtonClicked: () {
                    _toggleMapZoomInOut();
                  },
                  buttonColor: Colors.white,
                  iconColor: Colors.black54,
                ),
              ]),
              const Spacer(),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Card(
                    shape: RoundedRectangleBorder(
                      side:
                          const BorderSide(color: Color(0xFF8B0000), width: 1),
                      borderRadius: BorderRadius.circular(9.0),
                    ),
                    child: Countdown(duration: directionManager.getDuration()))
              ]),
              const Spacer(flex: 50),
              Row(
                children: [
                  const DistanceETACard(),
                  const Spacer(flex: 1),
                  WalkOrCycleToggle(directionManager: directionManager),
                  const Spacer(flex: 10),
                  CircleButton(
                      iconIn: Icons.cancel_outlined,
                      onButtonClicked: () {
                        applicationBloc.endRoute();
                        applicationBloc.setSelectedScreen('home'); 
                      },
                      buttonColor: Colors.red),
                ],
              ),
            ],
          ),
        )
      ],
    ));
  }
}
