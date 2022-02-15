import 'dart:async';

import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/models/steps.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_html/flutter_html.dart';

import '../constants.dart';

class Directions extends StatefulWidget {
  const Directions({Key? key}) : super(key: key);

  @override
  _DirectionsState createState() => _DirectionsState();
}

class _DirectionsState extends State<Directions> {
  late StreamSubscription directionSubscription;

  List<Steps> _directions = <Steps>[];
  late String journeyDuration;
  late String journeyDistance;

  void _setDuration(int seconds) {
    int minutes = (seconds / 60).ceil();
    journeyDuration = "$minutes min";
  }

  void _setDistance(int metre) {
    int km = (metre / 1000).ceil();
    journeyDistance = "$km km";
  }

  void _setDirection(List<Steps> steps) {
    _directions = steps;
  }

  Icon directionIcon(String direction) {
    return Icon(
      direction.toLowerCase().contains('left')
          ? Icons.arrow_back
          : direction.toLowerCase().contains('right')
              ? Icons.arrow_forward_outlined
              : direction.toLowerCase().contains('straight')
                  ? Icons.arrow_upward
                  : Icons.circle,
      color: buttonPrimaryColor,
      size: 60,
    );
  }

  bool extendedNavigation = false;

  void setExtendNavigationView() {
    setState(() => {extendedNavigation = !extendedNavigation});
  }

  void createDummyDirections() {
    List<Steps> steps = [];
    //steps.add(Steps(instruction: "Turn right", distance: 50, duration: 16));
    //steps.add(Steps(instruction: "Turn left", distance: 150, duration: 16));
    //steps.add(Steps(instruction: "Continue straight", distance: 250, duration: 16));
    //steps.add(Steps(instruction: "Continue straight", distance: 250, duration: 16));
    _setDirection(steps);
  }

  @override
  void initState() {
    super.initState();

    final applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);

    directionSubscription =
        applicationBloc.currentRoute.stream.listen((direction) {
      setState(() {
        _setDirection(direction.legs.steps);
        _setDuration(direction.legs.duration);
        _setDistance(direction.legs.distance);
      });
    });

    createDummyDirections();
  }

  @override
  void dispose() {
    final applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);
    applicationBloc.dispose();

    directionSubscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () => setExtendNavigationView(),
          child: SizedBox(
            height: !extendedNavigation
                ? 110
                : _directions.length < 3
                    ? (_directions.length) * 70 + 110
                    : 330,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Spacer(),
                      directionIcon(
                          "Turn left in 1 miles"), //_directions[0].instruction),
                      const Spacer(),
                      const Text(
                          "Turn left in 1 miles"), //_directions[0].instruction),
                      const Spacer(flex: 5),
                    ],
                  ),
                ),
                !extendedNavigation
                    ? const Spacer()
                    : const Padding(
                      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                      child: Divider(thickness: 0.7),
                    ),
                extendedNavigation
                    ? SizedBox(
                        height: _directions.length < 3
                            ? (_directions.length) * 70
                            : 220,
                        child: ListView.separated(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          itemCount: _directions.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                                leading: directionIcon(
                                    _directions[index].instruction),
                                trailing:
                                    Text("${_directions[index].distance} m"),
                                title: Html(
                                  data: _directions[index].instruction,
                                ));
                          },
                          separatorBuilder: (context, index) {
                            return const Divider();
                          },
                        ),
                      )
                    : const Icon(Icons.expand_more),
                extendedNavigation
                    ? const Icon(Icons.expand_less)
                    : const SizedBox.shrink(),
              ],
            ),
          )),
    );
  }
}
