import 'package:flutter/material.dart';
import 'package:prototypes/constants.dart';
import 'package:prototypes/screens/Welcome/background.dart';
import 'package:prototypes/screens/components/rounded_button.dart';
import 'package:prototypes/screens/Login/login_screen.dart';

//welcome screen body
class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; // Gives height and width of screen
    return Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Welcome to Bike Planner",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height * 0.03),
              RoundedButton(
                text: "Login",
                press: () {Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:(context) {
                        return LoginScreen();
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: size.height * 0.05),
              RoundedButton(
                text: "Sign Up",
                press: () {},
                color: kPrimaryLightColor,
                textColor: Colors.black,
              ),
            ],
          ),
        )
    );
  }
}
