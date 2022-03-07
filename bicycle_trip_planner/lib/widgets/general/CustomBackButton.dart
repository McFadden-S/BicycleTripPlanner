import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'CircleButton.dart';

class CustomBackButton extends StatefulWidget {

  final String backTo;

  const CustomBackButton({ Key? key, required this.backTo}) : super(key: key);

  @override
  _StationCardState createState() => _StationCardState();
}

class _StationCardState extends State<CustomBackButton> {
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
                iconIn: Icons.arrow_back,
                onButtonClicked: () => applicationBloc.goBack(widget.backTo)
            ),
          ],
        ),
      ]
    );
  }
}
