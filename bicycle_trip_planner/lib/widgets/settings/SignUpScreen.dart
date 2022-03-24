import 'package:bicycle_trip_planner/widgets/settings/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:bicycle_trip_planner/widgets/settings/components/RoundedTextButton.dart';
import 'package:bicycle_trip_planner/widgets/settings/components/InputField.dart';
import 'package:bicycle_trip_planner/widgets/settings/components/PasswordField.dart';
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
      resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Container(
            color: ThemeStyle.cardColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Sign Up",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: ThemeStyle.primaryTextColor,
                  ),
                ),
                Flexible(
                  child: Image.asset(
                    "assets/signup_image.png",
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
                        Navigator.pop(context, true);
                      }
                      else{
                        ErrorSnackBar.buildErrorSnackbar(context, "passwords-do-not-match");
                      }
                    } catch (e) {
                      ErrorSnackBar.buildErrorSnackbar(context, e.toString());
                    }
                  },
                ),Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Already have an Account? ",
                      style: TextStyle(color: ThemeStyle.primaryTextColor),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return LoginScreen();
                          }),
                        );
                      },
                      child: Text(
                        " Login",
                        style: TextStyle(
                          color: ThemeStyle.kPrimaryLightColor,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                BackButton(
                  color: ThemeStyle.secondaryIconColor,
                  key: Key("back"),
                )
              ],
            ),
          ),
        ),
    );
  }
}
