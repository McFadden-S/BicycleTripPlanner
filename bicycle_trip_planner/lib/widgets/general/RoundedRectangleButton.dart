import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class RoundedRectangleButton extends StatefulWidget {
  final IconData iconIn;
  final VoidCallback onButtonClicked;
  final Color buttonColor;
  final bool withLoading;

  const RoundedRectangleButton(
      {Key? key,
      required this.iconIn,
      required this.onButtonClicked,
      required this.buttonColor,
      this.withLoading = false})
      : super(key: key);

  @override
  _StationCardState createState() => _StationCardState();
}

class _StationCardState extends State<RoundedRectangleButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.withLoading
          ? RouteManager().ifLoading()
              ? () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Loading in progress!"),
                  ));
                }
              : widget.onButtonClicked
          : widget.onButtonClicked,
      child: widget.withLoading
          ? RouteManager().ifLoading()
              ? CircularProgressIndicator(color: Colors.blueGrey)
              : Icon(
                  widget.iconIn,
                  color: ThemeStyle.primaryIconColor,
                )
          : Icon(
              widget.iconIn,
              color: ThemeStyle.primaryIconColor,
            ),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(17.0),
        ),
        padding:
            const EdgeInsets.only(left: 30, top: 10, bottom: 10, right: 30),
        primary: widget.buttonColor,
      ),
    );
  }
}
