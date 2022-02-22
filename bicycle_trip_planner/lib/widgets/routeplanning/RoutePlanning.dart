import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/widgets/general/DistanceETACard.dart';
import 'package:bicycle_trip_planner/widgets/general/MapWidget.dart';
import 'package:bicycle_trip_planner/widgets/general/RoundedRectangleButton.dart';
import 'package:bicycle_trip_planner/widgets/routeplanning/RouteCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bicycle_trip_planner/widgets/general/CircleButton.dart';

class RoutePlanning extends StatefulWidget {
  const RoutePlanning({Key? key}) : super(key: key);

  @override
  _RoutePlanningState createState() => _RoutePlanningState();
}

class _RoutePlanningState extends State<RoutePlanning> {

  final TextEditingController startSearchController = TextEditingController();
  final TextEditingController destinationSearchController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final applicationBloc = Provider.of<ApplicationBloc>(context);
    int groupSizeValue = 1;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            MapWidget(),
            Column(
              children: [
                const Spacer(),
                Stack(
                    children: [RouteCard(
                      startSearchController: startSearchController,
                      destinationSearchController: destinationSearchController,
                    ),]
                ),
                const Spacer(),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  //TODO: an empty function is being passed here for now
                  CircleButton(
                      iconIn: Icons.location_searching,
                      onButtonClicked: () => {print("location_searching icon")})
                ]),
                const Spacer(),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  //TODO: an empty function is being passed here for now
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0, top: 10.0),
                    child: Container(
                      padding: const EdgeInsets.only(right: 2.0, left: 5.0),
                      decoration: const BoxDecoration(
                          color: const Color.fromRGBO(12, 156, 238, 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: DropdownButton<int>(
                          isDense: true,
                          value: groupSizeValue,
                          icon: const Icon(Icons.group, color: Colors.white),
                          iconSize: 30,
                          elevation: 16,
                          style: const TextStyle(color: Colors.white, fontSize: 18),
                          onChanged: (int? newValue) {
                            setState(() {
                              groupSizeValue = newValue!;
                            });
                          },
                          items: <int>[1, 2, 3, 4, 6, 7, 8, 9, 10]
                              .map<DropdownMenuItem<int>>((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(value.toString()),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  )
                ]),
                const Spacer(flex: 50),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  const DistanceETACard(),
                  const Spacer(flex: 10),
                  RoundedRectangleButton(
                      iconIn: Icons.directions_bike,
                      buttonColor: Colors.green,
                      onButtonClicked: () async {
                        applicationBloc.findRoute(
                            startSearchController.text,
                            destinationSearchController.text
                        );
                      }
                  )
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
