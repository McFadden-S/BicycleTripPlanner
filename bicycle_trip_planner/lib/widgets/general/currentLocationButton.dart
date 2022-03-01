import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/managers/CameraManager.dart';
import 'package:flutter/material.dart';

import 'CircleButton.dart';

class CurrentLocationButton extends StatefulWidget {

  const CurrentLocationButton({
    Key? key,
  }) : super(key: key);

  @override
  _CurrentLocationButtonState createState() => _CurrentLocationButtonState();
}

class _CurrentLocationButtonState extends State<CurrentLocationButton> {

  @override
  Widget build(BuildContext context) {

    return CircleButton(
        iconIn: Icons.location_searching,
        onButtonClicked: () => CameraManager.instance.viewUser());
  }
}
