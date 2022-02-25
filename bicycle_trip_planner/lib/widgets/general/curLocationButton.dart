import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/managers/CameraManager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CurLocationButton extends StatefulWidget {

  const CurLocationButton({
    Key? key,
  }) : super(key: key);

  @override
  _CurLocationButtonState createState() => _CurLocationButtonState();
}

class _CurLocationButtonState extends State<CurLocationButton> {

   @override
  Widget build(BuildContext context) {

    return FloatingActionButton(
      onPressed: (){
        CameraManager.instance.viewUser();
      },
      child: Icon(Icons.location_searching_rounded),
    );
  }
}
