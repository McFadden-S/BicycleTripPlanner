import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/managers/DirectionManager.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/widgets/general/CircleButton.dart';
import 'package:bicycle_trip_planner/widgets/general/ViewRouteButton.dart';
import 'package:wakelock/wakelock.dart';
import 'package:bicycle_trip_planner/widgets/general/DistanceETACard.dart';
import 'package:bicycle_trip_planner/widgets/general/CustomBackButton.dart';
import 'package:bicycle_trip_planner/widgets/general/RoundedRectangleButton.dart';
import 'package:bicycle_trip_planner/widgets/general/CurrentLocationButton.dart';
import 'package:bicycle_trip_planner/widgets/routeplanning/RouteCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';

class RoutePlanning extends StatefulWidget {
  const RoutePlanning({Key? key}) : super(key: key);

  @override
  _RoutePlanningState createState() => _RoutePlanningState();
}

class _RoutePlanningState extends State<RoutePlanning> {

  final RouteManager _routeManager = RouteManager();
  final DirectionManager _directionManager = DirectionManager();

  List<int> groupSizeOptions = <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context);

    return SafeArea(
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                RouteCard(),
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
                          Container(
                            padding:
                                const EdgeInsets.only(left: 3.0, right: 7.0),
                            decoration: BoxDecoration(
                              color: ThemeStyle.buttonPrimaryColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(30.0)),
                            ),
                            child: DropdownButton<int>(
                              isDense: true,
                              value: _routeManager.getGroupSize(),
                              icon:
                                  const Icon(Icons.group, color: Colors.white),
                              iconSize: 30,
                              elevation: 16,
                              style: const TextStyle(
                                  color: Colors.black45, fontSize: 18),
                              menuMaxHeight: 200,
                              onChanged: (int? newValue) =>
                                  _routeManager.setGroupSize(newValue!),
                              selectedItemBuilder: (BuildContext context) {
                                return groupSizeOptions.map((int value) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    child: Text(
                                      _routeManager.getGroupSize().toString(),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  );
                                }).toList();
                              },
                              items: groupSizeOptions
                                  .map<DropdownMenuItem<int>>((int value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Text(value.toString()),
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(height: 10),
                          CircleButton(
                              iconIn: Icons.alt_route,
                              iconColor: _routeManager.ifOptimised() ? Colors.amber : ThemeStyle.primaryIconColor,
                              onButtonClicked: () => setState(() => {_routeManager.toggleOptimised()}),
                          ),
                          SizedBox(height: 10),
                          CustomBackButton(backTo: 'home'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                         Wrap(
                           children: [ DistanceETACard() ],
                         ),
                         const Spacer(flex: 2),
                         Expanded(
                           flex: 1,
                           child: RoundedRectangleButton(
                                  iconIn: Icons.directions_bike,
                                  buttonColor: ThemeStyle.goButtonColor,
                                  onButtonClicked: () {
                                    if (RouteManager().ifStartSet() &&
                                        RouteManager().ifDestinationSet()) {
                                      applicationBloc.setNavigating(true);
                                      applicationBloc.setSelectedScreen('navigation');
                                      _directionManager.showStartRoute();
                                      Wakelock.enable();
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content:
                                            Text("Start and Destination have not been set!"),
                                      ));
                                    }
                    }),
                         )
              ]),
            ),
          ),
        ],
      ),
    );
  }

}
