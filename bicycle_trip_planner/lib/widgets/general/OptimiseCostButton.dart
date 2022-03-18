import 'package:bicycle_trip_planner/managers/PolylineManager.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/models/search_types.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../bloc/application_bloc.dart';
import '../../constants.dart';
import '../../managers/DialogManager.dart';
import 'CircleButton.dart';

class OptimiseCostButton extends StatefulWidget {
  const OptimiseCostButton({Key? key}) : super(key: key);

  @override
  _OptimiseCostButtonState createState() => _OptimiseCostButtonState();
}

class _OptimiseCostButtonState extends State<OptimiseCostButton> {
  final DialogManager dialogManager = DialogManager();

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context);

    return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CircleButton(
            onButtonClicked: () {
              if (!RouteManager().ifCostOptimised()){
                dialogManager.setBinaryChoice(
                  "Are you sure you want to optimise your cost for this route?",
                  "Yes", () => RouteManager().setCostOptimised(true),
                  "No", () {},
                );
              } else {
                dialogManager.setBinaryChoice(
                  "Are you sure you want to stop optimising your cost for this route?",
                  "Yes", () => RouteManager().setCostOptimised(false),
                  "No", () {},
                );
              }
              applicationBloc.showBinaryDialog();
            },
            iconIn: RouteManager().ifCostOptimised()
                ?Icons.attach_money
                : Icons.money_off,
            iconColor: RouteManager().ifCostOptimised()
                ? Colors.amber
                : ThemeStyle.primaryIconColor,
          ),
        ],
      ),
    ]);
  }
}
