import 'package:flutter/material.dart';
import 'package:prototypes/constants.dart';
import 'package:prototypes/screens/Welcome/welcome_screen.dart';


class back_button extends StatelessWidget {
  const back_button({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: Size(45, 45), // button width and height
      child: ClipOval(
        child: Material(
          color: kPrimaryColor, // button color
          child: InkWell(
            splashColor: kPrimaryLightColor, // splash color
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context){
                      return WelcomeScreen();
                    }
                ),
              );
            }, // button pressed
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}