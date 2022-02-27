import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/managers/CameraManager.dart';
import 'package:flutter/material.dart';

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

    return FloatingActionButton(
      onPressed: (){
        CameraManager.instance.viewUser();
      },
      child: Icon(Icons.location_searching_rounded, color: ThemeStyle.secondaryIconColor,),
    );
  }
}
