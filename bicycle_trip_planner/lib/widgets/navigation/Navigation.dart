import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/managers/CameraManager.dart';
import 'package:bicycle_trip_planner/managers/DirectionManager.dart';
import 'package:bicycle_trip_planner/managers/MarkerManager.dart';
import 'package:bicycle_trip_planner/managers/PolylineManager.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/models/search_types.dart';
import 'package:bicycle_trip_planner/widgets/general/CircleButton.dart';
import 'package:bicycle_trip_planner/widgets/general/DistanceETACard.dart';
import 'package:bicycle_trip_planner/widgets/general/curLocationButton.dart';
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
                  child: CurLocationButton(),
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
                    child: Countdown(duration: directionManager.duration))
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
                        endRoute(applicationBloc);
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

  void endRoute(ApplicationBloc appBloc) {
    appBloc.setSelectedScreen('home');
    directionManager.clear(); 
    PolylineManager().clearPolyline();
    MarkerManager().clearMarker(SearchType.start);
    MarkerManager().clearMarker(SearchType.end);
    if(RouteManager().ifIntermediatesSet()){
      int index = RouteManager().getIntermediates().length;
      for(int i = 1; i <= index; i++){
        MarkerManager().clearMarker(SearchType.intermediate, i);
        RouteManager().removeIntermediate(i);
      }
    }
    RouteManager().clearStart(); 
    RouteManager().clearDestination(); 
  }
}
