import 'package:flutter/material.dart';
import 'package:bicycle_trip_planner/widgets/Login/background.dart';
import 'package:bicycle_trip_planner/widgets/Login/components/rounded_button.dart';
import 'package:bicycle_trip_planner/widgets/Login/components/rounded_input_field.dart';
import 'package:bicycle_trip_planner/widgets/Login/components/rounded_password_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'constants.dart';

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
        body: Background(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Sign Up",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: mainFontColor,
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
              RoundedPasswordField(
                  text: "Confirm Password",
                  onChanged: (value) {
                    confirmPassword = value;
                  }
              ),
              RoundedButton(
                text: "Sign Up",
                press: () async {
                  try {
                    if (password==confirmPassword){
                      final newUser = await _auth.createUserWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                    }
                    else{
                      _showSnackBar("passwords-do-not-match");
                    }
                  } catch (e) {
                    _showSnackBar(e.toString());
                  }
                },
              ),
              BackButton()
            ],
          ),
        ),
    );
  }
  Future<void> _showSnackBar(String message) async {
    if (message.contains("wrong-password")){
      message="Incorrect password. Please try again";
    } else if (message.contains("unknown")){
      message="One of the fields is empty. Please try again";
    } else if (message.contains("email-already-in-use")){
      message="Email address was already used by another account";
    } else if (message.contains("invalid-email")){
      message="Email address entered is invalid";
    } else if (message.contains("weak-password")){
      message="Password must contain at least 6 characters";
    } else if (message.contains("passwords-do-not-match")) {
      message="Passwords do not match";
    }
    else {
      message="Error. Please try again";
    }
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.blue,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}


