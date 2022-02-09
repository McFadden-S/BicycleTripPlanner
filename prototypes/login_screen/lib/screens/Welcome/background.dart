import 'package:flutter/material.dart';

// welcome screen background
class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; // Gives height and width of screen
    return Container(
      height: size.height,
      width: double.infinity,
      child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              top: 0,
              left: size.width * 0.35,
              child: Image.asset("assets/icons/profile_icon.png"),
              width: size.width * 0.3, ),
            child,
          ]
      ),
    );
  }
}