import 'package:flutter/material.dart';
import 'package:prototypes/screens/Login/login_screen.dart';
import 'package:prototypes/screens/SignUp/background.dart';
import 'package:prototypes/screens/components/already_have_account.dart';
import 'package:prototypes/screens/components/rounded_button.dart';
import 'package:prototypes/screens/components/rounded_input_field.dart';
import 'package:prototypes/screens/components/rounded_password_field.dart';

class Body extends StatelessWidget {
  final Widget child;

  const Body({
    Key? key,
    required this.child
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Background(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Sign Up",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          // Put image here

          RoundedInputField(
              hintText: "Email",
              onChanged: (value) {},
              ),
          RoundedPasswordField(
              onChanged: (value) {}
              ),
          RoundedButton(
            text: "Sign Up",
            press: () {},
          ),
        ],
      ),
    );
  }
}
