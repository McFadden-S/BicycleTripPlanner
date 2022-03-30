import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bicycle_trip_planner/widgets/settings/components/RoundedTextButton.dart';
import 'package:bicycle_trip_planner/widgets/settings/components/InputField.dart';
import 'package:bicycle_trip_planner/constants.dart';
import 'components/ErrorSnackbar.dart';


/// Forgot Password Screen to allow user to reset their password
class ForgotPasswordScreen extends StatefulWidget {
  var auth;
  var email;

  // Default constructor
  ForgotPasswordScreen({Key? key, this.auth, this.email}) : super(key: key);

  @override
  _ForgotPasswordScreen createState() => _ForgotPasswordScreen();

}

class _ForgotPasswordScreen extends State<ForgotPasswordScreen> {
  late String email;
  var _auth;

  // Initialises values to default if no passed in parameters
  @override
  void initState() {
    super.initState();
    _auth = widget.auth ?? FirebaseAuth.instance;
    email = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    // Gets the size of the user's screen
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: SafeArea(
          child: Container(
            color: ThemeStyle.cardColor,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Reset Password",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: ThemeStyle.primaryTextColor,
                    ),
                  ),
                  Flexible(
                    child: Image.asset(
                      "assets/reset_password_image.png",
                      height: size.height * 0.4,
                    ),
                    flex: 1,
                  ),
                  Flexible(
                    child: Text(
                      "Please enter your email to reset password",
                      style: TextStyle(
                        color: ThemeStyle.primaryTextColor,
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
                    text: "Reset password",
                    press: resetPassword, // to be modified...
                  ),
                  BackButton(
                    color: ThemeStyle.secondaryIconColor,
                    key: Key("back"),
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }

  // Attempts to send reset password email
  Future resetPassword() async{
    try{
      await _auth.sendPasswordResetEmail(email: email);
      ErrorSnackBar.buildErrorSnackbar(context, "password-reset-sent");
    } catch(e) {
      ErrorSnackBar.buildErrorSnackbar(context, e.toString());
    }
  }

}


