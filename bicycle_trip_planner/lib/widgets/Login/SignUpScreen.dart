import 'package:bicycle_trip_planner/widgets/Login/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:bicycle_trip_planner/widgets/Login/components/RoundedTextButton.dart';
import 'package:bicycle_trip_planner/widgets/Login/components/InputField.dart';
import 'package:bicycle_trip_planner/widgets/Login/components/PasswordField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'components/ErrorSnackbar.dart';
import 'package:bicycle_trip_planner/constants.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreen createState() => _SignUpScreen();
}

class _SignUpScreen extends State<SignUpScreen> {
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;
  late String confirmPassword;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Sign Up",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: ThemeStyle.mainFontColor,
                ),
              ),
              Flexible(
                child: Image.asset(
                  "assets/signup_image.png",
                  height: size.height * 0.35,
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
              RoundedPasswordField(
                  key: Key("confirmPasswordField"),
                  text: "Confirm Password",
                  onChanged: (value) {
                    confirmPassword = value;
                  }
              ),
              RoundedTextButton(
                key: Key("signUp"),
                text: "Sign Up",
                press: () async {
                  try {
                    if (password==confirmPassword){
                      await _auth.createUserWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      Navigator.pop(context);
                    }
                    else{
                      ErrorSnackBar.buildErrorSnackbar(context, "passwords-do-not-match");
                    }
                  } catch (e) {
                    //_showSnackBar(e.toString());
                    ErrorSnackBar.buildErrorSnackbar(context, e.toString());
                  }
                },
              ),Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Already have an Account? ",
                    style: TextStyle(color: ThemeStyle.secondaryFontColor),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return LoginScreen();
                        }),
                      );
                    },
                    child: Text(
                      " Login",
                      style: TextStyle(
                        color: ThemeStyle.secondaryFontColor,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              BackButton(
                key: Key("back"),
              )
            ],
          ),
        ),
    );
  }
}
