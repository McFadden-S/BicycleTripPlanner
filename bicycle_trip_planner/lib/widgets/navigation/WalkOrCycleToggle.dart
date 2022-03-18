import 'package:bicycle_trip_planner/constants.dart';
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
  late final ApplicationBloc appBloc;

  void setCycling() {
    setState(() => {appBloc.toggleCycling()});
  }

  @override
  void initState() {
    appBloc = Provider.of<ApplicationBloc>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Being built again!");
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
        print("Toggle button pressed");
        setCycling();
      },
    );
  }
}
