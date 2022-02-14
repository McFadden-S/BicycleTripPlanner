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
      direction.toLowerCase().contains('left') ?
      Icons.arrow_back :
      direction.toLowerCase().contains('right') ?
      Icons.arrow_forward_outlined :
      direction.toLowerCase().contains('straight') ?
      Icons.arrow_upward :
      Icons.circle,
      color: buttonPrimaryColor,
    );
  }


  @override
  void initState() {
    super.initState();

    final applicationBloc = Provider.of<ApplicationBloc>(context, listen: false);

    directionSubscription =
        applicationBloc.currentRoute.stream.listen((direction) {
          _setDirection(direction.legs.steps);
          _setDuration(direction.legs.duration);
          _setDistance(direction.legs.distance);
        });
  }

  @override
  void dispose() {
    final applicationBloc = Provider.of<ApplicationBloc>(context, listen: false);
    applicationBloc.dispose();

    directionSubscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ListView.separated(
        itemCount: _directions.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
              leading: directionIcon(_directions[index].instruction),
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
    );
  }
}






/*
Card(
color: Theme.of(context).primaryColor,
child: Padding(
padding: const EdgeInsets.all(12.0),
child: ListView.separated(
itemCount: _directions.length,
itemBuilder: (BuildContext context, int index) {
return ListTile(
leading: directionIcon(_directions[index].instruction),
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
)),
*/
