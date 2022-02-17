import 'package:bicycle_trip_planner/managers/DirectionManager.dart';
import 'package:bicycle_trip_planner/widgets/general/CircleButton.dart';
import 'package:bicycle_trip_planner/widgets/general/DistanceETACard.dart';
import 'package:bicycle_trip_planner/widgets/general/MapWidget.dart';
import 'package:bicycle_trip_planner/widgets/navigation/WalkOrCycleToggle.dart';
import 'package:flutter/material.dart';
import 'package:bicycle_trip_planner/widgets/navigation/Directions.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  
  bool mapZoomed = false;
  DirectionManager directionManager = DirectionManager(); 

  void _toggleMapZoomInOut() {
    setState(() => {mapZoomed = !mapZoomed});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          MapWidget(),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
            // TODO: Potential abstraction of the column?
            // Routeplanning also has 2 buttons at the side (can make a reusable widget of sorts)
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Directions(),
                const Spacer(),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  CircleButton(iconIn: Icons.location_on, onButtonClicked: (){}), 
                ]),
                const Spacer(),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  // TODO: Background should be white
                  CircleButton(
                    iconIn: mapZoomed ? Icons.zoom_out_map: Icons.fullscreen_exit, 
                    onButtonClicked: (){_toggleMapZoomInOut();}),
                ]),
                const Spacer(),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      side:
                          const BorderSide(color: Color(0xFF8B0000), width: 1),
                      borderRadius: BorderRadius.circular(9.0),
                    ),
                    child: Container(
                        padding: const EdgeInsets.all(5.0),
                        child: const Text(
                          "12 : 02",
                          style: TextStyle(
                            color: Color(0xFF8B0000),
                          ),
                        )),
                  )
                ]),
                const Spacer(flex: 50),
                Row(
                  children: [
                    const DistanceETACard(),
                    const Spacer(flex: 1),
                    WalkOrCycleToggle(directionManager: directionManager), 
                    const Spacer(flex: 10),
                    // TODO: Make cross white and background red
                    CircleButton(iconIn: Icons.cancel_outlined, onButtonClicked: (){}),
                  ],
                ),
              ],
            ),
          )
        ],
      )),
    );
  }
}
