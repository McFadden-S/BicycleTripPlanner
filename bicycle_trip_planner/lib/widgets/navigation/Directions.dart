import 'dart:async';

import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/managers/DirectionManager.dart';
import 'package:bicycle_trip_planner/models/steps.dart';
import 'package:bicycle_trip_planner/models/route.dart' as Rou;
import 'package:bicycle_trip_planner/widgets/navigation/CurrentDirection.dart';
import 'package:bicycle_trip_planner/widgets/navigation/DirectionTile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_html/flutter_html.dart';

class Directions extends StatefulWidget {

  final DirectionManager directionManager;

  const Directions({Key? key, required this.directionManager }) : super(key: key);

  @override
  _DirectionsState createState() => _DirectionsState();
}

class _DirectionsState extends State<Directions> {

  late final applicationBloc;

  //final DirectionManager directionManager = DirectionManager();
  late StreamSubscription directionSubscription;

  bool extendedNavigation = false;

  void _toggleExtendNavigationView() {
    setState(() => {extendedNavigation = !extendedNavigation});
  }

  // TODO: Potentially move this up to Navigation.dart, other widgets also need to listen to
  // directionManager. (Or make DirectionManager a singleton)
  @override
  void initState() {
    super.initState();

    applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);

    directionSubscription =
        applicationBloc.currentRoute.stream.listen((direction) {
      setState(() {
        widget.directionManager.currentDirection = direction.legs.steps.first;
        widget.directionManager.directions = direction.legs.steps.removeAt(0);
        widget.directionManager.setDuration(direction.legs.duration);
        widget.directionManager.setDistance(direction.legs.distance);
      });
    });

    // TODO: TEMPORARY SETUP USING APPLICATION API - TO BE REMOVED WHEN ROUTEPLANNING LINKS WITH NAVIGATION
      findRoute();
  }
  
  void findRoute() async {
    await applicationBloc.findRoute("Bush House, Aldwych, London, UK", "Waterloo Station, London, UK");

    setState((){
      widget.directionManager.currentDirection = applicationBloc.route.legs.steps.removeAt(0);
      widget.directionManager.directions = applicationBloc.route.legs.steps;
      widget.directionManager.setDuration(applicationBloc.route.legs.duration);
      widget.directionManager.setDistance(applicationBloc.route.legs.distance);
    });
  }

  @override
  void dispose() {

    directionSubscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () => _toggleExtendNavigationView(),
          child: SizedBox(
            height: !extendedNavigation
                ? MediaQuery.of(context).size.height * 0.16
                : widget.directionManager.directions.length < 3
                    ? (widget.directionManager.directions.length * MediaQuery.of(context).size.height * 0.1)
                    + (MediaQuery.of(context).size.height * 0.16)
                    : MediaQuery.of(context).size.height * 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CurrentDirection(currentDirection: widget.directionManager.currentDirection),
                if(!extendedNavigation) const Spacer() else
                    if(widget.directionManager.directions.isNotEmpty)
                      const Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          child: Divider(thickness: 0.7),
                        ), 
                extendedNavigation
                    ? SizedBox(
                        height: widget.directionManager.directions.length < 3
                            ? (widget.directionManager.directions.length) * (MediaQuery.of(context).size.height * 0.08)
                            : MediaQuery.of(context).size.height * 0.30,
                        child: ListView.separated(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          itemCount: widget.directionManager.directions.length,
                          itemBuilder: (BuildContext context, int index) {
                            return DirectionTile(index: index, directionManager: widget.directionManager);
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
