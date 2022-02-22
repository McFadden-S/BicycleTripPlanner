import 'package:flutter/material.dart';
import 'package:bicycle_trip_planner/widgets/Login/constants.dart';
import 'package:bicycle_trip_planner/widgets/Login/forgot_password_screen.dart';
import 'package:bicycle_trip_planner/widgets/Login/background.dart';
import 'package:bicycle_trip_planner/widgets/Login/signup_screen.dart';
import 'package:bicycle_trip_planner/widgets/Login/welcome_screen.dart';
import 'package:bicycle_trip_planner/widgets/Login//components/already_have_account.dart';
import 'package:bicycle_trip_planner/widgets/Login//components/rounded_button.dart';
import 'package:bicycle_trip_planner/widgets/Login//components/rounded_input_field.dart';
import 'package:bicycle_trip_planner/widgets/Login//components/rounded_password_field.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    Future<void> _showSnackBar(String message) async {
      if (message.contains("user-not-found")) {
        message="User not found. Please try again";
      } else if (message.contains("wrong-password")){
        message="Incorrect password. Please try again";
      } else if (message.contains("unknown")){
        message="One of the fields is empty. Please try again";
      } else {
        message="Error. Please try again";
      }
      final snackBar = SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.blue,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    final _auth = FirebaseAuth.instance;
    late String email;
    late String password;
    return Scaffold(
        body: Background(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Login",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: mainFontColor,
                ),
              ),
              Flexible(
                child: Image.asset(
                  "assets/login_image.png",
                  height: size.height * 0.35,
                ),
                flex: 1,
              ),
              Flexible(
                child: RoundedInputField(
                  hintText: "Email",
                  onChanged: (value) {
                    email = value;
                  },
                ),
                flex: 2,
              ),
              RoundedPasswordField(
                  text: "Password",
                  onChanged: (value) {
                    password = value;
                  }
              ),
              RoundedButton(
                text: "Login",
                press: () async {
                  try {
                    final user = await _auth.signInWithEmailAndPassword(
                        email: email, password: password);
                    if (user != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return WelcomeScreen();
                        }),
                      );
                    }
                  } catch (e) {
                    _showSnackBar(e.toString());
                  }
                },
              ),
              AlreadyHaveAnAccount(
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return SignUpScreen();
                    }),
                  );
                },
              ),
              SizedBox(height: size.height * 0.01),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return ForgotPasswordScreen();
                    }),
                  );
                },
                child: Text(
                  "Reset Password",
                  style: TextStyle(
                    color: secondaryFontColor,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.02),
              BackButton()
            ],
          ),
        ),
    );
  }
}
