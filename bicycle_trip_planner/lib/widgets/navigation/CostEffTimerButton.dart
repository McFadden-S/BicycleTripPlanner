import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/managers/PolylineManager.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/models/search_types.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer_count_down/timer_controller.dart';

import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/managers/DialogManager.dart';
import 'package:bicycle_trip_planner/widgets/general/buttons/CircleButton.dart';

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
    final applicationBloc = Provider.of<ApplicationBloc>(context, listen: false);

    return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CircleButton(
            onButtonClicked: () {
              if (!RouteManager().ifCostOptimised() || !RouteManager().ifCycling()) {
                null;
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                      "This feature is only available in cost efficiency mode!"),
                ));
              }
              else {
                if (isRunning){
                  dialogManager.setBinaryChoice(
                    "Would you like to reset your timer now?",
                    "Yes",
                        () {
                          widget.ctdwnController.restart();
                          widget.ctdwnController.pause();
                          setState(() => isRunning = !isRunning);
                        },
                    "No",
                        () {},
                  );
                } else {
                  dialogManager.setBinaryChoice(
                    "Would you like to start your 30 minute timer now?",
                    "Yes",
                        () {
                          widget.ctdwnController.start();
                          setState(() => isRunning = !isRunning);
                        },
                    "No", () {},
                  );
                }
                applicationBloc.showBinaryDialog();
              }
            },
            iconIn: !isRunning
                ? Icons.timer
                : Icons.restart_alt,
            iconColor: !RouteManager().ifCostOptimised() || !RouteManager().ifCycling()
                ? ThemeStyle.primaryIconColor.withOpacity(0.2)
                : ThemeStyle.primaryIconColor,
          ),
        ],
      ),
    ]);
  }
}