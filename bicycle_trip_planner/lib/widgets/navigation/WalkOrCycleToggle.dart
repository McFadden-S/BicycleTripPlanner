import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/managers/DialogManager.dart';
import 'package:bicycle_trip_planner/managers/DirectionManager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../bloc/application_bloc.dart';

class WalkOrCycleToggle extends StatefulWidget {
  final DirectionManager directionManager;

  const WalkOrCycleToggle({Key? key, required this.directionManager})
      : super(key: key);

  @override
  _WalkOrCycleToggleState createState() => _WalkOrCycleToggleState();
}

class _WalkOrCycleToggleState extends State<WalkOrCycleToggle> {
  final DialogManager _dialogManager = DialogManager();
  final DirectionManager _directionManager = DirectionManager();

  void setCycling() {
    setState(() => {_directionManager.toggleCycling()});
  }

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context);

    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(ThemeStyle.buttonSecondaryColor)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.directions_walk,
            color: widget.directionManager.ifCycling()
                ? Colors.black26
                : Colors.red,
            size: 30,
          ),
          const Text(
            '/',
            style: TextStyle(fontSize: 25, color: Colors.black),
          ),
          Icon(
            Icons.directions_bike,
            color: widget.directionManager.ifCycling()
                ? Colors.red
                : Colors.black26,
            size: 30,
          ),
        ],
      ),
      onPressed: () {
        _dialogManager.setBinaryChoice(
          "Toggle between walking and cycling?",
          "Toggle",
          () {
            setCycling();
          },
          "Cancel",
          () {},
        );

        applicationBloc.showBinaryDialog();
        applicationBloc.notifyListeningWidgets();
      },
    );
  }
}
