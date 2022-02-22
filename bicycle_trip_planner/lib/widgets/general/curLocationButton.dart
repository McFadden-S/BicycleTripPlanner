import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
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

    final applicationBloc = Provider.of<ApplicationBloc>(context);

    return FloatingActionButton(
      onPressed: (){
        applicationBloc.viewCurrentLocation();
      },
      child: Icon(Icons.location_searching_rounded),
    );
  }
}
