import 'package:bicycle_trip_planner/managers/CameraManager.dart';
import 'package:bicycle_trip_planner/widgets/general/buttons/CircleButton.dart';
import 'package:flutter/material.dart';

class ViewRouteButton extends StatefulWidget {

  const ViewRouteButton({
    Key? key,
  }) : super(key: key);

  @override
  _ViewRouteButtonState createState() => _ViewRouteButtonState();
}

class _ViewRouteButtonState extends State<ViewRouteButton> {

  @override
  Widget build(BuildContext context) {

    return CircleButton(
        iconIn: Icons.zoom_out_map,
        onButtonClicked: () => CameraManager.instance.viewRoute());
  }
}
