import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bicycle_trip_planner/widgets/Login/background.dart';
import 'package:bicycle_trip_planner/widgets/Login/components/rounded_button.dart';
import 'package:bicycle_trip_planner/widgets/Login/components/rounded_input_field.dart';
import 'constants.dart';
import 'components/error_snackbar.dart';

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
        body: Background(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Reset Password",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: mainFontColor,
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
                    color: secondaryFontColor,
                  ),
                ),
                flex: 2,
              ),
              RoundedInputField(
                hintText: "Email",
                onChanged: (value) {
                  email = value;
                },
              ),
              RoundedButton(
                text: "Send email to reset password",
                press: resetPassword, // to be modified...
              ),
              BackButton(),
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


