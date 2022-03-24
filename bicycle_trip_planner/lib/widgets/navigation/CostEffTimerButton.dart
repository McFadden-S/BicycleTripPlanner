import 'package:bicycle_trip_planner/managers/PolylineManager.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/models/search_types.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timer_count_down/timer_controller.dart';

import '../../constants.dart';
import '../../managers/DialogManager.dart';
import '../general/CircleButton.dart';

class CostEffTimerButton extends StatefulWidget {
  final CountdownController ctdwnController;
  const CostEffTimerButton({Key? key, required this.ctdwnController}) : super(key: key);

  @override
  _CostEffTimerButtonState createState() => _CostEffTimerButtonState();
}

class _CostEffTimerButtonState extends State<CostEffTimerButton> {
  final DialogManager dialogManager = DialogManager();
  bool isRunning = false;

  @override
  Widget build(BuildContext context) {

    return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CircleButton(
            onButtonClicked: () {
              if (!RouteManager().ifCostOptimised()) {
                null;
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                      "This feature is only available in cost efficiency mode!"),
                ));
              }
              else {
                if (isRunning){
                  widget.ctdwnController.restart();
                  widget.ctdwnController.pause();
                } else {
                  widget.ctdwnController.start();
                }
                setState(() => isRunning = !isRunning);
              }
            },
            iconIn: !isRunning
                ? Icons.start
                : Icons.restart_alt,
            iconColor: !RouteManager().ifCostOptimised()
                ? ThemeStyle.primaryIconColor.withOpacity(0.2)
                : ThemeStyle.primaryIconColor,
          ),
        ],
      ),
    ]);
  }
}