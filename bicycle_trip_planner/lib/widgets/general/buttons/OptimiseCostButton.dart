import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/managers/DialogManager.dart';
import 'package:bicycle_trip_planner/widgets/general/buttons/CircleButton.dart';

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
              if (RouteManager().getWaypoints().isNotEmpty && !RouteManager().ifCostOptimised()) {
                null;
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                      "Cost Efficiency can't be used with intermediate stops!"),
                ));
              } else {
                if (!RouteManager().ifCostOptimised()) {
                  dialogManager.setBinaryChoice(
                    "Are you sure you want to optimise your cost for this route?",
                    "Yes",
                    () => RouteManager().setCostOptimised(true),
                    "No",
                    () {},
                  );
                } else {
                  dialogManager.setBinaryChoice(
                    "Are you sure you want to stop optimising your cost for this route?",
                    "Yes",
                    () => RouteManager().setCostOptimised(false),
                    "No",
                    () {},
                  );
                }
                applicationBloc.showBinaryDialog();
              }
            },
            iconIn: RouteManager().ifCostOptimised()
                ? Icons.attach_money
                : Icons.money_off,
            iconColor: RouteManager().getWaypoints().isNotEmpty && !RouteManager().ifCostOptimised()
                ? ThemeStyle.primaryIconColor.withOpacity(0.2)
                : RouteManager().ifCostOptimised()
                    ? Colors.amber
                    : ThemeStyle.primaryIconColor,
          ),
        ],
      ),
    ]);
  }
}
