import 'package:flutter/material.dart';
import 'package:prototypes/constants.dart';
import 'package:prototypes/screens/SignUp/signup_screen.dart';
import 'package:prototypes/screens/Welcome/background.dart';
import 'package:prototypes/screens/components/or_divider.dart';
import 'package:prototypes/screens/components/rounded_button.dart';
import 'package:prototypes/screens/Login/login_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:prototypes/google_sign_in.dart';

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
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context){
                          return SignUpScreen();
                        }
                    ),
                  );
                },
                color: kPrimaryLightColor,
                textColor: Colors.black,
              ),
              OrDivider(),
              ElevatedButton.icon(
                onPressed: (){
                  final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
                  provider.googleLogin();
                },
                label: Text('Sign Up/Log In With Google'),
                icon: FaIcon(FontAwesomeIcons.google),
              ),
              ElevatedButton.icon(
                onPressed: (){
                  final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
                  provider.logout();
                },
                label: Text('Temp Log Out'),
                icon: FaIcon(FontAwesomeIcons.google),
              )
            ],
          ),
        )
    );
  }
}


