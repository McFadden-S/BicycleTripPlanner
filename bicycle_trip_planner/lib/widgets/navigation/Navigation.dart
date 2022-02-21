import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/managers/DirectionManager.dart';
import 'package:bicycle_trip_planner/widgets/general/CircleButton.dart';
import 'package:bicycle_trip_planner/widgets/general/DistanceETACard.dart';
import 'package:bicycle_trip_planner/widgets/navigation/Countdown.dart';
import 'package:bicycle_trip_planner/widgets/navigation/WalkOrCycleToggle.dart';
import 'package:flutter/material.dart';
import 'package:bicycle_trip_planner/widgets/navigation/Directions.dart';
import 'package:provider/provider.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  
  bool mapZoomed = true;
  DirectionManager directionManager = DirectionManager(); 

  void _toggleMapZoomInOut() {
    setState(() => {mapZoomed = !mapZoomed});
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
            // TODO: Routeplanning also has 2 buttons at the side (can make a reusable widget of sorts)
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Directions(directionManager: directionManager,),
                const Spacer(),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  CircleButton(iconIn: Icons.location_on, onButtonClicked: (){}, buttonColor: Colors.white, iconColor: Colors.black54), 
                ]),
                const Spacer(),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  CircleButton(
                    iconIn: mapZoomed ? Icons.zoom_out_map: Icons.fullscreen_exit, 
                    onButtonClicked: (){_toggleMapZoomInOut();},
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
                    child: Countdown(duration: directionManager.duration)
                  )
                ]),
                const Spacer(flex: 50),
                Row(
                  children: [
                    const DistanceETACard(),
                    const Spacer(flex: 1),
                    WalkOrCycleToggle(directionManager: directionManager), 
                    const Spacer(flex: 10),
                    CircleButton(iconIn: Icons.cancel_outlined, onButtonClicked: (){ endRoute(applicationBloc);}, buttonColor: Colors.red),
                  ],
                ),
              ],
            ),
          )
        ],
      ));
  }

  // TODO: The map needs to be cleared from start, end markers and the polyline
  void endRoute(ApplicationBloc appBloc) {
    appBloc.setSelectedScreen('home');
  }
}
