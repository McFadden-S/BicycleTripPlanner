import 'package:flutter/material.dart';
import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/widgets/Login/ForgotPasswordScreen.dart';
import 'package:bicycle_trip_planner/widgets/Login/SignUpScreen.dart';
import 'package:bicycle_trip_planner/widgets/Login//components/RoundedTextButton.dart';
import 'package:bicycle_trip_planner/widgets/Login//components/InputField.dart';
import 'package:bicycle_trip_planner/widgets/Login//components/PasswordField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'components/ErrorSnackbar.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;


  @override
  void initState() {
    super.initState();
    email = "!";
    password = "!";
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;


    return Scaffold(
        body: SafeArea(
          child: Container(
            color: ThemeStyle.cardColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Login",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: ThemeStyle.primaryTextColor,
                  ),
                ),
                Flexible(
                  child: Image.asset(
                    "assets/login_image.png",
                    height: size.height * 0.4,
                  ),
                  flex: 1,
                ),
                Flexible(
                  child: RoundedInputField(
                    key: Key("emailField"),
                    hintText: "Email",
                    onChanged: (value) {
                      email = value;
                    },
                  ),
                  flex: 2,
                ),
                RoundedPasswordField(
                    key: Key("passwordField"),
                    text: "Password",
                    onChanged: (value) {
                      password = value;
                    }
                ),
                RoundedTextButton(
                  key: Key("login"),
                  text: "Login",
                  press: () async {
                    try {
                      await _auth.signInWithEmailAndPassword(
                          email: email, password: password);
                      Navigator.pop(context);
                    } catch (e) {
                      ErrorSnackBar.buildErrorSnackbar(context, e.toString());
                    }
                  },
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Do not have an Account? ",
                    style: TextStyle(color: ThemeStyle.primaryTextColor),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return SignUpScreen();
                        }),
                      );
                    },
                    child: Text(
                      " Sign Up",
                      style: TextStyle(
                        color: ThemeStyle.kPrimaryLightColor,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
                SizedBox(height: size.height * 0.01),
                GestureDetector(
                  key: Key("resetPassword"),
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
                      color: ThemeStyle.kPrimaryLightColor,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                BackButton(
                  color: ThemeStyle.primaryIconColor,
                  key: Key("back"),
                )
              ],
            ),
          ),
        ),
    );
  }
}
