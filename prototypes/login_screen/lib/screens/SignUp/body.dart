import 'package:flutter/material.dart';
import 'package:prototypes/screens/SignUp/background.dart';
import 'package:prototypes/screens/components/back_button_to_welcome.dart';
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
    Size size = MediaQuery.of(context).size;
    return Background(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Sign Up",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Image.asset(
            "assets/images/signup_image.png",
            height: size.height * 0.35,
          ),
          RoundedInputField(
              hintText: "Email",
              onChanged: (value) {},
              ),
          RoundedPasswordField(
              text: "Password",
              onChanged: (value) {}
              ),
          RoundedPasswordField(
            text: "Confirm Password",
              onChanged: (value) {}
          ),
          RoundedButton(
            text: "Sign Up",
            press: () {},
          ),
          back_button()
        ],
      ),
    );
  }
}


