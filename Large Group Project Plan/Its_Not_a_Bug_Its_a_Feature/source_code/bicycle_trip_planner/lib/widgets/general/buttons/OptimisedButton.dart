import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/managers/DialogManager.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/widgets/general/buttons/CircleButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OptimisedButton extends StatefulWidget {

  const OptimisedButton({ Key? key}) : super(key: key);

  @override
  _OptimisedButtonState createState() => _OptimisedButtonState();
}

class _OptimisedButtonState extends State<OptimisedButton> {

  final DialogManager dialogManager = DialogManager();
  final RouteManager routeManager = RouteManager();

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context);

    return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CircleButton(
                  iconIn: Icons.alt_route,
                  onButtonClicked: () {
                    dialogManager.setBinaryChoice(
                      "Do you want to optimise your route? Warning: Optimising route means stops will no longer be reorderable",
                      "Yes",
                          (){routeManager.setOptimised(true);},
                      "No",
                          (){routeManager.setOptimised(false);},
                    );

                    applicationBloc.showBinaryDialog();

                  },
                  iconColor: routeManager.ifOptimised() ? Colors.amber : ThemeStyle.primaryIconColor,
              ),
            ],
          ),
        ]
    );
  }

}