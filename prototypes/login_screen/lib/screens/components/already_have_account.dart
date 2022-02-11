import 'package:flutter/material.dart';
import 'package:prototypes/constants.dart';

// login screen
class AlreadyHaveAnAccount extends StatelessWidget {
  final bool login;
  final VoidCallback press;

  const AlreadyHaveAnAccount({
    Key? key,
    this.login = true,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login ? "Do not have an Account ? " : "Already have an Account ? ",
          style: TextStyle(color: secondaryFontColor),
        ),
        GestureDetector(
          onTap: press,
          child: Text(
            login ? "Sign Up" : "Sign In",
            style: TextStyle(
                color: secondaryFontColor,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}