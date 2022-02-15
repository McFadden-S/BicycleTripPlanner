import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/widgets/Map.dart';
import 'package:bicycle_trip_planner/widgets/RouteCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'CircleButton.dart';

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
                  CircleButton(
                      iconIn: Icons.group,
                      onButtonClicked: () => {print("group icon")})
                ]),
                const Spacer(flex: 50),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Card(
                      child: Container(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          children: [
                            Column(
                              children: const [Icon(Icons.timer), Text("[ETA]")]),
                            const Text("3.5 miles")
                      ],
                    ),
                  )),
                  const Spacer(flex: 10),
                  CircleButton(
                      iconIn: Icons.directions_bike,
                      onButtonClicked: () async {
                        applicationBloc.findRoute(
                            startSearchController.text, destinationSearchController.text);
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
