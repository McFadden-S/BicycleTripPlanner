import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bicycle_trip_planner/widgets/Login/components/RoundedTextButton.dart';
import 'package:bicycle_trip_planner/widgets/Login/components/InputField.dart';
import 'package:bicycle_trip_planner/constants.dart';
import 'components/ErrorSnackbar.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreen createState() => _ForgotPasswordScreen();
}

class _ForgotPasswordScreen extends State<ForgotPasswordScreen> {
  late String email;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Reset Password",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: ThemeStyle.mainFontColor,
                ),
              ),
              Flexible(
                child: Image.asset(
                  "assets/reset_password_image.png",
                  height: size.height * 0.35,
                ),
                flex: 1,
              ),
              Flexible(
                child: Text(
                  "Please enter your email to reset password",
                  style: TextStyle(
                    color: ThemeStyle.secondaryFontColor,
                  ),
                ),
                flex: 2,
              ),
              RoundedInputField(
                key: Key("emailField"),
                hintText: "Email",
                onChanged: (value) {
                  email = value;
                },
              ),
              RoundedTextButton(
                key: Key("reset"),
                text: "Send email to reset password",
                press: resetPassword, // to be modified...
              ),
              BackButton(
                key: Key("back"),
              ),
            ],
          ),
        ),
    );
  }

  Future resetPassword() async{
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ErrorSnackBar.buildErrorSnackbar(context, "password-reset-sent");
    } catch(e) {
      ErrorSnackBar.buildErrorSnackbar(context, e.toString());
    }
  }

}


