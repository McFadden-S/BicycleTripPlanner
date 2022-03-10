import 'dart:async';

import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/managers/CameraManager.dart';
import 'package:bicycle_trip_planner/managers/DirectionManager.dart';
import 'package:bicycle_trip_planner/managers/LocationManager.dart';
import 'package:bicycle_trip_planner/managers/StationManager.dart';
import 'package:bicycle_trip_planner/models/station.dart';
import 'package:bicycle_trip_planner/widgets/general/CustomBottomSheet.dart';
import 'package:bicycle_trip_planner/widgets/general/DistanceETACard.dart';
import 'package:bicycle_trip_planner/widgets/general/CurrentLocationButton.dart';
import 'package:bicycle_trip_planner/widgets/general/ViewRouteButton.dart';
import 'package:bicycle_trip_planner/widgets/navigation/Countdown.dart';
import 'package:bicycle_trip_planner/widgets/navigation/WalkOrCycleToggle.dart';
import 'package:flutter/material.dart';
import 'package:bicycle_trip_planner/widgets/navigation/Directions.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    super.initState();

    applicationBloc = Provider.of<ApplicationBloc>(context, listen: false);

    // Move to the user when navigation starts
    CameraManager.instance.viewUser();

    locatorSubscription = locationManager.location.onLocationChanged
        .listen((LocationData currentLocation) {
      // Use current location
      setState(() {
        CameraManager.instance.viewUser();
      });
    });

    applicationBloc.clearStationMarkersWithoutUID();
  }

  @override
  void dispose() {
    applicationBloc.filterStationMarkers();
    locatorSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                          Card(
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    color: Color(0xFF8B0000), width: 1),
                                borderRadius: BorderRadius.circular(9.0),
                              ),
                              child: Countdown(
                                  duration: directionManager.getDuration())),
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
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                applicationBloc.endRoute();
                                applicationBloc.setSelectedScreen('home');
                              },
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
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.red))),
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
