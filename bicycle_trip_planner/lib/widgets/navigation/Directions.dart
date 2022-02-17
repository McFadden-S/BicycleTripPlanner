import 'dart:async';

import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/managers/DirectionManager.dart';
import 'package:bicycle_trip_planner/models/steps.dart';
import 'package:bicycle_trip_planner/widgets/navigation/CurrentDirection.dart';
import 'package:bicycle_trip_planner/widgets/navigation/DirectionTile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_html/flutter_html.dart';

class Directions extends StatefulWidget {
  const Directions({Key? key}) : super(key: key);

  @override
  _DirectionsState createState() => _DirectionsState();
}

class _DirectionsState extends State<Directions> {

  final DirectionManager directionManager = DirectionManager();
  late StreamSubscription directionSubscription;

  Steps? _actual; // TODO: Temporary placeholders. Actual steps should be passed in
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
    if (steps.isNotEmpty) {
      _actual = steps[0];
      steps.removeAt(0);
      directionManager.directions = steps;
    } else {
      _actual = null;
      directionManager.directions = steps;
    }
  }

  bool extendedNavigation = false;

  void _toggleExtendNavigationView() {
    setState(() => {extendedNavigation = !extendedNavigation});
  }

  @override
  void initState() {
    super.initState();

    final applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);

    directionSubscription =
        applicationBloc.currentRoute.stream.listen((direction) {
      setState(() {
        directionManager.directions = direction.legs.steps;
        _setDuration(direction.legs.duration);
        _setDistance(direction.legs.distance);
      });
    });

    _setDirection(directionManager.createDummyDirections());
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
          onTap: () => _toggleExtendNavigationView(),
          // TODO: Change hardcoded design
          child: SizedBox(
            height: !extendedNavigation
                ? 110
                : directionManager.directions.length < 3
                    ? (directionManager.directions.length) * 70 + 110
                    : 330,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CurrentDirection(currentDirection: _actual!), 
                !extendedNavigation
                    ? const Spacer()
                    : const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                        child: Divider(thickness: 0.7),
                      ),
                  // TODO: Change hardcoded design
                extendedNavigation
                    ? SizedBox(
                        height: directionManager.directions.length < 3
                            ? (directionManager.directions.length) * 70
                            : 220,
                        child: ListView.separated(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          itemCount: directionManager.directions.length,
                          itemBuilder: (BuildContext context, int index) {
                            return DirectionTile(index: index, directionManager: directionManager);
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
