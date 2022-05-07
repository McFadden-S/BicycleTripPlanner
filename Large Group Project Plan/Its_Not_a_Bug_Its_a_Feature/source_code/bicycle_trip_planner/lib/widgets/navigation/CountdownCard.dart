import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/managers/DirectionManager.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/models/route_types.dart';
import 'package:flutter/material.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class CountdownCard extends StatefulWidget {
  final CountdownController ctdwnController;
  const CountdownCard({Key? key, required this.ctdwnController})
      : super(key: key);

  @override
  _CountdownCardState createState() => _CountdownCardState();
}

class _CountdownCardState extends State<CountdownCard> {
  static const Color _green = Color(0xFF008000);
  static const Color _orange = Colors.deepOrangeAccent;
  static const Color _red = Color(0xFF8B0000);
  final DirectionManager directionManager = DirectionManager();

  @override
  Widget build(BuildContext context) {
    Color curColor =
    directionManager.getDurationValue() > 15
        ?  _green
        : directionManager.getDurationValue() > 5
            ? _orange
            : _red;


    RouteType routeType = RouteManager().getCurrentRoute().routeType;

    return Card(
      color: ThemeStyle.cardColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: curColor,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(9.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: RouteManager().ifCostOptimised() && routeType == RouteType.bike
              ? Countdown(
                  controller: widget.ctdwnController,
                  seconds: 1800, // 1800 seconds == 30 minutes
                  build: (_, double time) {
                    (time / 60).ceil() > 15
                        ? curColor = _green
                        : (time / 60).ceil() > 5
                            ? curColor = _orange
                            : curColor = _red;
                    return Text(
                      (time / 60) > 5
                          ? ((time / 60).ceil().toString() + " min")
                          : ((time / 60).floor().toString() +
                              ":" +
                              ((time % 60).toInt().toString().length == 1
                                  ? "0" + (time % 60).toInt().toString()
                                  : (time % 60).toInt().toString())),
                      style: TextStyle(
                        color: ThemeStyle.primaryTextColor,
                      ),
                    );
                  },
                  interval: Duration(milliseconds: 100),
                  onFinished: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Time\'s up!'),
                      ),
                    );
                  },
                )
              : Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
               directionManager.getDuration(),
                style: TextStyle(
                  color: ThemeStyle.primaryTextColor,
                ),
              )
          ),
        ));
  }
}
