import 'package:flutter/material.dart';
import 'package:prototypes/screens/SignUp/background.dart';
import 'package:prototypes/screens/Welcome/welcome_screen.dart';
import 'package:prototypes/screens/components/back_button_to_welcome.dart';
import 'package:prototypes/screens/components/rounded_button.dart';
import 'package:prototypes/screens/components/rounded_input_field.dart';
import 'package:prototypes/screens/components/rounded_password_field.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../constants.dart';

class Body extends StatefulWidget {
  final Widget child;

  const Body({
    Key? key,
    required this.child
  }) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;
  String? confirmPassword;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
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
          Image.asset(
            "assets/images/signup_image.png",
            height: size.height * 0.35,
          ),
          RoundedInputField(

            hintText: "Email",
            onChanged: (value) {
              email = value;
            },
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
                final newUser = await _auth.createUserWithEmailAndPassword(
                    email: email, password: password);
                if(newUser != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) {
                          return WelcomeScreen();
                        }
                    ),
                  );
                }
              }
              catch(e){
                print(e);
              }
            },
          ),
          back_button()
        ],
      ),
    );
  }
}


