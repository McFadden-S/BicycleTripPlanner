import 'package:flutter/material.dart';
import 'package:bicycle_trip_planner/constants.dart';

class OrDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; // Gives height and width of screen
    return Container(
        margin: EdgeInsets.symmetric(vertical: size.height * 0.02),
        width: size.width * 0.8,
        child: Row(
          children: <Widget>[
            buildDivider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                "Or",
                style: TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w600
                ),
              ),
            ),
            buildDivider(),
          ],
        )
    );
  }
}

class buildDivider extends StatelessWidget {
  const buildDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Divider(
        color: kPrimaryLightColor,
        height: 1.5,
      ),
    );
  }
}