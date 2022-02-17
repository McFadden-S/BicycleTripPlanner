import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prototypes/Login/background.dart';
import 'package:prototypes/Login/components/rounded_button.dart';
import 'package:prototypes/Login/login_screen.dart';
import 'package:prototypes/Login/constants.dart';
import 'package:prototypes/Login/signup_screen.dart';
import 'package:prototypes/Login/components/elavated_button_with_icon.dart';
import 'package:prototypes/Login/components/or_divider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:prototypes/Login/google_sign_in.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreen createState() => _WelcomeScreen();
}

class _WelcomeScreen extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; // Gives height and width of screen

    final _auth = FirebaseAuth.instance;
    return Scaffold(
        body: Background(
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
                  press: () {
                    if (_auth.currentUser == null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return LoginScreen();
                          },
                        ),
                      );
                    }
                  }
              ),
              if (_auth.currentUser != null)
                RoundedButton(
                  text: "Logout",
                  press: () {
                    _auth.signOut();
                    setState(() => _auth.currentUser);
                  },
                ),
              SizedBox(height: size.height * 0.05),
              RoundedButton(
                text: "Sign Up",
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return SignUpScreen();
                    }),
                  );
                },
                color: kPrimaryLightColor,
                textColor: Colors.black,
              ),
              OrDivider(),
              ElavatedButtonWithIcon(
                text: "Sign Up/Log In With Google",
                press: () {
                  final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
                  provider.googleLogin();
                },
                icon: FaIcon(FontAwesomeIcons.google),
              ),
              ElavatedButtonWithIcon(
                text: "Temp Log Out",
                press: () {
                  final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
                  provider.logout();
                },
                icon: FaIcon(FontAwesomeIcons.google),
              ),
            ],
          ),
        ),
    );
  }
}